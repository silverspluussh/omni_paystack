library omni_paystack;

import 'package:flutter/material.dart';
import 'package:omni_paystack/omni_client_webview.dart';

import 'omni_utils.dart';

/// A Calculator.
class OmniPaystack implements OmniPaystackController {

@override
  onInit(
      {required BuildContext context,
      required String secretKey,
      required String reference,
      required String recipientEmail,
      required VoidCallback onFailed,
      required String callBackUrl,
      required Currency currency,
            required CallbackFunction onSuccessResponse,

      required PaystackPaymentChanel channel,
      required double amount,
      Map<dynamic, dynamic>? metaData}) async {
    await setValues(
        secretKey: secretKey,
        reference: reference,
        onSuccessResponse: onSuccessResponse,
        recipientEmail: recipientEmail,
        onFailed: onFailed,
        callBackUrl: callBackUrl,
        currency: currency,
        channel: channel,
        amount: amount);

    if (context.mounted) {
      return Navigator.push(context,
          MaterialPageRoute(builder: (context) => const OmniClientWebview()));
    }



  }

@override
  generateReference() => generateReferenceID();

  static Future<void> setValues(
      {required String secretKey,
      required String reference,
      required String recipientEmail,
      required VoidCallback onFailed,
      required String callBackUrl,
      required Currency currency,
            required CallbackFunction onSuccessResponse,

      required PaystackPaymentChanel channel,
      required double amount,
      Map<dynamic, dynamic>? metaData}) async {
    ParamNotifiers.amount.value = amount;
    ParamNotifiers.secretKey.value = secretKey;
    ParamNotifiers.reference.value = reference;
    ParamNotifiers.recipientEmail.value = recipientEmail;
    ParamNotifiers.callBackUrl.value = callBackUrl;
    ParamNotifiers.onFailed.value = onFailed;
    ParamNotifiers.currency.value = currency;
    ParamNotifiers.metaData.value = metaData;
    ParamNotifiers.channel.value = channel;
        ParamNotifiers.callBack.value = onSuccessResponse;

  }
}

abstract class OmniPaystackController {
  onInit(
      {required BuildContext context,
      required String secretKey,
      required String reference,
      required String recipientEmail,
      required VoidCallback onFailed,
      required String callBackUrl,
      required Currency currency,
      required CallbackFunction onSuccessResponse,
      required PaystackPaymentChanel channel,
      required double amount,
      Map<dynamic, dynamic>? metaData});

  generateReference();
}
