import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/utils/app_routes.dart';

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
    final loc = AppLocalizations.of(context);

    final List<Map<String, String>> onboardingData = [
      {
        "title": loc?.translate('onboarding_title_1') ?? "",
        "description": loc?.translate('onboarding_desc_1') ?? "",
        "image": "assets/logo.png",
      },
      {
        "title": loc?.translate('onboarding_title_2') ?? "",
        "description": loc?.translate('onboarding_desc_2') ?? "",
        "image": "assets/logo.png",
      },
      {
        "title": loc?.translate('onboarding_title_3') ?? "",
        "description": loc?.translate('onboarding_desc_3') ?? "",
        "image": "assets/logo.png",
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Image.asset(
                      onboardingData[index]["image"]!,
                      height: 250,
                    ),
                    const Spacer(),
                    Text(
                      onboardingData[index]["title"]!,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        onboardingData[index]["description"]!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onboardingData.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 5),
                          height: 10,
                          width: _currentPage == index ? 30 : 10,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        if (_currentPage == onboardingData.length - 1) {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      child: Text(_currentPage == onboardingData.length - 1 
                        ? (loc?.translate('start') ?? "Start") 
                        : (loc?.translate('next') ?? "Next")),
                    ),
                    const SizedBox(height: 10),
                    if (_currentPage != onboardingData.length - 1)
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, AppRoutes.login);
                        },
                        child: Text(
                          loc?.translate('skip') ?? "Skip", 
                          style: const TextStyle(color: Colors.grey)
                        ),
                      ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
