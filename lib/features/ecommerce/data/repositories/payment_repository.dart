import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/payment_models.dart';

class PaymentRepository {
  final http.Client _client;
  
  static const String _testCardsUrl = 'https://testcards-sfdkfoab2q-uc.a.run.app';
  static const String _processPaymentUrl = 'https://processpayment-sfdkfoab2q-uc.a.run.app';

  PaymentRepository({http.Client? client}) : _client = client ?? http.Client();

  Future<List<TestCard>> getTestCards() async {
    try {
      final response = await _client.get(Uri.parse(_testCardsUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> cardsJson = data['testCards'];
        return cardsJson.map((json) => TestCard.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load test cards');
      }
    } catch (e) {
      throw Exception('Error fetching test cards: $e');
    }
  }

  Future<PaymentResponse> processPayment(PaymentRequest request) async {
    try {
      final response = await _client.post(
        Uri.parse(_processPaymentUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );
      
      if (response.statusCode == 200 || response.statusCode == 400 || response.statusCode == 405) {
        // The mock backend returns 200 even for declined/insufficient funds,
        // and error details are in the body
        return PaymentResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to process payment');
      }
    } catch (e) {
      throw Exception('Error processing payment: $e');
    }
  }
}
