import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Card.filled(
              margin: const EdgeInsets.only(top: 14, bottom: 14, right: 8),
              color: Theme.of(context).colorScheme.onSecondary,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Faq', style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}