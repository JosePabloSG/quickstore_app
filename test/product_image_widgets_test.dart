
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  testWidgets('Verifica que placeholder se muestre al iniciar carga de imagen',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CachedNetworkImage(
            imageUrl: 'https://example.com/test.jpg',
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );

    // ✅ Verifica que se muestre el placeholder
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
