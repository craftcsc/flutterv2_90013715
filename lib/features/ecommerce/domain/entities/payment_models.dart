import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_models.freezed.dart';
part 'payment_models.g.dart';

@freezed
class TestCard with _$TestCard {
  const factory TestCard({
    required String number,
    required String holder,
    required String behavior,
    double? availableFunds,
    String? declineReason,
  }) = _TestCard;

  factory TestCard.fromJson(Map<String, dynamic> json) => _$TestCardFromJson(json);
}

@freezed
class PaymentRequest with _$PaymentRequest {
  const factory PaymentRequest({
    required double amount,
    required String cardNumber,
    @Default('USD') String currency,
  }) = _PaymentRequest;

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => _$PaymentRequestFromJson(json);
}

@freezed
class PaymentResponse with _$PaymentResponse {
  const factory PaymentResponse({
    required bool success,
    required String status,
    String? transactionId,
    required double amount,
    required String currency,
    required String cardLast4,
    required String message,
    required String timestamp,
  }) = _PaymentResponse;

  factory PaymentResponse.fromJson(Map<String, dynamic> json) => _$PaymentResponseFromJson(json);
}
