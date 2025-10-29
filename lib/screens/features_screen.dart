// lib/screens/features_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Feature Importance',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Understanding prediction drivers',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildHeaderCard(),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset('assets/images/shap_summary_plot.png'),
                    ),
                    const SizedBox(height: 24),
                    _buildExplanationCard(),
                    const SizedBox(height: 20),
                    _buildFeatureCard(
                      'Contract Type',
                      'The most significant predictor of churn. Month-to-month contracts show the highest churn risk, while longer-term contracts indicate customer commitment.',
                      Icons.description_outlined,
                      const Color(0xFFEF4444),
                      1,
                    ),
                    _buildFeatureCard(
                      'Monthly Charges',
                      'Higher monthly charges correlate with increased churn likelihood, as customers may seek more affordable alternatives.',
                      Icons.attach_money_outlined,
                      const Color(0xFFF59E0B),
                      2,
                    ),
                    _buildFeatureCard(
                      'Tenure',
                      'Customer relationship duration is crucial. Newer customers are at higher risk, while long-term customers show loyalty.',
                      Icons.calendar_today_outlined,
                      const Color(0xFFFBBF24),
                      3,
                    ),
                    _buildFeatureCard(
                      'Online Security',
                      'Customers without online security services are more likely to churn. This add-on increases perceived value.',
                      Icons.security_outlined,
                      const Color(0xFF10B981),
                      4,
                    ),
                    _buildFeatureCard(
                      'Tech Support',
                      'Lack of technical support correlates with higher churn. Customers value assistance and support access.',
                      Icons.support_agent_outlined,
                      const Color(0xFF14B8A6),
                      5,
                    ),
                    _buildFeatureCard(
                      'Total Charges',
                      'Cumulative charges over customer lifetime. Reflects both tenure and monthly costs over time.',
                      Icons.receipt_long_outlined,
                      const Color(0xFF3B82F6),
                      6,
                    ),
                    _buildFeatureCard(
                      'Payment Method',
                      'Electronic check users show higher churn rates. Automatic payments reduce friction and increase retention.',
                      Icons.payment_outlined,
                      const Color(0xFF6366F1),
                      7,
                    ),
                    _buildFeatureCard(
                      'Dependents',
                      'Customers with dependents show lower churn rates. Family responsibilities create stability.',
                      Icons.family_restroom_outlined,
                      const Color(0xFF8B5CF6),
                      8,
                    ),
                    _buildFeatureCard(
                      'Sentiment Score',
                      'Customer satisfaction and sentiment. Negative sentiment is a strong indicator of potential churn.',
                      Icons.sentiment_satisfied_outlined,
                      const Color(0xFFEC4899),
                      9,
                    ),
                    _buildFeatureCard(
                      'Online Backup',
                      'This add-on service increases customer value perception and creates switching costs.',
                      Icons.backup_outlined,
                      const Color(0xFF06B6D4),
                      10,
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9333EA).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.analytics_outlined,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Global Feature Importance (SHAP)',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Understanding which features impact customer churn predictions the most',
              style: TextStyle(
                fontSize: 15,
                color: Colors.white.withOpacity(0.9),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9333EA).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Color(0xFF9333EA),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'How to Read This Chart',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildExplanationItem(
              Icons.arrow_right_alt,
              'Each row represents a feature from the dataset, ordered by importance.',
            ),
            _buildExplanationItem(
              Icons.arrow_right_alt,
              'The horizontal spread shows the impact magnitude. Wider distribution means more impact.',
            ),
            _buildExplanationItem(
              Icons.arrow_right_alt,
              'Red/pink points indicate higher feature values, blue points indicate lower values.',
            ),
            _buildExplanationItem(
              Icons.arrow_right_alt,
              'Positive SHAP values (right) increase churn probability, negative values (left) decrease it.',
            ),
            _buildExplanationItem(
              Icons.arrow_right_alt,
              'Example: Month-to-month contracts push predictions toward churn (right).',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF9333EA), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4B5563),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    String title,
    String description,
    IconData icon,
    Color color,
    int rank,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFFAFAFA)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 22, color: color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
