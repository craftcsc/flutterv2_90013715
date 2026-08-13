import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/transaction_repository.dart';
import '../../domain/transaction_model.dart';
import '../../../auth/data/auth_repository.dart';

class PaginatedTransactionsState {
  final List<TransactionModel> transactions;
  final bool isLoading;
  final bool isFetchingMore;
  final bool hasMore;
  final String? errorMessage;
  final DocumentSnapshot? lastDocument;

  PaginatedTransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.errorMessage,
    this.lastDocument,
  });

  PaginatedTransactionsState copyWith({
    List<TransactionModel>? transactions,
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasMore,
    String? errorMessage,
    DocumentSnapshot? lastDocument,
  }) {
    return PaginatedTransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
      lastDocument: lastDocument ?? this.lastDocument,
    );
  }
}

final paginatedTransactionsProvider = StateNotifierProvider.autoDispose<
    PaginatedTransactionsNotifier, PaginatedTransactionsState>((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return PaginatedTransactionsNotifier(repository, authRepository);
});

class PaginatedTransactionsNotifier
    extends StateNotifier<PaginatedTransactionsState> {
  final TransactionRepository _repository;
  final AuthRepository _authRepository;
  static const int pageSize = 5; // Paginación de 5 en 5 para facilitar la demo en video

  PaginatedTransactionsNotifier(this._repository, this._authRepository)
      : super(PaginatedTransactionsState()) {
    loadInitialPage();
  }

  Future<void> loadInitialPage() async {
    final userId = _authRepository.currentUser?.uid;
    if (userId == null) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Debes iniciar sesión para ver tus transacciones.',
      );
      return;
    }

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final result = await _repository.getPaginatedTransactions(
        userId: userId,
        pageSize: pageSize,
      );

      state = state.copyWith(
        transactions: result.transactions,
        lastDocument: result.lastDocument,
        hasMore: result.hasMore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error al cargar las transacciones: ${e.toString()}',
      );
    }
  }

  Future<void> loadNextPage() async {
    if (state.isFetchingMore || !state.hasMore || state.lastDocument == null) {
      return;
    }

    final userId = _authRepository.currentUser?.uid;
    if (userId == null) return;

    state = state.copyWith(isFetchingMore: true);

    try {
      final result = await _repository.getPaginatedTransactions(
        userId: userId,
        pageSize: pageSize,
        lastDocument: state.lastDocument,
      );

      state = state.copyWith(
        transactions: [...state.transactions, ...result.transactions],
        lastDocument: result.lastDocument ?? state.lastDocument,
        hasMore: result.hasMore,
        isFetchingMore: false,
      );
    } catch (e) {
      state = state.copyWith(
        isFetchingMore: false,
        errorMessage: 'Error al cargar más transacciones: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    state = PaginatedTransactionsState();
    await loadInitialPage();
  }
}
