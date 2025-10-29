// lib/models/customer_profile.dart

class ShapFeatures {
  final List<String> features;
  final List<double> values;

  ShapFeatures({required this.features, required this.values});

  factory ShapFeatures.fromJson(Map<String, dynamic> json) {
    return ShapFeatures(
      features: List<String>.from(json['features']),
      values: List<dynamic>.from(
        json['values'],
      ).map((e) => (e as num).toDouble()).toList(),
    );
  }
}

class CustomerProfile {
  // ... (all existing properties remain the same)
  final String customerID;
  final String gender;
  final bool isSeniorCitizen;
  final bool hasPartner;
  final bool hasDependents;
  final double tenure;
  final bool hasPhoneService;
  final String multipleLines;
  final String internetService;
  final String onlineSecurity;
  final String onlineBackup;
  final String deviceProtection;
  final String techSupport;
  final String streamingTV;
  final String streamingMovies;
  final String contract;
  final bool isPaperlessBilling;
  final String paymentMethod;
  final double monthlyCharges;
  final double totalCharges;
  final bool didChurn;
  final String feedback;

  final int churnPrediction;
  final double churnProbability;
  final ShapFeatures topShapFeatures;

  String get riskStatus {
    if (churnProbability >= 0.66) return 'Likely to Churn';
    if (churnProbability >= 0.33) return 'At Risk';
    return 'Likely to Stay';
  }

  // ** ADD THIS NEW GETTER for Sentiment Analysis **
  String get feedbackSentiment {
    try {
      // Check if 'SentimentScore' is one of the top features affecting churn
      final index = topShapFeatures.features.indexOf('SentimentScore');
      if (index != -1) {
        final value = topShapFeatures.values[index];
        // If the sentiment score's impact REDUCED churn risk, it was POSITIVE
        if (value < -0.1) return 'Positive';
        // If the sentiment score's impact INCREASED churn risk, it was NEGATIVE
        if (value > 0.1) return 'Negative';
      }
      // Otherwise, its impact was neutral
      return 'Neutral';
    } catch (e) {
      return 'Neutral';
    }
  }

  CustomerProfile({
    required this.customerID,
    required this.gender,
    required this.isSeniorCitizen,
    required this.hasPartner,
    required this.hasDependents,
    required this.tenure,
    required this.hasPhoneService,
    required this.multipleLines,
    required this.internetService,
    required this.onlineSecurity,
    required this.onlineBackup,
    required this.deviceProtection,
    required this.techSupport,
    required this.streamingTV,
    required this.streamingMovies,
    required this.contract,
    required this.isPaperlessBilling,
    required this.paymentMethod,
    required this.monthlyCharges,
    required this.totalCharges,
    required this.didChurn,
    required this.feedback,
    required this.churnPrediction,
    required this.churnProbability,
    required this.topShapFeatures,
  });
}
