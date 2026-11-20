import 'package:flutter/material.dart';
import '../constants.dart';
import 'main_shell.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulation d'une légère attente puis vérification
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      setState(() => _isLoading = false);

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email == kLoginEmail && password == kLoginPassword) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainShell()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Identifiant ou mot de passe incorrect.'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Espace supérieur
            const Spacer(flex: 2),

            // Logo / Avatar
            Center(
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.description_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'CV - Chuma Salman',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: AppColors.text,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              CvData.title,
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),

            const Spacer(flex: 2),

            // Formulaire
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Identifiant
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: 'sans-serif'),
                      decoration: const InputDecoration(
                        hintText: 'Username, email or mobile number',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir votre identifiant';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Mot de passe
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: const TextStyle(fontFamily: 'sans-serif'),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez saisir votre mot de passe';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),

                    // Bouton de connexion
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Log in',
                                style: TextStyle(
                                  fontFamily: 'sans-serif',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Mot de passe oublié
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Fonctionnalité à venir.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          fontFamily: 'sans-serif',
                          color: AppColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 3),

            // Bouton créer un compte (outline)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fonctionnalité à venir.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size.fromHeight(52),
                    side: BorderSide(color: AppColors.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create new account',
                    style: TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Footer
            Text(
              '© 2026 Chuma Muzandwa Salman',
              style: TextStyle(
                fontFamily: 'sans-serif',
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
