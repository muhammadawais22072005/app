import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/caffeine_theme.dart';
import '../models/cart_state.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  String _selectedRole = 'user'; // 'user' or 'admin'
  
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofillUser() {
    setState(() {
      _isLogin = true;
      _selectedRole = 'user';
      _emailController.text = 'alex@gmail.com';
      _passwordController.text = 'alex123';
    });
  }

  void _autofillAdmin() {
    setState(() {
      _isLogin = true;
      _selectedRole = 'admin';
      _emailController.text = 'admin@caffeine.com';
      _passwordController.text = 'admin123';
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    final cartState = context.read<CartState>();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();

    if (_isLogin) {
      final success = cartState.login(email, password, _selectedRole);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back, ${cartState.currentUser?.name}! ☕'),
            backgroundColor: CaffeineTheme.amber,
          ),
        );
        if (_selectedRole == 'admin') {
          Navigator.of(context).pushReplacementNamed('/admin_shell');
        } else {
          Navigator.of(context).pushReplacementNamed('/shell');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials for this role.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } else {
      final success = cartState.signup(name, email, password, _selectedRole);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account created! Welcome, ${cartState.currentUser?.name}!'),
            backgroundColor: CaffeineTheme.amber,
          ),
        );
        if (_selectedRole == 'admin') {
          Navigator.of(context).pushReplacementNamed('/admin_shell');
        } else {
          Navigator.of(context).pushReplacementNamed('/shell');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email already registered.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Coffee Ambient Image/Color
          Positioned.fill(
            child: Container(
              color: CaffeineTheme.espresso,
            ),
          ),
          
          // Glowing Radial Ambient Lights
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: CaffeineTheme.amber.withOpacity(0.05),
                boxShadow: [
                  BoxShadow(
                    color: CaffeineTheme.amber.withOpacity(0.05),
                    blurRadius: 100,
                    spreadRadius: 50,
                  )
                ],
              ),
            ),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Brand Logo
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: CaffeineTheme.surface.withOpacity(0.5),
                        border: Border.all(color: CaffeineTheme.cream.withOpacity(0.08)),
                        boxShadow: [
                          BoxShadow(
                            color: CaffeineTheme.amber.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.coffee_rounded,
                          color: CaffeineTheme.amber,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Caffeine',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: CaffeineTheme.cream,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Specialty Brewing Experience',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: CaffeineTheme.outline.withOpacity(0.7),
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Role Selector Tab Buttons
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: CaffeineTheme.surface.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CaffeineTheme.cream.withOpacity(0.04)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRole = 'user';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'user'
                                      ? CaffeineTheme.amber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Customer',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedRole == 'user'
                                          ? CaffeineTheme.espresso
                                          : CaffeineTheme.cream,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedRole = 'admin';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _selectedRole == 'admin'
                                      ? CaffeineTheme.amber
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    'Admin Portal',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: _selectedRole == 'admin'
                                          ? CaffeineTheme.espresso
                                          : CaffeineTheme.cream,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Main Glassmorphic Card Container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: CaffeineTheme.surface.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: CaffeineTheme.cream.withOpacity(0.08),
                              width: 1,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _isLogin ? 'Sign In' : 'Create Account',
                                  style: const TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: CaffeineTheme.offWhite,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Name field (only signup)
                                if (!_isLogin) ...[
                                  TextFormField(
                                    controller: _nameController,
                                    style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 15),
                                    decoration: InputDecoration(
                                      hintText: 'Full Name',
                                      hintStyle: TextStyle(color: CaffeineTheme.outline.withOpacity(0.5)),
                                      prefixIcon: const Icon(Icons.person_outline_rounded, color: CaffeineTheme.outline),
                                      filled: true,
                                      fillColor: CaffeineTheme.espresso.withOpacity(0.3),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.1)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.04)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(color: CaffeineTheme.amber),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val == null || val.trim().isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                ],

                                // Email Input
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    hintStyle: TextStyle(color: CaffeineTheme.outline.withOpacity(0.5)),
                                    prefixIcon:const Icon(Icons.email_outlined, color: CaffeineTheme.outline),
                                    filled: true,
                                    fillColor: CaffeineTheme.espresso.withOpacity(0.3),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.04)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: CaffeineTheme.amber),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!val.contains('@') || !val.contains('.')) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),

                                // Password Input
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  style: const TextStyle(color: CaffeineTheme.offWhite, fontSize: 15),
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyle(color: CaffeineTheme.outline.withOpacity(0.5)),
                                    prefixIcon: const Icon(Icons.lock_outline_rounded, color: CaffeineTheme.outline),
                                    filled: true,
                                    fillColor: CaffeineTheme.espresso.withOpacity(0.3),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.1)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(color: CaffeineTheme.cream.withOpacity(0.04)),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: const BorderSide(color: CaffeineTheme.amber),
                                    ),
                                  ),
                                  validator: (val) {
                                    if (val == null || val.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if (val.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Action Button
                                SizedBox(
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _handleSubmit,
                                    style: CaffeineTheme.amberButtonStyle,
                                    child: Text(
                                      _isLogin ? 'Enter Cafe' : 'Sign Up',
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: CaffeineTheme.espresso,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Toggle auth mode
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(
                                    _isLogin
                                        ? 'Don\'t have an account? Sign Up'
                                        : 'Already have an account? Login',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      color: CaffeineTheme.amber.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Quick-test Credentials Autofill Row
                    Column(
                      children: [
                        Text(
                          'QUICK LOGIN FOR TESTING',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            color: CaffeineTheme.outline.withOpacity(0.7),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              onPressed: _autofillUser,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: CaffeineTheme.cream.withOpacity(0.1)),
                                foregroundColor: CaffeineTheme.cream,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.person, size: 16),
                              label: const Text('Customer', style: TextStyle(fontSize: 12)),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton.icon(
                              onPressed: _autofillAdmin,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: CaffeineTheme.cream.withOpacity(0.1)),
                                foregroundColor: CaffeineTheme.cream,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              icon: const Icon(Icons.admin_panel_settings, size: 16),
                              label: const Text('Admin', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
