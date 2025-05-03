import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/providers/product_provider.dart';
import 'package:quickstore_app/screens/login_screen.dart';
import 'package:quickstore_app/screens/product_catalog_screen.dart';
import 'providers/view_mode_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ViewModeProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error durante la inicialización: $e');
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Error al iniciar la aplicación: $e')),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickStore',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando aplicación...'),
                  ],
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          }

          if (snapshot.hasData) {
            return const ProductCatalogScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}
