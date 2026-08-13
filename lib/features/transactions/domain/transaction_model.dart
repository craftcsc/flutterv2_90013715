import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  TransactionItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'quantity': quantity,
    };
  }

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class TransactionModel {
  final String id;
  final String userId;
  final String userEmail;
  final double totalAmount;
  final List<TransactionItem> items;
  final String paymentMethod;
  final String status;
  final DateTime createdAt;
  final DocumentSnapshot? snapshot;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.userEmail,
    required this.totalAmount,
    required this.items,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    this.snapshot,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userEmail': userEmail,
      'totalAmount': totalAmount,
      'items': items.map((i) => i.toMap()).toList(),
      'paymentMethod': paymentMethod,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final Timestamp? timestamp = data['createdAt'] as Timestamp?;
    final rawItems = data['items'] as List<dynamic>? ?? [];

    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userEmail: data['userEmail'] ?? '',
      totalAmount: (data['totalAmount'] as num?)?.toDouble() ?? 0.0,
      items: rawItems
          .map((item) => TransactionItem.fromMap(Map<String, dynamic>.from(item)))
          .toList(),
      paymentMethod: data['paymentMethod'] ?? 'Tarjeta',
      status: data['status'] ?? 'Completado',
      createdAt: timestamp?.toDate() ?? DateTime.now(),
      snapshot: doc,
    );
  }
}
