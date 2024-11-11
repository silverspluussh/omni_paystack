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
                        "****************",
                    reference: ref,
                    recipientEmail: "****************",
                    onFailed: () {},
                    metaData: {"time": "monday"},
                    callBackUrl: "****************",
                    currency: Currency.GHS,
                    channel: PaystackPaymentChanel.mobile_mobile,
                    amount: 00000);
              },
              child: Text("pay with omni"),
            )
          ],
        ),
      ),
    );
  }
}
