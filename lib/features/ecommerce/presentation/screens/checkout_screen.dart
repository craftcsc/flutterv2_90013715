import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final int _currentStep = 2; // Payment step as per screenshot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF007AFF))),
        ),
        title: const Text('Checkout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StepIndicator(title: 'Your bag', step: 1, currentStep: _currentStep),
                _StepIndicator(title: 'Shipping', step: 2, currentStep: _currentStep),
                _StepIndicator(title: 'Payment', step: 3, currentStep: _currentStep),
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
                  const Text('Choose a payment method', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text(
                    'You won\'t be charged until you review the order on the next page',
                    style: TextStyle(color: Colors.black54, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _PaymentMethodTile(
                          title: 'Credit Card',
                          isSelected: true,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8F9FA),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF007AFF)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Mastercard', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text('xxxx xxxx xxxx 1234', style: TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                    const Icon(Icons.check, color: Color(0xFF007AFF)),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFEEEEEE)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: const [
                                        Text('Visa', style: TextStyle(fontWeight: FontWeight.bold)),
                                        SizedBox(height: 4),
                                        Text('xxxx xxxx xxxx 9876', style: TextStyle(color: Colors.black54)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, size: 16, color: Color(0xFF007AFF)),
                                label: const Text('Add new card', style: TextStyle(color: Color(0xFF007AFF))),
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
                                  const Expanded(
                                    child: Text('My billing address is the same as my shipping address', style: TextStyle(color: Colors.black87, fontSize: 13)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Color(0xFFEEEEEE)),
                        const _PaymentMethodTile(title: 'Apple Pay', isSelected: false),
                      ],
                    ),
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
                onPressed: () {
                  // Finalizar flujo o siguiente paso
                  showDialog(context: context, builder: (_) => AlertDialog(
                    title: const Text('Order Placed!'),
                    content: const Text('Your mock order was placed successfully.'),
                    actions: [
                      TextButton(onPressed: () {
                        context.go('/home');
                      }, child: const Text('Back to Home'))
                    ],
                  ));
                },
                child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
