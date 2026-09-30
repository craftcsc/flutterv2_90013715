import 'package:flutter_test/flutter_test.dart';
import 'package:flutterv2_90013715/features/ecommerce/domain/entities/product.dart';
import 'package:flutterv2_90013715/features/ecommerce/domain/entities/payment_models.dart';
import 'package:flutterv2_90013715/features/transactions/domain/transaction_model.dart';

void main() {
  group('E-Commerce Domain Unit Tests', () {
    test('Product model serialization and deserialization', () {
      final product = Product(
        id: 'p1',
        name: 'Camisa Test',
        price: 25.5,
        imageUrl: 'https://example.com/img.jpg',
        availableSizes: ['S', 'M'],
        availableColors: ['0xFF000000'],
      );

      final json = product.toJson();
      expect(json['name'], 'Camisa Test');
      expect(json['price'], 25.5);

      final fromJson = Product.fromJson(json);
      expect(fromJson.id, product.id);
      expect(fromJson.name, product.name);
    });

    test('PaymentRequest model generates valid payload for teacher service', () {
      const req = PaymentRequest(
        amount: 150.0,
        cardNumber: '4111111111111111',
        currency: 'USD',
      );

      final json = req.toJson();
      expect(json['amount'], 150.0);
      expect(json['cardNumber'], '4111111111111111');
      expect(json['currency'], 'USD');
    });

    test('TransactionModel calculates items properly', () {
      final tx = TransactionModel(
        id: 'tx_123',
        userId: 'user_abc',
        userEmail: 'test@correo.com',
        totalAmount: 100.0,
        items: [
          TransactionItem(id: 'i1', title: 'Item 1', price: 50.0, quantity: 2),
        ],
        paymentMethod: 'Tarjeta (1111)',
        status: 'Completado',
        createdAt: DateTime(2026, 1, 1),
      );

      final firestoreMap = tx.toFirestore();
      expect(firestoreMap['userId'], 'user_abc');
      expect(firestoreMap['totalAmount'], 100.0);
      expect(firestoreMap['items'], hasLength(1));
    });
  });
}
