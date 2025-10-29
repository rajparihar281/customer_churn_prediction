// lib/screens/customer_detail_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../models/customer_profile.dart';
import '../widgets/shap_feature_display.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    final CustomerProfile? customer = dataProvider.getCustomerById(customerId);

    if (customer == null) {
      // A more styled error screen
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6B46C1), Color(0xFFF3F4F6)],
              stops: [0.0, 0.3],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF9333EA).withOpacity(0.1),
                          const Color(0xFF7C3AED).withOpacity(0.05),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_off_rounded,
                      size: 64,
                      color: const Color(0xFF9333EA).withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Customer Not Found',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'The customer ID does not exist',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Go Back'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final churnColor = Color.lerp(
      const Color(0xFF10B981),
      const Color(0xFFEF4444),
      customer.churnProbability,
    )!;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6B46C1), Color(0xFFF3F4F6)],
            stops: [0.0, 0.25],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Profile',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            customer.customerID,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Content Section
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Churn Prediction Card
                      _buildChurnPredictionCard(customer, churnColor),
                      const SizedBox(height: 20),

                      // Customer Feedback
                      _buildInfoSection(
                        'Customer Feedback',
                        Icons.feedback_rounded,
                        const Color(0xFF3B82F6),
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              customer.feedback.trim().isEmpty
                                  ? 'No feedback provided.'
                                  : customer.feedback,
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: customer.feedback.trim().isEmpty
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                                color: const Color(0xFF4B5563),
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                     // Account Information
                      _buildInfoSection(
                        'Account Information',
                        Icons.account_circle_rounded,
                        const Color(0xFF8B5CF6),
                        children: [
                          _buildDetailRow('Gender', customer.gender),
                          _buildDetailRow(
                            'Senior Citizen',
                            customer.isSeniorCitizen ? 'Yes' : 'No',
                          ),
                          _buildDetailRow(
                            'Partner',
                            customer.hasPartner ? 'Yes' : 'No',
                          ),
                          _buildDetailRow(
                            'Dependents',
                            customer.hasDependents ? 'Yes' : 'No',
                          ),
                          // _buildDetailRow(
                          //   'Tenure (months)',
                          //   customer.tenure.toString(),
                          // ),
                          _buildDetailRow('Contract Type', customer.contract),
                          _buildDetailRow(
                            'Payment Method',
                            customer.paymentMethod,
                          ),
                          _buildDetailRow(
                            'Paperless Billing',
                            customer.isPaperlessBilling ? 'Yes' : 'No',
                          ),
                          _buildDetailRow(
                            'Monthly Charges',
                            '\$${customer.monthlyCharges.toStringAsFixed(2)}',
                          ),
                          _buildDetailRow(
                            'Total Charges',
                            '\$${customer.totalCharges.toStringAsFixed(2)}',
                          ),
                        ],
                      ),

                      // Subscribed Services
                      _buildInfoSection(
                        'Subscribed Services',
                        Icons.wifi_rounded,
                        const Color(0xFFF59E0B),
                        children: [
                          _buildDetailRow(
                            'Phone Service',
                            customer.hasPhoneService ? 'Yes' : 'No',
                          ),
                          _buildDetailRow(
                            'Multiple Lines',
                            customer.multipleLines,
                          ),
                          _buildDetailRow(
                            'Internet Service',
                            customer.internetService,
                          ),
                          _buildDetailRow(
                            'Online Security',
                            customer.onlineSecurity,
                          ),
                          _buildDetailRow(
                            'Online Backup',
                            customer.onlineBackup,
                          ),
                          _buildDetailRow(
                            'Device Protection',
                            customer.deviceProtection,
                          ),
                          _buildDetailRow('Tech Support', customer.techSupport),
                        ],
                      ),

                      // SHAP Features
                      _buildInfoSection(
                        'Key Factors Affecting Churn',
                        Icons.trending_up_rounded,
                        const Color(0xFFEF4444),
                        children: [
                          ShapFeatureDisplay(
                            shapFeatures: customer.topShapFeatures,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChurnPredictionCard(CustomerProfile customer, Color churnColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [churnColor.withOpacity(0.1), churnColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: churnColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: churnColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [churnColor, churnColor.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: churnColor.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${(customer.churnProbability * 100).toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: churnColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Churn Probability',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: churnColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              customer.riskStatus,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: churnColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    String title,
    IconData icon,
    Color color, {
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFFAFAFA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
