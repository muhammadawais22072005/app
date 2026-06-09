import 'package:flutter/material.dart';
import '../theme/caffeine_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageModel> _pages = [
    OnboardingPageModel(
      title: 'Your Perfect Cup Awaits',
      subtitle: 'Order ahead for pickup or delivery and skip the wait.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuABHjgMw6rPgKGuOM0eb6FD5J8h92XtRh2mF0wF3uNOETIOSgUN5wafZqHkcMuQqGX398f8YYAU0jxGd-YiLAAR73KfezZHL2jcQ9zQfKKZIKQOb4hLnHIRmUOvUkS2WH10UiUR-tzpvXeMG-sl5A8W2vDzWEyXubY5cNxG9-0MgqiMAPA_wY1EtlcPrTVsDZfi2QagNRHDw53tktF-DQwFW1co0AdTsY1Kha-a6v0GAva0awLNFeFqP2oxwafWBOnY1DOLdWthe0Jg', // Moody cafe interior
      tagline: 'Skip the Wait',
    ),
    OnboardingPageModel(
      title: 'Artisan Craft & Specialty Roasts',
      subtitle: 'Crafted in small batches by passionate roasters using certified beans.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDdCtyBZIeJZAQT7OCByXLaM41eyfX-vBcVvUgEd1ozC2AsTb9Gl2Wpy-xsZki9NaQpf8EHB0tqaUjSmMsO8Dx8OYD7cit2Rj6cqy4vofvTxxw7u_VbSPFe60x-fThN0eBi5PHlOMHszpKfespFjSycolWe4YPTE8UE6gR-bVLpxdz66o-Yi76XHOn4cghNVY70Qc88Bfa-904UFduYmbOwjZ-MvASk6ayeft3GQKHwYP3UON4e445T3GMiyLv9JUE-qk5CPSA30MTl', // Close espresso pour
      tagline: 'Specialty Craft',
    ),
    OnboardingPageModel(
      title: 'Earn Loyalty & Free Drinks',
      subtitle: 'Collect stars on every sip and redeem them for artisanal brews.',
      imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC84287SVdMdwVivHcAu27xheunvjhVyXRH_i1XmWQVRz0G-yhsstB2T-WP-_20ezz9OMTKxHcJjTMEB0Gjn3kgLhfUPGbnvZVGN_SQIprD4dNN29w_VYFfpvTxuVIHip0BZLGdTgnaItv1UtAE9xnI3Qt7DKyJNzzDahv0s-2o0KdY0N14Hty1nNAtknRo-kVG7T9nJKB_BY-PCn1YajUICyqO5xT6g2q53QjGnquMSLD7xUwpPpIfD6P5jDUcCMYmJCRXzvUCB8Hu', // Caramel amber latte
      tagline: 'Exclusive Rewards',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Page View (Full-bleed images)
          Positioned.fill(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      _pages[index].imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: CaffeineTheme.espresso,
                        child: const Center(
                          child: Icon(Icons.coffee_outlined, size: 84, color: CaffeineTheme.amber),
                        ),
                      ),
                    ),
                    // Ambient espresso-to-transparent dark gradient overlay
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            CaffeineTheme.espresso,
                          ],
                          stops: [0.3, 0.9],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Branding header
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.coffee_rounded,
                  color: CaffeineTheme.amber,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'Caffeine',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: CaffeineTheme.amber,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),

          // Content Box overlay
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 48.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Glassmorphic Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: CaffeineTheme.espresso.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: CaffeineTheme.cream.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Short progress bar top indicator
                        Container(
                          width: 48,
                          height: 4,
                          decoration: BoxDecoration(
                            color: CaffeineTheme.amber.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: (_currentPage + 1) / _pages.length,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: CaffeineTheme.amber,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Page Title
                        Text(
                          _pages[_currentPage].title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: CaffeineTheme.offWhite,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Page Subtitle
                        Text(
                          _pages[_currentPage].subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            color: CaffeineTheme.offWhite.withOpacity(0.7),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28),
                        
                        // Primary Action Button (Next / Get Started)
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_currentPage < _pages.length - 1) {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                Navigator.of(context).pushReplacementNamed('/login');
                              }
                            },
                            style: CaffeineTheme.amberButtonStyle,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentPage == _pages.length - 1 ? 'Start Ritual' : 'Next Step',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: CaffeineTheme.espresso,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  _currentPage == _pages.length - 1 ? Icons.coffee : Icons.arrow_forward_rounded,
                                  color: CaffeineTheme.espresso,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Bottom Indicators and Skip Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Skip button
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: CaffeineTheme.offWhite.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      
                      // Progress dot pills
                      Row(
                        children: List.generate(_pages.length, (index) {
                          final isSelected = index == _currentPage;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isSelected ? 20 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected ? CaffeineTheme.amber : CaffeineTheme.cream.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      
                      // Next/Back button
                      TextButton(
                        onPressed: () {
                          if (_currentPage > 0) {
                            _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          _currentPage > 0 ? 'Back' : '',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: CaffeineTheme.offWhite.withOpacity(0.5),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tagline;

  OnboardingPageModel({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tagline,
  });
}
