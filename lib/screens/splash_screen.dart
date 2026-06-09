import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/caffeine_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<SteamParticle> _particles = List.generate(15, (index) => SteamParticle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    // Auto-navigate to onboarding after 3.5 seconds
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ambient Warm Background
          Positioned.fill(
            child: Container(
              color: CaffeineTheme.espresso,
            ),
          ),
          
          // Steam Particles Custom Animation
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Update and draw particles
                for (var p in _particles) {
                  p.update(_controller.value);
                }
                return CustomPaint(
                  painter: SteamPainter(particles: _particles),
                );
              },
            ),
          ),

          // Glowing light overlay
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CaffeineTheme.amber.withOpacity(0.04),
                // Adds a beautiful ambient blur
                boxShadow: [
                  BoxShadow(
                    color: CaffeineTheme.amber.withOpacity(0.04),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          // Central Breathing Logo Section
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.95, end: 1.05),
              duration: const Duration(seconds: 3),
              curve: Curves.easeInOut,
              // Causes the logo to gently breathe/pulse
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: child,
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Coffee Cup Icon
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CaffeineTheme.surface.withOpacity(0.4),
                      border: Border.all(
                        color: CaffeineTheme.cream.withOpacity(0.1),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CaffeineTheme.amber.withOpacity(0.12),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.coffee_rounded,
                        size: 72,
                        color: CaffeineTheme.amber,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Wordmark text
                  Text(
                    'Caffeine',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tagline
                  Text(
                    'Artisanal Coffee Ritual',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CaffeineTheme.cream.withOpacity(0.5),
                      letterSpacing: 1.5,
                    ),
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

// Particle math class for simulating organic rising steam
class SteamParticle {
  late double x;
  late double yFraction; // 0.0 at bottom, 1.0 at top
  late double size;
  late double speed;
  late double opacity;
  late double waveFrequency;
  late double waveAmplitude;
  late double baseSeed;

  SteamParticle() {
    reset(isInitial: true);
  }

  void reset({bool isInitial = false}) {
    final rand = math.Random();
    x = rand.nextDouble();
    yFraction = isInitial ? rand.nextDouble() : 0.0;
    size = rand.nextDouble() * 50 + 30; // Between 30 and 80px
    speed = rand.nextDouble() * 0.15 + 0.05; // Speed multiplier
    opacity = rand.nextDouble() * 0.15 + 0.05; // Low opacity steam
    waveFrequency = rand.nextDouble() * 10 + 5;
    waveAmplitude = rand.nextDouble() * 0.08 + 0.02;
    baseSeed = rand.nextDouble() * 100;
  }

  void update(double value) {
    yFraction += speed * 0.005;
    if (yFraction > 1.2) {
      reset();
    }
  }
}

// Paints steam particles onto the canvas with gaussian-like radial falloffs
class SteamPainter extends CustomPainter {
  final List<SteamParticle> particles;

  SteamPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      // Calculate screen coordinate
      final double py = size.height * (1.0 - (p.yFraction % 1.0));
      
      // Add a horizontal sinusoidal wave to mimic curling steam
      final double wave = math.sin((p.yFraction * p.waveFrequency) + p.baseSeed) * p.waveAmplitude;
      final double px = size.width * (p.x + wave);

      // Fading curve: fade in at bottom, fade out at top
      double currentOpacity = p.opacity;
      if (p.yFraction < 0.2) {
        currentOpacity = p.opacity * (p.yFraction / 0.2);
      } else if (p.yFraction > 0.8) {
        currentOpacity = p.opacity * ((1.2 - p.yFraction) / 0.4);
      }
      currentOpacity = currentOpacity.clamp(0.0, 1.0);

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            CaffeineTheme.cream.withOpacity(currentOpacity),
            CaffeineTheme.cream.withOpacity(currentOpacity * 0.5),
            CaffeineTheme.espresso.withOpacity(0.0),
          ],
          stops: const [0.0, 0.3, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(px, py), radius: p.size))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);

      canvas.drawCircle(Offset(px, py), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
