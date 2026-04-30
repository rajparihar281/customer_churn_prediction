// lib/services/data_service.dart
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'dart:convert';
import '../models/customer_profile.dart';

class DataService {
  // Helper function to safely parse values into doubles
  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    // Handles empty strings or non-numeric text gracefully
    return double.tryParse(value.toString().trim()) ?? 0.0;
  }

  // Helper function to safely parse values into integers
  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString().trim()) ?? 0;
  }

  Future<List<CustomerProfile>> loadAndMergeData() async {
    final rawCsvData = await rootBundle.loadString(
      'assets/data/processed_customer_churn_data_with_feedback.csv',
    );
    final rawJsonData = await rootBundle.loadString(
      'assets/data/shap_all_customers.json',
    );

    // This makes the parsing more predictable by letting our helpers handle all conversions.
    final List<List<dynamic>> csvList = const CsvToListConverter().convert(
      rawCsvData,
    );

    if (csvList.isEmpty) {
      return [];
    }

    final csvHeaders = csvList[0].map((h) => h.toString().trim()).toList();
    final csvRows = csvList.skip(1);

    final csvMap = csvRows.map((row) {
      final map = <String, dynamic>{};
      for (var i = 0; i < csvHeaders.length; i++) {
        if (i < row.length) {
          map[csvHeaders[i]] = row[i];
        }
      }
      return map;
    }).toList();

    final List<dynamic> jsonList = json.decode(rawJsonData);
    final shapMap = {for (var item in jsonList) item['customerID']: item};

    final List<CustomerProfile> profiles = [];
    final contractMap = {
      '0': 'Month-to-month',
      '1': 'One year',
      '2': 'Two year',
    };
    final paymentMethodMap = {
      '0': 'Bank transfer (automatic)',
      '1': 'Credit card (automatic)',
      '2': 'Electronic check',
      '3': 'Mailed check',
    };

    for (var customerCsv in csvMap) {
      final customerId = customerCsv['customerID'];
      if (customerId == null || !shapMap.containsKey(customerId)) {
        continue;
      }

      final customerShap = shapMap[customerId];
      try {
        profiles.add(
          CustomerProfile(
            customerID: customerId.toString(),
            gender: _parseInt(customerCsv['gender']) == 1 ? 'Male' : 'Female',
            isSeniorCitizen: _parseInt(customerCsv['SeniorCitizen']) == 1,
            hasPartner: _parseInt(customerCsv['Partner']) == 1,
            hasDependents: _parseInt(customerCsv['Dependents']) == 1,
            tenure: _parseDouble(customerCsv['tenure']),
            hasPhoneService: _parseInt(customerCsv['PhoneService']) == 1,
            multipleLines: _parseInt(customerCsv['MultipleLines']) == 0
                ? 'No'
                : _parseInt(customerCsv['MultipleLines']) == 1
                ? 'No phone service'
                : 'Yes',
            internetService: _parseInt(customerCsv['InternetService']) == 0
                ? 'DSL'
                : _parseInt(customerCsv['InternetService']) == 1
                ? 'Fiber optic'
                : 'No',
            onlineSecurity: _parseInt(customerCsv['OnlineSecurity']) == 0
                ? 'No'
                : _parseInt(customerCsv['OnlineSecurity']) == 1
                ? 'No internet'
                : 'Yes',
            onlineBackup: _parseInt(customerCsv['OnlineBackup']) == 0
                ? 'No'
                : _parseInt(customerCsv['OnlineBackup']) == 1
                ? 'No internet'
                : 'Yes',
            deviceProtection: _parseInt(customerCsv['DeviceProtection']) == 0
                ? 'No'
                : _parseInt(customerCsv['DeviceProtection']) == 1
                ? 'No internet'
                : 'Yes',
            techSupport: _parseInt(customerCsv['TechSupport']) == 0
                ? 'No'
                : _parseInt(customerCsv['TechSupport']) == 1
                ? 'No internet'
                : 'Yes',
            streamingTV: _parseInt(customerCsv['StreamingTV']) == 0
                ? 'No'
                : _parseInt(customerCsv['StreamingTV']) == 1
                ? 'No internet'
                : 'Yes',
            streamingMovies: _parseInt(customerCsv['StreamingMovies']) == 0
                ? 'No'
                : _parseInt(customerCsv['StreamingMovies']) == 1
                ? 'No internet'
                : 'Yes',
            contract:
                contractMap[customerCsv['Contract'].toString()] ?? 'Unknown',
            isPaperlessBilling: _parseInt(customerCsv['PaperlessBilling']) == 1,
            paymentMethod:
                paymentMethodMap[customerCsv['PaymentMethod'].toString()] ??
                'Unknown',
            monthlyCharges: _parseDouble(customerCsv['MonthlyCharges']),
            totalCharges: _parseDouble(customerCsv['TotalCharges']),
            didChurn: _parseInt(customerCsv['Churn']) == 1,
            feedback:
                customerCsv['Feedback']?.toString() ?? 'No feedback given.',
            churnPrediction: _parseInt(customerShap['churn_prediction']),
            churnProbability: _parseDouble(customerShap['churn_probability']),
            topShapFeatures: ShapFeatures.fromJson(
              customerShap['top_shap_features'],
            ),
          ),
        );
      } catch (e) {
        // ignore: avoid_print
        print('Could not process customer $customerId due to error: $e');
      }
    }
    return profiles;
  }
}
