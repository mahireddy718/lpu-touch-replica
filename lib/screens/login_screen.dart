import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation is handled automatically by the authStateChanges stream in main.dart
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication failed')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE0B2), Color(0xFFFBE9E7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/lpu_logo.png',
                height: 150,
              ),
              const SizedBox(height: 30),
              _buildTextField(
                icon: Icons.person,
                hintText: 'Email',
                obscureText: false,
                controller: _emailController,
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                icon: Icons.lock,
                hintText: 'Password',
                obscureText: _obscurePassword,
                controller: _passwordController,
                validator: (value) => value!.isEmpty ? 'Enter password' : null,
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 30),
              _buildSignInButton(),
              if (_isLoading) const SizedBox(height: 20, child: LinearProgressIndicator()),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOutlineButton('Forgot Password ?'),
                  _buildOutlineButton('Guest User'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hintText,
    required bool obscureText,
    required TextEditingController controller,
    required String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepOrange),
          suffixIcon: suffixIcon,
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF46B45), Color(0xFFFDC830)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: _isLoading ? null : _signIn,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text, style: const TextStyle(color: Colors.black87)),
    );
  }
}