import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/payment_provider.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../transactions/data/transaction_repository.dart';
import '../../../transactions/domain/transaction_model.dart';
import '../../presentation/providers/cart_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final int _currentStep = 3; // Payment step

  String? _selectedCardNumber;
  final TextEditingController _amountController = TextEditingController(text: '150');
  final TextEditingController _manualCardController = TextEditingController();
  bool _isAddingManualCard = false;

  @override
  void dispose() {
    _amountController.dispose();
    _manualCardController.dispose();
    super.dispose();
  }

  void _processPayment() async {
    final l10n = AppLocalizations.of(context);
    final amount = double.tryParse(_amountController.text) ?? 150.0;
    final cardNumber = _isAddingManualCard ? _manualCardController.text : _selectedCardNumber;

    if (cardNumber == null || cardNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter a card number.')),
      );
      return;
    }

    await ref.read(paymentProcessProvider.notifier).processPayment(amount, cardNumber);

    if (!mounted) return;

    final paymentState = ref.read(paymentProcessProvider);
    paymentState.whenData((response) async {
      if (response != null) {
        if (response.success) {
          // Registrar la transacción en Firestore
          final authRepo = ref.read(authRepositoryProvider);
          final currentUser = authRepo.currentUser;
          final cartItems = ref.read(cartControllerProvider).asData?.value ?? [];

          final items = cartItems.isNotEmpty
              ? cartItems
                  .map((c) => TransactionItem(
                        id: c.product.id,
                        title: c.product.name,
                        price: c.product.price,
                        quantity: c.quantity,
                      ))
                  .toList()
              : [
                  TransactionItem(
                    id: 'item_demo',
                    title: 'Producto E-Commerce Demo',
                    price: amount,
                    quantity: 1,
                  )
                ];

          final transaction = TransactionModel(
            id: '',
            userId: currentUser?.uid ?? 'guest_user',
            userEmail: currentUser?.email ?? 'invitado@demo.com',
            totalAmount: amount,
            items: items,
            paymentMethod: 'Tarjeta (${cardNumber.substring(cardNumber.length > 4 ? cardNumber.length - 4 : 0)})',
            status: 'Completado',
            createdAt: DateTime.now(),
          );

          try {
            await ref.read(transactionRepositoryProvider).createTransaction(transaction);
          } catch (e) {
            debugPrint('Error al guardar la transacción en Firestore: $e');
          }
        }

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(response.success ? 'Pago Aprobado' : 'Pago Rechazado'),
            content: Text(response.success
                ? '${response.message}\nLa transacción ha sido guardada en Firestore.'
                : response.message),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  if (response.success) {
                    context.go('/transactions');
                  }
                },
                child: const Text('Ver Historial'),
              )
            ],
          ),
        );
      }
    });
    
    if (paymentState.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorLoading}: ${paymentState.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final testCardsAsyncValue = ref.watch(testCardsProvider);
    final paymentState = ref.watch(paymentProcessProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: Text(l10n.cancel, style: const TextStyle(color: Color(0xFF007AFF))),
        ),
        title: Text(l10n.checkout, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StepIndicator(title: l10n.bagStep, step: 1, currentStep: _currentStep),
                _StepIndicator(title: l10n.shipping, step: 2, currentStep: _currentStep),
                _StepIndicator(title: l10n.payment, step: 3, currentStep: _currentStep),
                _StepIndicator(title: 'Review', step: 4, currentStep: _currentStep),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.choosePaymentMethod, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'You won\'t be charged until you review the order on the next page',
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  
                  // Campo para probar distintos montos
                  TextField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                      labelText: 'Amount (for testing purposes)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  testCardsAsyncValue.when(
                    data: (cards) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFEEEEEE)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _PaymentMethodTile(
                              title: l10n.creditCard,
                              isSelected: true,
                              child: Column(
                                children: [
                                  // Generar lista de tarjetas
                                  ...cards.map((card) {
                                    final isSelected = !_isAddingManualCard && _selectedCardNumber == card.number;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedCardNumber = card.number;
                                          _isAddingManualCard = false;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(top: 12),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFFF8F9FA) : Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFEEEEEE)),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(card.holder, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 4),
                                                Text('xxxx xxxx xxxx ${card.number.substring(card.number.length - 4)}', style: const TextStyle(color: Colors.black54)),
                                              ],
                                            ),
                                            if (isSelected) const Icon(Icons.check, color: Color(0xFF007AFF)),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                  
                                  const SizedBox(height: 16),
                                  
                                  // Botón y campo de tarjeta manual
                                  if (!_isAddingManualCard)
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _isAddingManualCard = true;
                                          _selectedCardNumber = null;
                                        });
                                      },
                                      icon: const Icon(Icons.add, size: 16, color: Color(0xFF007AFF)),
                                      label: Text(l10n.addNewCard, style: const TextStyle(color: Color(0xFF007AFF))),
                                    ),
                                    
                                  if (_isAddingManualCard)
                                    Container(
                                      margin: const EdgeInsets.only(top: 12),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8F9FA),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: const Color(0xFF007AFF)),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('New Card Number', style: TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: _manualCardController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter 16-digit card number',
                                              isDense: true,
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                          const SizedBox(height: 8),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isAddingManualCard = false;
                                                });
                                              },
                                              child: Text(l10n.cancel),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF007AFF),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(l10n.billingAddressSameAsShipping, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => LoadingView(message: l10n.loading),
                    error: (e, st) => Text('${l10n.errorLoading}: $e'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: paymentState.isLoading ? null : _processPayment,
                child: paymentState.isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(l10n.processPayment, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final String title;
  final int step;
  final int currentStep;

  const _StepIndicator({required this.title, required this.step, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final isCompleted = step < currentStep;
    final isActive = step == currentStep;
    
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? const Color(0xFFE9F2FF) : (isActive ? const Color(0xFF007AFF) : const Color(0xFFF0F4F8)),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Color(0xFF007AFF))
                : Text('$step', style: TextStyle(color: isActive ? Colors.white : Colors.black54, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? Colors.black : Colors.black54,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Widget? child;

  const _PaymentMethodTile({required this.title, required this.isSelected, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFCCCCCC), width: 6),
                ),
              ),
              const SizedBox(width: 16),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          ?child,
        ],
      ),
    );
  }
}
