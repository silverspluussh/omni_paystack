// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:omni_paystack/omni_client_webview.dart';

enum PaystackPaymentChanel { mobile_mobile, bank, card, etf }

enum Currency { GHS, NGN, USD, KES }

// extensions
extension ChannelExt on PaystackPaymentChanel {
  String get cname {
    switch (this) {
      case PaystackPaymentChanel.bank:
        return "bank";
      case PaystackPaymentChanel.mobile_mobile:
        return "mobile_money";
      case PaystackPaymentChanel.etf:
        return "etf";
      case PaystackPaymentChanel.card:
        return "card";
    }
  }
}

extension CurrencyExt on Currency {
  String get cname {
    switch (this) {
      case Currency.GHS:
        return "GHS";
      case Currency.NGN:
        return "NGN";
      case Currency.USD:
        return "USD";
      case Currency.KES:
        return "KES";
    }
  }
}

//Functions
String generateReferenceID() {
  const String pushChars =
      '-0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz';
  int lastPushTime = 0;
  List lastRandChars = [];
  int now = DateTime.now().millisecondsSinceEpoch;
  bool duplicateTime = (now == lastPushTime);
  lastPushTime = now;
  List timeStampChars = List<String>.filled(8, '0');
  for (int i = 7; i >= 0; i--) {
    timeStampChars[i] = pushChars[now % 64];
    now = (now / 64).floor();
  }
  if (now != 0) {
    //print("Id should be unique");
  }
  String uniqueId = timeStampChars.join('');
  if (!duplicateTime) {
    for (int i = 0; i < 12; i++) {
      lastRandChars.add((Random().nextDouble() * 64).floor());
    }
  } else {
    int i = 0;
    for (int i = 11; i >= 0 && lastRandChars[i] == 63; i--) {
      lastRandChars[i] = 0;
    }
    lastRandChars[i]++;
  }
  for (int i = 0; i < 12; i++) {
    uniqueId += pushChars[lastRandChars[i]];
  }
  return uniqueId;
}



class Constants {
  static const String initUrl =
      "https://api.paystack.co/transaction/initialize";
  static const String transactionUrl =
      "https://api.paystack.co/transaction/verify";
}

class ParamNotifiers {
  const ParamNotifiers._();

  static ValueNotifier<String?> secretKey = ValueNotifier(null);
  static ValueNotifier<String?> reference = ValueNotifier(null);
  static ValueNotifier<String?> recipientEmail = ValueNotifier(null);
  static ValueNotifier<String?> callBackUrl = ValueNotifier(null);
  static ValueNotifier<VoidCallback?> onFailed = ValueNotifier(null);
    static ValueNotifier<CallbackFunction?> callBack = ValueNotifier(null);

  static ValueNotifier<PaystackPaymentChanel?> channel =
      ValueNotifier(null);
  static ValueNotifier<double?> amount = ValueNotifier(null);
  static ValueNotifier<Currency?> currency = ValueNotifier(null);
  static ValueNotifier<Map<dynamic, dynamic>?> metaData = ValueNotifier(null);
}
