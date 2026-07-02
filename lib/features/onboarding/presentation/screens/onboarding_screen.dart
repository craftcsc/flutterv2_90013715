import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/onboarding_provider.dart';
import '../../domain/entities/user_interest.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: const [
                  _IntroStep(),
                  _InterestsStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_currentPage < 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          await ref.read(onboardingControllerProvider.notifier).completeOnboarding();
                          if (context.mounted) {
                            context.go('/home');
                          }
                        }
                      },
                      child: Text(
                        l10n.next,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFE9F2FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Icon(Icons.image_outlined, size: 80, color: Color(0xFFB0CFFF)),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(3, (index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: index == 0 ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0 ? const Color(0xFF007AFF) : const Color(0xFFE0E0E0),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.onboardingTitle,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black, height: 1.2),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.onboardingSubtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InterestsStep extends ConsumerWidget {
  const _InterestsStep();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selectedInterests = ref.watch(selectedInterestsProvider);
    final List<String> interestsList = [
      'User Interface', 'User Experience', 'User Research', 'UX Writing',
      'User Testing', 'Service Design', 'Strategy', 'Design Systems',
    ];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Stack(
            children: [
              Container(
                height: 6,
                width: double.infinity,
                decoration: BoxDecoration(color: const Color(0xFFE9F2FF), borderRadius: BorderRadius.circular(3)),
              ),
              Container(
                height: 6,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(color: const Color(0xFF007AFF), borderRadius: BorderRadius.circular(3)),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(l10n.personaliseExperience, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 8),
          Text(l10n.chooseInterests, style: const TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: interestsList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final interestName = interestsList[index];
                // Note: user_interest domain entity could be matched by name or id, using name for simplicity
                final isSelected = selectedInterests.any((i) => i.name == interestName);
                
                return GestureDetector(
                  onTap: () {
                    // Create a dummy interest just to toggle by name. In a real app we'd fetch the real object.
                    // For the sake of UI we can just toggle by finding or creating.
                    final interestObj = selectedInterests.firstWhere(
                      (i) => i.name == interestName, 
                      orElse: () => UserInterest(id: DateTime.now().microsecondsSinceEpoch.toString(), name: interestName)
                    );
                    ref.read(selectedInterestsProvider.notifier).toggle(interestObj);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE9F2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFEEEEEE), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(interestName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: isSelected ? Colors.black : Colors.black87)),
                        if (isSelected) const Icon(Icons.check, size: 20, color: Color(0xFF007AFF)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
