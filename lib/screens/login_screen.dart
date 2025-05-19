import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import './register_screen.dart';
import './product_catalog_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool showLogoutMessage;

  const LoginScreen({Key? key, this.showLogoutMessage = false})
    : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.showLogoutMessage) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sesión cerrada exitosamente.'),
            duration: Duration(seconds: 5),
          ),
        );
      });
    }
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final user = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (user != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ProductCatalogScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Credenciales incorrectas. Verifica tu email y contraseña.',
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      body: Stack(
        children: [
          // Fondo decorativo
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0066FF),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF0066FF),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Accede a tu cuenta para continuar!',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      enabled: !_isLoading,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: 'Contraseña',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                                color: const Color(0xFF004CFF),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contraseña';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signIn,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFF0066FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Iniciar sesión',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black, // ← color de texto negro
                            fontWeight: FontWeight.bold, // (opcional) negrita
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading) ...[
                      const SizedBox(height: 16),
                      const Center(child: CircularProgressIndicator()),
                    ],
                    const SizedBox(height: 16),
                    Center(
                      child: TextButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const RegisterScreen(),
                                    ),
                                  );
                                },
                        child: const Text(
                          '¿No tienes cuenta? Regístrate',
                          style: TextStyle(color: Colors.black54,),
                        ),
                      ),
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
