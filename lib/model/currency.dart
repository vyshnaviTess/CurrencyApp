class GbpCurrency {
  final String currency;
  final String currencyCode;
  final double amount;

  GbpCurrency({
    required this.currency,
    required this.currencyCode,
    required this.amount,
  });

  factory GbpCurrency.fromJson(Map<String, dynamic> json) => GbpCurrency(
        currency: json['currency'],
        currencyCode: json['currencyCode'],
        amount: json['amount'],
      );

  Map<String, dynamic> toJson() => {
        'currency': currency,
        'currencyCode': currencyCode,
        'amount': amount,
      };
}
