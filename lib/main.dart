import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/caffeine_theme.dart';
import 'models/cart_state.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/main_shell.dart';
import 'screens/admin_shell.dart';
import 'screens/user_orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/order_confirmation_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartState(),
      child: const CaffeineApp(),
    ),
  );
}

class CaffeineApp extends StatelessWidget {
  const CaffeineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<String>.value(
      value: "Caffeine App",
      child: MaterialApp(
        title: 'Caffeine specialty coffee',
        debugShowCheckedModeBanner: false,
        theme: CaffeineTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/login': (context) => const AuthScreen(),
          '/shell': (context) => const MainShell(),
          '/admin_shell': (context) => const AdminShell(),
          '/my_orders': (context) => const UserOrdersScreen(),
          '/confirmation': (context) => const OrderConfirmationScreen(),
        },
        // Handling dynamic arguments for Product Details cleanly
        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) {
                return ProductDetailScreen(
                  product: args['product'],
                );
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
