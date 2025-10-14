class InscripcionResponse {
  final String message;
  final String url;
  final String transactionId;
  final String status;

  InscripcionResponse({
    required this.message,
    required this.url,
    required this.transactionId,
    required this.status,
  });

  factory InscripcionResponse.fromJson(Map<String, dynamic> json) {
    return InscripcionResponse(
      message: json['message'],
      url: json['url'],
      transactionId: json['transaction_id'],
      status: json['status'],
    );
  }
}