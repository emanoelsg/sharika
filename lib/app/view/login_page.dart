import 'package:flutter/material.dart';
import 'package:sharika/app/auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false; // para mostrar indicador de carregamento
  String? _errorMessage;   // para mostrar mensagem de erro

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função para tentar logar
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // limpa erro antigo
    });

    try {
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Se chegar aqui, login deu certo e o StreamBuilder no main.dart vai atualizar a UI
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message; // mostra erro amigável
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Navega para tela de registro
  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
            TextButton(
              onPressed: _goToRegister,
              child: const Text('Criar uma conta'),
            ),
          ],
        ),
      ),
    );
  }
}
