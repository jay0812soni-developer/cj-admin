import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../bloc/auth_bloc.dart';

class SecretLoginView extends StatefulWidget {
  const SecretLoginView({super.key});

  @override
  State<SecretLoginView> createState() => _SecretLoginViewState();
}

class _SecretLoginViewState extends State<SecretLoginView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'superadmin');
  final _passwordController = TextEditingController(text: 'Super@12345');
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginSubmittedEvent(
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  void _quickSelect(String u, String p) {
    setState(() {
      _usernameController.text = u;
      _passwordController.text = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.darkBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 460),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
            decoration: BoxDecoration(
              color: AdminColors.darkCard,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AdminColors.primaryGold.withOpacity(0.35), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: AdminColors.primaryGold.withOpacity(0.08),
                  blurRadius: 40,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Circle
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AdminColors.primaryGold, width: 2),
                      color: AdminColors.darkSurface,
                    ),
                    child: const Center(
                      child: Text(
                        'CJ',
                        style: TextStyle(
                          color: AdminColors.primaryGold,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ChandraKala Jewellers',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: AdminColors.textDarkPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AdminColors.primaryGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AdminColors.primaryGold.withOpacity(0.4)),
                        ),
                        child: const Text(
                          'CONTROL GATE',
                          style: TextStyle(
                            color: AdminColors.primaryGold,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Auth Error Banner
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthError) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AdminColors.error.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AdminColors.error.withOpacity(0.4)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AdminColors.error, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: AdminColors.error, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Username Field
                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: AdminColors.textDarkPrimary),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: AdminColors.primaryGold, size: 20),
                    ),
                    validator: (val) => (val == null || val.isEmpty) ? 'Enter your admin username' : null,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: AdminColors.textDarkPrimary),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline_rounded, color: AdminColors.primaryGold, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: AdminColors.textMuted,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    onFieldSubmitted: (_) => _submit(),
                    validator: (val) => (val == null || val.isEmpty) ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                                )
                              : const Text('Unlock Control Center'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // Quick Demo Accounts Selector (For Store Family)
                  const Text(
                    'QUICK ROLE LOGIN',
                    style: TextStyle(
                      color: AdminColors.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ActionChip(
                        backgroundColor: AdminColors.darkSurface,
                        side: const BorderSide(color: AdminColors.primaryGold, width: 0.8),
                        label: const Text('Superadmin (Jay)', style: TextStyle(fontSize: 11, color: AdminColors.goldAccent)),
                        onPressed: () => _quickSelect('superadmin', 'Super@12345'),
                      ),
                      ActionChip(
                        backgroundColor: AdminColors.darkSurface,
                        side: const BorderSide(color: AdminColors.darkBorder, width: 0.8),
                        label: const Text('Admin (Hasmukh)', style: TextStyle(fontSize: 11, color: AdminColors.textDarkSecondary)),
                        onPressed: () => _quickSelect('admin', 'mVsr@1617'),
                      ),
                      ActionChip(
                        backgroundColor: AdminColors.darkSurface,
                        side: const BorderSide(color: AdminColors.darkBorder, width: 0.8),
                        label: const Text('Co-Admin (Deven)', style: TextStyle(fontSize: 11, color: AdminColors.textDarkSecondary)),
                        onPressed: () => _quickSelect('deven', 'mVsr@1617'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
