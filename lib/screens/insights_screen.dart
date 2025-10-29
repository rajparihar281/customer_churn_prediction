// lib/screens/insights_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../providers/data_provider.dart';
import '../models/customer_profile.dart';
import '../widgets/customer_list_tile.dart';

enum AnalysisFeature {
  contract,
  internetService,
  paymentMethod,
  techSupport,
  partner,
}

extension AnalysisFeatureExtension on AnalysisFeature {
  String get name {
    switch (this) {
      case AnalysisFeature.contract:
        return 'Contract Type';
      case AnalysisFeature.internetService:
        return 'Internet Service';
      case AnalysisFeature.paymentMethod:
        return 'Payment Method';
      case AnalysisFeature.techSupport:
        return 'Tech Support';
      case AnalysisFeature.partner:
        return 'Has Partner';
    }
  }
}

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with TickerProviderStateMixin {
  AnalysisFeature _selectedFeature = AnalysisFeature.contract;
  Map<String, Map<String, int>> _processedData = {};
  bool _isDataInitialized = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataInitialized) {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      if (dataProvider.dataState == DataState.loaded) {
        _processData(dataProvider.allCustomers);
        _isDataInitialized = true;
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _processData(List<CustomerProfile> customers) {
    final data = <String, Map<String, int>>{};
    String getCategory(CustomerProfile customer) {
      switch (_selectedFeature) {
        case AnalysisFeature.contract:
          return customer.contract;
        case AnalysisFeature.internetService:
          return customer.internetService;
        case AnalysisFeature.paymentMethod:
          return customer.paymentMethod;
        case AnalysisFeature.techSupport:
          return customer.techSupport;
        case AnalysisFeature.partner:
          return customer.hasPartner ? 'Yes' : 'No';
      }
    }

    for (var customer in customers) {
      final category = getCategory(customer);
      data.putIfAbsent(category, () => {'churned': 0, 'retained': 0});
      if (customer.didChurn) {
        data[category]!['churned'] = data[category]!['churned']! + 1;
      } else {
        data[category]!['retained'] = data[category]!['retained']! + 1;
      }
    }

    if (mounted) {
      setState(() => _processedData = data);
      _animationController.reset();
      _animationController.forward();
    }
  }

  String _generateInsight() {
    if (_processedData.isEmpty) return 'Analyzing data...';

    String maxChurnCategory = '';
    double maxChurnRate = -1.0;

    _processedData.forEach((category, values) {
      final churned = values['churned']!;
      final total = churned + values['retained']!;
      if (total > 0) {
        final rate = churned / total;
        if (rate > maxChurnRate) {
          maxChurnRate = rate;
          maxChurnCategory = category;
        }
      }
    });

    if (maxChurnCategory.isEmpty) {
      return 'Not enough data to generate an insight.';
    }

    switch (_selectedFeature) {
      case AnalysisFeature.contract:
        return "Customers with a '$maxChurnCategory' contract have the highest churn rate (${(maxChurnRate * 100).toStringAsFixed(1)}%).";
      case AnalysisFeature.internetService:
        return "The '$maxChurnCategory' internet service is associated with the highest churn rate.";
      case AnalysisFeature.paymentMethod:
        return "Using '$maxChurnCategory' as a payment method correlates with the highest churn.";
      case AnalysisFeature.techSupport:
        if (maxChurnCategory.toLowerCase() == 'no') {
          return "Customers without Tech Support are most likely to churn.";
        }
        return "The '$maxChurnCategory' group for Tech Support shows the highest churn.";
      case AnalysisFeature.partner:
        if (maxChurnCategory.toLowerCase() == 'no') {
          return "Customers without a partner are significantly more likely to churn.";
        }
        return "Customers with a partner are more likely to churn.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Insights',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Deep dive into customer behavior',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9333EA), Color(0xFF7C3AED)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: const Color(0xFF6B7280),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(
                        child: Text(
                          'Group',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Individual',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Risk Segments',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
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
                        return const Center(
                          child: Text('Failed to load data.'),
                        );
                      }

                      return TabBarView(
                        children: [
                          _buildGroupChartsView(dataProvider.allCustomers),
                          _buildIndividualListView(dataProvider.allCustomers),
                          _buildRiskSegmentsView(dataProvider),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRiskSegmentsView(DataProvider dataProvider) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                  ),
                ],
              ),
              labelColor: const Color(0xFF6B46C1),
              unselectedLabelColor: const Color(0xFF6B7280),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Text(
                    'High Risk (${dataProvider.highRiskCustomers.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Medium Risk (${dataProvider.mediumRiskCustomers.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Tab(
                  child: Text(
                    'Low Risk (${dataProvider.lowRiskCustomers.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildIndividualListView(dataProvider.highRiskCustomers),
                _buildIndividualListView(dataProvider.mediumRiskCustomers),
                _buildIndividualListView(dataProvider.lowRiskCustomers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupChartsView(List<CustomerProfile> customers) {
    if (!_isDataInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    final String insightText = _generateInsight();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<AnalysisFeature>(
                value: _selectedFeature,
                isExpanded: true,
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF9333EA),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
                items: AnalysisFeature.values
                    .map(
                      (feature) => DropdownMenuItem(
                        value: feature,
                        child: Text(feature.name),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    _selectedFeature = newValue;
                    _processData(customers);
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: _animationController,
          child: _buildChartCard(
            'Side-by-Side Comparison',
            'By ${_selectedFeature.name}',
            _buildBarChart(),
            Icons.bar_chart_rounded,
            legend: _buildLegend(),
            insight: insightText,
          ),
        ),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: _animationController,
          child: _buildChartCard(
            'Total Customer Distribution',
            'By ${_selectedFeature.name}',
            _buildPieChart(),
            Icons.pie_chart_rounded,
            insight: insightText,
          ),
        ),
        const SizedBox(height: 24),
        FadeTransition(
          opacity: _animationController,
          child: _buildChartCard(
            'Composition Analysis',
            'Churn vs. Retained by ${_selectedFeature.name}',
            _buildStackedBarChart(),
            Icons.stacked_bar_chart_rounded,
            legend: _buildLegend(),
            insight: insightText,
          ),
        ),
      ],
    );
  }

  Widget _buildIndividualListView(List<CustomerProfile> customers) {
    if (customers.isEmpty) {
      return const Center(
        child: Text(
          "No customers in this category.",
          style: TextStyle(color: Colors.white70),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: CustomerListTile(
            customer: customer,
            onTap: () => context.push('/customer/${customer.customerID}'),
          ),
        );
      },
    );
  }

  Widget _buildChartCard(
    String title,
    String subtitle,
    Widget chart,
    IconData icon, {
    Widget? legend,
    String? insight,
  }) {
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
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(height: 250, child: chart),
            if (legend != null) ...[const SizedBox(height: 16), legend],
            if (insight != null) ...[
              const Divider(
                height: 32,
                thickness: 1,
                indent: 10,
                endIndent: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF6B46C1).withOpacity(0.8),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight,
                      style: TextStyle(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _getBottomTitleWidgets(
    double value,
    TitleMeta meta,
    List<String> categories,
  ) {
    final text = categories.length > value.toInt()
        ? categories[value.toInt()]
        : '';
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Transform.rotate(
        angle: -pi / 4,
        child: Text(
          text,
          style: TextStyle(fontSize: 10, color: Colors.grey[700]),
        ),
      ),
    );
  }

  Widget _getLeftTitleWidgets(double value, TitleMeta meta) {
    if (value == meta.max) return Container();
    return Text(
      value.toInt().toString(),
      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildBarChart() {
    final categories = _processedData.keys.toList();
    return BarChart(
      BarChartData(
        barGroups: List.generate(categories.length, (index) {
          final category = categories[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: _processedData[category]!['churned']!.toDouble(),
                color: const Color(0xFFEF4444),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              BarChartRodData(
                toY: _processedData[category]!['retained']!.toDouble(),
                color: const Color(0xFF10B981),
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: 1,
              getTitlesWidget: (val, meta) =>
                  _getBottomTitleWidgets(val, meta, categories),
            ),
            axisNameWidget: const Text(
              "Category",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: _getLeftTitleWidgets,
            ),
            axisNameWidget: const Text(
              "No. of Customers",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
        ),
      ),
    );
  }

  Widget _buildStackedBarChart() {
    final categories = _processedData.keys.toList();
    double maxY = 0;
    for (var val in _processedData.values) {
      final total = val['churned']! + val['retained']!;
      if (total > maxY) maxY = total.toDouble();
    }

    return BarChart(
      BarChartData(
        maxY: maxY * 1.2,
        alignment: BarChartAlignment.spaceAround,
        // ** ADDED THIS SECTION FOR TOOLTIPS **
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final category = categories[group.x.toInt()];
              final churned = _processedData[category]!['churned']!;
              final retained = _processedData[category]!['retained']!;

              return BarTooltipItem(
                '$category\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Retained: $retained\n',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: 'Churned: $churned',
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        barGroups: List.generate(categories.length, (index) {
          final category = categories[index];
          final churned = _processedData[category]!['churned']!.toDouble();
          final retained = _processedData[category]!['retained']!.toDouble();

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: churned + retained,
                width: 35,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                rodStackItems: [
                  BarChartRodStackItem(0, churned, const Color(0xFFEF4444)),
                  BarChartRodStackItem(
                    churned,
                    churned + retained,
                    const Color(0xFF10B981),
                  ),
                ],
              ),
            ],
          );
        }),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              interval: 1,
              getTitlesWidget: (val, meta) =>
                  _getBottomTitleWidgets(val, meta, categories),
            ),
            axisNameWidget: const Text(
              "Category",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 45,
              getTitlesWidget: _getLeftTitleWidgets,
            ),
            axisNameWidget: const Text(
              "Total Customers",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(const Color(0xFFEF4444), 'Churned'),
        const SizedBox(width: 24),
        _legendItem(const Color(0xFF10B981), 'Retained'),
      ],
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
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

  Widget _buildPieChart() {
    final colors = [
      const Color(0xFF3B82F6),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
      const Color(0xFFEF4444),
      const Color(0xFF8B5CF6),
    ];
    return PieChart(
      PieChartData(
        sectionsSpace: 3,
        centerSpaceRadius: 50,
        sections: List.generate(_processedData.length, (index) {
          final category = _processedData.keys.toList()[index];
          final total =
              _processedData[category]!['churned']! +
              _processedData[category]!['retained']!;
          return PieChartSectionData(
            color: colors[index % colors.length],
            value: total.toDouble(),
            title: '$category\n($total)',
            radius: 90,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }
}
