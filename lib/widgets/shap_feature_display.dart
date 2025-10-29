// lib/widgets/shap_feature_display.dart
import 'package:flutter/material.dart';
import '../models/customer_profile.dart';

class ShapFeatureDisplay extends StatelessWidget {
  final ShapFeatures shapFeatures;

  const ShapFeatureDisplay({super.key, required this.shapFeatures});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Factors Influencing Prediction:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        ...List.generate(shapFeatures.features.length, (index) {
          final feature = shapFeatures.features[index];
          final value = shapFeatures.values[index];
          final isPositive = value > 0;
          final icon = isPositive
              ? Icons.arrow_upward_rounded
              : Icons.arrow_downward_rounded;
          final color = isPositive ? Colors.red : Colors.green;
          final impactText = isPositive
              ? 'Increases churn risk'
              : 'Decreases churn risk';

          return ListTile(
            leading: Icon(icon, color: color),
            title: Text(feature),
            subtitle: Text(impactText),
            // This is the new part that displays the value
            trailing: Text(
              value.toStringAsFixed(3), // Formats number to 3 decimal places
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            dense: true,
          );
        }),
      ],
    );
  }
}
