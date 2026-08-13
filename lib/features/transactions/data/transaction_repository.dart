import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/transaction_model.dart';

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepository(FirebaseFirestore.instance);
});

class TransactionRepository {
  final FirebaseFirestore _firestore;

  TransactionRepository(this._firestore);

  /// Colección de transacciones anidada por usuario: `users/{userId}/transactions`
  /// Esto permite realizar consultas ordenadas por fecha sin requerir índices compuestos en Firestore.
  CollectionReference _userTransactionsCollection(String userId) =>
      _firestore.collection('users').doc(userId).collection('transactions');

  /// Guardar una nueva transacción en Firestore
  Future<String> createTransaction(TransactionModel transaction) async {
    final docRef = await _userTransactionsCollection(transaction.userId)
        .add(transaction.toFirestore());
    return docRef.id;
  }

  /// Consulta paginada de transacciones por usuario
  /// [pageSize] indica el límite de documentos por página.
  /// [lastDocument] se utiliza como cursor para Firestore `startAfterDocument`.
  Future<PaginatedTransactionResult> getPaginatedTransactions({
    required String userId,
    required int pageSize,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _userTransactionsCollection(userId)
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();

    final transactions = querySnapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();

    final DocumentSnapshot? newLastDocument =
        querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

    final bool hasMore = querySnapshot.docs.length == pageSize;

    return PaginatedTransactionResult(
      transactions: transactions,
      lastDocument: newLastDocument,
      hasMore: hasMore,
    );
  }
}

class PaginatedTransactionResult {
  final List<TransactionModel> transactions;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedTransactionResult({
    required this.transactions,
    this.lastDocument,
    required this.hasMore,
  });
}
