import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sharika/app/view/home_page.dart';
import 'package:sharika/app/view/login_page.dart';
import 'package:sharika/app/view/register.dart';
import 'package:sharika/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante inicialização correta antes do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializa o Firebase com as opções específicas da plataforma
  runApp(const MyApp()); // Inicia o app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // O StreamBuilder fica ouvindo as mudanças de autenticação do Firebase
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Enquanto estiver carregando o estado, mostra um carregamento
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se o usuário estiver logado, vai para a HomePage
          if (snapshot.hasData) {
            return HomePage();
          }

          // Se não estiver logado, mostra a tela de login
          return const LoginPage();
        },
      ),

      // Tema básico (pode ser customizado depois)
      theme: ThemeData(),

      // Rotas nomeadas para navegação
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) =>  HomePage(),
      },
    );
  }
}
