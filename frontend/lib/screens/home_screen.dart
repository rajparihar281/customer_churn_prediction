// lib/screens/home_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';
import '../widgets/info_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dashboard',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Customer insights at a glance',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      if (dataProvider.dataState == DataState.loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF9333EA),
                            ),
                          ),
                        );
                      }
                      if (dataProvider.dataState == DataState.error) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: 64,
                                color: const Color(0xFFEF4444).withOpacity(0.5),
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Failed to load data',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please try again later',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          InfoCard(
                            title: 'Total Customers',
                            value: dataProvider.totalCustomers.toString(),
                            icon: Icons.people_alt_rounded,
                            color: const Color(0xFF3B82F6),
                          ),
                          const SizedBox(height: 12),
                          InfoCard(
                            title: 'Customers Retained',
                            value: dataProvider.retainedCustomers.toString(),
                            icon: Icons.person_add_alt_1_rounded,
                            color: const Color(0xFF10B981),
                          ),
                          const SizedBox(height: 12),
                          InfoCard(
                            title: 'Customers Churned',
                            value: dataProvider.churnedCustomers.toString(),
                            icon: Icons.trending_down_rounded,
                            color: const Color(0xFFEF4444),
                          ),
                          const SizedBox(height: 12),
                          InfoCard(
                            title: 'Overall Churn Rate',
                            value:
                                '${dataProvider.churnRate.toStringAsFixed(1)}%',
                            icon: Icons.pie_chart_rounded,
                            color: const Color(0xFFF59E0B),
                          ),
                          const SizedBox(height: 24),
                          _buildRiskDistributionChart(dataProvider),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskDistributionChart(DataProvider dataProvider) {
    final lowRiskCount = dataProvider.lowRiskCustomers.length.toDouble();
    final mediumRiskCount = dataProvider.mediumRiskCustomers.length.toDouble();
    final highRiskCount = dataProvider.highRiskCustomers.length.toDouble();
    final totalCustomers = dataProvider.totalCustomers.toDouble();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.stacked_bar_chart_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Risk Distribution',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Composition of customer base by risk level',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.center,
                  maxY: totalCustomers,
                  groupsSpace: 40,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => const Color(0xFF1F2937),
                      tooltipBorder: const BorderSide(
                        color: Colors.transparent,
                      ),
                      tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final stackItem = rod.rodStackItems[rodIndex];
                        String title;
                        double percentage;

                        if (stackItem.color == const Color(0xFF10B981)) {
                          title = 'Low Risk';
                          percentage = (lowRiskCount / totalCustomers) * 100;
                        } else if (stackItem.color == const Color(0xFFF59E0B)) {
                          title = 'Medium Risk';
                          percentage = (mediumRiskCount / totalCustomers) * 100;
                        } else {
                          title = 'High Risk';
                          percentage = (highRiskCount / totalCustomers) * 100;
                        }

                        final customerCount =
                            stackItem.toY.toInt() - stackItem.fromY.toInt();

                        return BarTooltipItem(
                          '$title\n',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: '$customerCount Customers\n',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: '${percentage.toStringAsFixed(1)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          if (value == 0 || value >= meta.max) {
                            return const Text('');
                          }
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                      axisNameWidget: const Text(
                        "No. of Customers",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.1),
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: totalCustomers,
                          width: 80,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          rodStackItems: [
                            BarChartRodStackItem(
                              0,
                              lowRiskCount,
                              const Color(0xFF10B981),
                            ),
                            BarChartRodStackItem(
                              lowRiskCount,
                              lowRiskCount + mediumRiskCount,
                              const Color(0xFFF59E0B),
                            ),
                            BarChartRodStackItem(
                              lowRiskCount + mediumRiskCount,
                              totalCustomers,
                              const Color(0xFFEF4444),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16,
      runSpacing: 8,
      children: [
        _legendItem(const Color(0xFF10B981), 'Low Risk'),
        _legendItem(const Color(0xFFF59E0B), 'Medium Risk'),
        _legendItem(const Color(0xFFEF4444), 'High Risk'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }
}
