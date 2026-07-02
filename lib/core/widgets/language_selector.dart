import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';

/// A compact language toggle displayed in AppBar actions.
///
/// Shows two chips — ES and EN — highlighting the currently active locale.
/// Tapping a chip calls [LocaleNotifier.setLocale] which updates both the
/// Riverpod state and the persisted SharedPreferences value.
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LangChip(
            label: 'ES',
            isSelected: currentLocale.languageCode == 'es',
            onTap: () => ref.read(localeProvider.notifier).setLocale(
                  const Locale('es'),
                ),
          ),
          const SizedBox(width: 4),
          _LangChip(
            label: 'EN',
            isSelected: currentLocale.languageCode == 'en',
            onTap: () => ref.read(localeProvider.notifier).setLocale(
                  const Locale('en'),
                ),
          ),
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  const _LangChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
