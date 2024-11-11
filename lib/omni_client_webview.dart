import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:omni_paystack/models.dart';
import 'omni_utils.dart';
import 'package:dio/dio.dart';

class _OmniClientWebviewState extends State<OmniClientWebview> {
  late GlobalKey webKey;
  InAppWebViewController? inAppWebViewController;
  late PullToRefreshController? pullToRefreshController;
  late InAppWebViewSettings settings;

  @override
  void initState() {
    webKey = GlobalKey();
    settings = InAppWebViewSettings(
        userAgent: "Omnipaystack;Inappwebview",
        useShouldOverrideUrlLoading: true,
        javaScriptEnabled: true,
        allowContentAccess: true);
    pullToRefreshController = (kIsWeb ||
            [TargetPlatform.android, TargetPlatform.iOS]
                .contains(defaultTargetPlatform))
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(color: Colors.primaries.first),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                inAppWebViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                inAppWebViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await inAppWebViewController?.getUrl()));
              }
            },
          );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Material(
          type: MaterialType.canvas,
          color: Colors.white,
          child: FutureBuilder<PaystackReqResponse?>(
              future: initializePaymentRequest(context),
              builder: (context, response) {
                if (response.hasData && response.data?.status == true) {
                  return SafeArea(
                    child: InAppWebView(
                        key: webKey,
                        initialUrlRequest:
                            URLRequest(url: WebUri(response.data!.url)),
                        initialSettings: settings,
                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) =>
                            inAppWebViewController = controller,
                        onReceivedError: (controller, request, error) {},
                        shouldOverrideUrlLoading: (controller, action) async {
                          final uri = action.request.url;
                          if (uri != null) {
                            if (uri.host
                                .contains(ParamNotifiers.callBackUrl.value!)) {
                              await checkCycleStatus(response.data!.ref);
                              Navigator.of(context).pop();
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (uri.host.contains("cancelurl.com")) {
                              await checkCycleStatus(response.data!.ref);
                              Navigator.of(context).pop();
                              return NavigationActionPolicy.CANCEL;
                            }
                            if (uri.host.contains("paystack.co/close")) {
                              await checkCycleStatus(response.data!.ref);
                              Navigator.of(context).pop();
                              return NavigationActionPolicy.CANCEL;
                            }
                            return NavigationActionPolicy.ALLOW;
                          }

                          return NavigationActionPolicy.ALLOW;
                        }),
                  );
                }
                if (response.hasError) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: widget.errorWidget ??
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(response.error.toString(),
                                  textAlign: TextAlign.center),
                              const SizedBox(height: 20),
                              MaterialButton(
                                  height: 45,
                                  minWidth: 300,
                                  color: Colors.blue,
                                  child: const Text(
                                    "Try again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {}),
                              const SizedBox(height: 10),
                              MaterialButton(
                                  height: 45,
                                  minWidth: 300,
                                  color: Colors.red,
                                  child: const Text(
                                    "Close",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => Navigator.of(context).pop()),
                            ]),
                  );
                }
                return widget.loadingWidget ??
                    const Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator.adaptive()),
                    );
              }),
        ));
  }
}

typedef CallbackFunction = void Function(PayloadResponse response);

Future checkCycleStatus(String ref) async {
  final Dio dio = Dio();
  final String key = ParamNotifiers.secretKey.value ?? "";

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $key"
  };
  try {
    final Response response = await dio.get("${Constants.transactionUrl}/$ref",
        options: Options(headers: headers));

    if (response.statusCode == 200 || response.statusCode == 202) {
      final data = response.data;
      log(response.data.toString());
      if (data["data"]["gateway_response"] == "Approved") {
        ParamNotifiers.callBack.value!(PayloadResponse.fromJson(response.data));
      } else {
        ParamNotifiers.onFailed.value ?? () {};
      }
    } else {
      throw (response.data.toString());
    }
  } on DioException catch (e) {
    throw (e.message.toString());
  }
}

//initialize Payment request to paystack
Future<PaystackReqResponse?> initializePaymentRequest(
    BuildContext context) async {
  final Dio dio = Dio();
  final String key = ParamNotifiers.secretKey.value ?? "";

  final headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $key"
  };

  final body = {
    "email": ParamNotifiers.recipientEmail.value!,
    "amount": ParamNotifiers.amount.value!,
    "reference": ParamNotifiers.reference.value!,
    "currency": ParamNotifiers.currency.value!.cname,
    "plan": "",
    "metadata": "{}",
    "callback_url": ParamNotifiers.callBackUrl.value!,
    "channels": [ParamNotifiers.channel.value!.cname]
  };

  try {
    Response response = await dio.post(Constants.initUrl,
        options: Options(headers: headers, validateStatus: (status) => true),
        data: body);

    if (response.statusCode == 200 || response.statusCode == 202) {
      return PaystackReqResponse.fromMap(response.data);
    }
    throw ("${response.data["message"]}\n${response.data["meta"]["nextStep"]}");
  } on DioException catch (e) {
    throw (e.message.toString());
  }
}

class OmniClientWebview extends StatefulWidget {
  const OmniClientWebview({super.key, this.errorWidget, this.loadingWidget});
  final Widget? errorWidget;
  final Widget? loadingWidget;

  @override
  State<OmniClientWebview> createState() => _OmniClientWebviewState();
}
