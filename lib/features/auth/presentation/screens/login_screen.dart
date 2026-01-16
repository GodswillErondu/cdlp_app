import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_providers.dart';
import '../../../dashboard/presentation/screens/dashboard_screen.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final authNotifier = ref.read(authNotifierProvider.notifier);

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();

    String? _validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your email';
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return 'Please enter a valid email address';
      }
      return null;
    }

    String? _validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters long';
      }
      return null;
    }

    void _login() {
      if (_formKey.currentState?.validate() ?? false) {
        authNotifier.login(_emailController.text, _passwordController.text);
      }
    }

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.user != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 24.0),
                if (authState.isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
