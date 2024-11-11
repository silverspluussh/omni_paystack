class PaystackReqResponse {
  final String ref;
  final String url;
  final bool status;
  PaystackReqResponse(
      {required this.ref, required this.url, required this.status});


  factory PaystackReqResponse.fromMap(Map<String, dynamic> map) {
    return PaystackReqResponse(
      ref: map["data"]['reference'] as String,
      url: map["data"]['authorization_url'] as String,
      status: map['status'] as bool,
    );
  }

}
class PayloadResponse {
  dynamic status;
  String message;
  PaymentData data;

  PayloadResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PayloadResponse.fromJson(Map<String, dynamic> json) {
    return PayloadResponse(
      status: json['status'],
      message: json['message'],
      data: PaymentData.fromJson(json['data']),
    );
  }


}

class PaymentData {
  dynamic id;
  String domain;
  String status;
  String reference;
  dynamic receiptNumber;
  dynamic amount;
  dynamic message;
  String gatewayResponse;
  dynamic paidAt;
  dynamic createdAt;
  String channel;
  String currency;
  String ipAddress;
  Map<String, dynamic> metadata;
  PaymentLog log;
  dynamic fees;
  dynamic feesSplit;
  PaymentAuthorization authorization;
  PaymentCustomer customer;
  dynamic plan;
  Map<String, dynamic> split;
  dynamic orderId;
  DateTime? paidAtObj;
  DateTime? createdAtObj;
  dynamic requestedAmount;
  dynamic posTransactionData;
  dynamic source;
  dynamic feesBreakdown;
  dynamic connect;
  dynamic transactionDate;
  dynamic planObject;
  dynamic subaccount;

  PaymentData({
    required this.id,
    required this.domain,
    required this.status,
    required this.reference,
    required this.receiptNumber,
    required this.amount,
    this.message,
    required this.gatewayResponse,
    required this.paidAt,
    required this.createdAt,
    required this.channel,
    required this.currency,
    required this.ipAddress,
    required this.metadata,
    required this.log,
    required this.fees,
    this.feesSplit,
    required this.authorization,
    required this.customer,
    this.plan,
    required this.split,
    this.orderId,
    this.paidAtObj,
    this.createdAtObj,
    required this.requestedAmount,
    this.posTransactionData,
    this.source,
    this.feesBreakdown,
    this.connect,
    required this.transactionDate,
    this.planObject,
    this.subaccount,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      id: json['id'],
      domain: json['domain'],
      status: json['status'],
      reference: json['reference'],
      receiptNumber: json['receipt_number'],
      amount: json['amount'],
      message: json['message'],
      gatewayResponse: json['gateway_response'],
      paidAt: DateTime.parse(json['paid_at']),
      createdAt: DateTime.parse(json['created_at']),
      channel: json['channel'],
      currency: json['currency'],
      ipAddress: json['ip_address'],
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : {},
      log: PaymentLog.fromJson(json['log']),
      fees: json['fees'],
      feesSplit: json['fees_split'],
      authorization: PaymentAuthorization.fromJson(json['authorization']),
      customer: PaymentCustomer.fromJson(json['customer']),
      plan: json['plan'],
      split: json['split'] != null ? Map<String, dynamic>.from(json['split']) : {},
      orderId: json['order_id'],
      paidAtObj: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      createdAtObj: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      requestedAmount: json['requested_amount'],
      posTransactionData: json['pos_transaction_data'],
      source: json['source'],
      feesBreakdown: json['fees_breakdown'],
      connect: json['connect'],
      transactionDate: DateTime.parse(json['transaction_date']),
      planObject: json['plan_object'],
      subaccount: json['subaccount'],
    );
  }


}

class PaymentLog {
  dynamic startTime;
  dynamic timeSpent;
  dynamic attempts;
  dynamic errors;
  dynamic success;
  dynamic mobile;
  List<dynamic> input;
  List<PaymentLogHistory> history;

  PaymentLog({
    required this.startTime,
    required this.timeSpent,
    required this.attempts,
    required this.errors,
    required this.success,
    required this.mobile,
    required this.input,
    required this.history,
  });

  factory PaymentLog.fromJson(Map<String, dynamic> json) {
    return PaymentLog(
      startTime: json['start_time'],
      timeSpent: json['time_spent'],
      attempts: json['attempts'],
      errors: json['errors'],
      success: json['success'],
      mobile: json['mobile'],
      input: json['input'] != null ? List<dynamic>.from(json['input']) : [],
      history: json['history'] != null
          ? (json['history'] as List<dynamic>)
              .map((item) => PaymentLogHistory.fromJson(item))
              .toList()
          : [],
    );
  }


}

class PaymentLogHistory {
  String type;
  String message;
  dynamic time;

  PaymentLogHistory({
    required this.type,
    required this.message,
    required this.time,
  });

  factory PaymentLogHistory.fromJson(Map<String, dynamic> json) {
    return PaymentLogHistory(
      type: json['type'],
      message: json['message'],
      time: json['time'],
    );
  }

}

class PaymentAuthorization {
  String authorizationCode;
  String bin;
  String last4;
  dynamic expMonth;
  dynamic expYear;
  String channel;
  String? cardType;
  String bank;
  String countryCode;
  String brand;
  dynamic reusable;
  String? signature;
  String? accountName;
  String mobileMoneyNumber;
  String? receiverBankAccountNumber;
  String? receiverBank;

  PaymentAuthorization({
    required this.authorizationCode,
    required this.bin,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.channel,
    this.cardType,
    required this.bank,
    required this.countryCode,
    required this.brand,
    required this.reusable,
    this.signature,
    this.accountName,
    required this.mobileMoneyNumber,
    this.receiverBankAccountNumber,
    this.receiverBank,
  });

  factory PaymentAuthorization.fromJson(Map<String, dynamic> json) {
    return PaymentAuthorization(
      authorizationCode: json['authorization_code'],
      bin: json['bin'],
      last4: json['last4'],
      expMonth: json['exp_month'],
      expYear: json['exp_year'],
      channel: json['channel'],
      cardType: json['card_type'],
      bank: json['bank'],
      countryCode: json['country_code'],
      brand: json['brand'],
      reusable: json['reusable'],
      signature: json['signature'],
      accountName: json['account_name'],
      mobileMoneyNumber: json['mobile_money_number'],
      receiverBankAccountNumber: json['receiver_bank_account_number'],
      receiverBank: json['receiver_bank'],
    );
  }

  
}

class PaymentCustomer {
  dynamic id;
  String firstName;
  String lastName;
  String email;
  String customerCode;
  String? phone;
  Map<String, dynamic>? metadata;
  String riskAction;
  String? internationalFormatPhone;

  PaymentCustomer({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.customerCode,
    this.phone,
    this.metadata,
    required this.riskAction,
    this.internationalFormatPhone,
  });

  factory PaymentCustomer.fromJson(Map<String, dynamic> json) {
    return PaymentCustomer(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      customerCode: json['customer_code'],
      phone: json['phone'],
      metadata: json['metadata'] != null ? Map<String, dynamic>.from(json['metadata']) : null,
      riskAction: json['risk_action'],
      internationalFormatPhone: json['international_format_phone'],
    );
  }

 
}