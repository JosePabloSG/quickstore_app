import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickstore_app/providers/product_provider.dart';
import 'package:quickstore_app/screens/home_screen.dart';
import 'screens/product_catalog_screen.dart';
import 'providers/view_mode_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModeProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuickStore',
      theme: ThemeData(primarySwatch: Colors.blue),
       home: const HomeScreen(),
    );
  }
}
