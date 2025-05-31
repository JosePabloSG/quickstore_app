import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': '¿Qué garantía tiene este producto?',
        'answer': 'Este producto tiene una garantía de 12 meses por defectos de fábrica.'
      },
      {
        'question': '¿Cuánto tarda el envío?',
        'answer': 'El tiempo estimado de entrega es de 2 a 5 días hábiles.'
      },
      {
        'question': '¿Puedo devolver el producto?',
        'answer': 'Sí, puedes devolverlo dentro de los primeros 15 días si no ha sido usado.'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Preguntas frecuentes',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...faqs.map((faq) => ExpansionTile(
              title: Text(faq['question']!, style: const TextStyle(fontWeight: FontWeight.w600)),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(faq['answer']!),
                ),
              ],
            )),
      ],
    );
  }
}
