// lib/widgets/customer_list_tile.dart
import 'package:flutter/material.dart';
import '../models/customer_profile.dart';

class CustomerListTile extends StatelessWidget {
  final CustomerProfile customer;
  final VoidCallback onTap;

  const CustomerListTile({
    super.key,
    required this.customer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final churnColor = Color.lerp(
      Colors.green,
      Colors.red,
      customer.churnProbability,
    )!;
    final churnPercentage = (customer.churnProbability * 100).toStringAsFixed(
      1,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: churnColor,
          child: Text(
            '$churnPercentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          customer.customerID,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // ** UPDATE THIS LINE **
        subtitle: Text('Status: ${customer.riskStatus}'),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
