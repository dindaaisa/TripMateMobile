import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tripmate_mobile/models/user_model.dart';
import 'package:another_flushbar/flushbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool agreeToPolicy = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  void _showTopNotification(String message, {Color color = Colors.redAccent}) {
    Flushbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: color,
      margin: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(12),
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && agreeToPolicy) {
      final name = nameController.text.trim();
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final box = Hive.box<UserModel>('users');

      // Cek duplikat email
      final isDuplicate = box.values.any((user) => user.email == email);
      if (isDuplicate) {
        _showTopNotification('Email sudah digunakan');
        return;
      }

      final newUser = UserModel(
        name: name,
        email: email,
        password: password,
        role: 'user', // default role
      );
      await box.add(newUser);

      _showTopNotification('Pendaftaran berhasil! Silakan login.', color: Colors.green);

      Navigator.pushReplacementNamed(context, '/login');
    } else if (!agreeToPolicy) {
      _showTopNotification('Anda harus menyetujui kebijakan dan syarat terlebih dahulu.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Daftar', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 4),
                      const Text('Buat akun untuk mulai TripMate!', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 24),

                      const Text('Nama', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: nameController,
                        decoration: _inputDecoration('Nama lengkap'),
                        validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
                      ),
                      const SizedBox(height: 16),

                      const Text('Alamat Email', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration('Alamat email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Email wajib diisi';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(value)) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text('Sandi', style: TextStyle(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: passwordController,
                        obscureText: hidePassword,
                        decoration: _inputDecoration('Buat sandi').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => hidePassword = !hidePassword),
                          ),
                        ),
                        validator: (value) => value!.length < 6 ? 'Minimal 6 karakter' : null,
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: confirmPasswordController,
                        obscureText: hideConfirmPassword,
                        decoration: _inputDecoration('Konfirmasi sandi').copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(hideConfirmPassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => hideConfirmPassword = !hideConfirmPassword),
                          ),
                        ),
                        validator: (value) => value != passwordController.text ? 'Password tidak cocok' : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Checkbox(
                            value: agreeToPolicy,
                            onChanged: (value) => setState(() => agreeToPolicy = value!),
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: 'Saya telah membaca dan menyetujui ',
                                style: const TextStyle(fontSize: 13),
                                children: [
                                  TextSpan(
                                    text: 'kebijakan privasi',
                                    style: const TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                  const TextSpan(text: ' serta '),
                                  TextSpan(
                                    text: 'syarat dan ketentuan.',
                                    style: const TextStyle(color: Color(0xFFDC2626)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: const Color(0xFFDC2626),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/login'),
                    child: const Text.rich(
                      TextSpan(
                        text: 'Sudah memiliki akun? ',
                        children: [
                          TextSpan(
                            text: 'Masuk sekarang',
                            style: TextStyle(color: Color(0xFFDC2626)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 5,
                    width: 134,
                    decoration: BoxDecoration(
                      color: Color(0xFF141414),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.white,
    );
  }
}
