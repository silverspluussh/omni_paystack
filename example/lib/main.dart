import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:omni_paystack/omni_paystack.dart';
import 'package:omni_paystack/omni_utils.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Examm(),
    );
  }
}

class Examm extends StatelessWidget {
  const Examm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello World!'),
            MaterialButton(
              onPressed: () async {
                String ref = OmniPaystack().generateReference();
                await OmniPaystack().onInit(
                    context: context,
                    onSuccessResponse: (response) {
                      log(response.message);
                    },
                    secretKey:
                        "sk_test_8e7c31c8cba584befafe04a48f49fbe562e044a8",
                    reference: ref,
                    recipientEmail: "pantagoros@gmail.com",
                    onFailed: () {},
                    metaData: {"time": "monday"},
                    callBackUrl: "www.telicalhealth.com",
                    currency: Currency.GHS,
                    channel: PaystackPaymentChanel.mobile_mobile,
                    amount: 12203);
              },
              child: Text("pay with omni"),
            )
          ],
        ),
      ),
    );
  }
}
