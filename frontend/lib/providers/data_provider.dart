// lib/providers/data_provider.dart
import 'package:flutter/material.dart';
import 'dart:developer';
import '../models/customer_profile.dart';
import '../services/data_service.dart';

enum DataState { loading, loaded, error }

class DataProvider with ChangeNotifier {
  final DataService _dataService = DataService();

  List<CustomerProfile> _allCustomers = [];
  List<CustomerProfile> _filteredCustomers = [];
  DataState _dataState = DataState.loading;
  String _searchQuery = '';

  List<CustomerProfile> get allCustomers => _allCustomers;
  List<CustomerProfile> get filteredCustomers => _filteredCustomers;
  DataState get dataState => _dataState;
  int get totalCustomers => _allCustomers.length;
  int get churnedCustomers => _allCustomers.where((c) => c.didChurn).length;
  int get retainedCustomers => _allCustomers.where((c) => !c.didChurn).length;
  double get churnRate =>
      totalCustomers > 0 ? (churnedCustomers / totalCustomers) * 100 : 0.0;

  // Getters for risk segments (now sorted on the fly)
  List<CustomerProfile> get highRiskCustomers =>
      _allCustomers.where((c) => c.churnProbability >= 0.66).toList()
        ..sort((a, b) => b.churnProbability.compareTo(a.churnProbability));
  List<CustomerProfile> get mediumRiskCustomers =>
      _allCustomers
          .where((c) => c.churnProbability >= 0.33 && c.churnProbability < 0.66)
          .toList()
        ..sort((a, b) => b.churnProbability.compareTo(a.churnProbability));
  List<CustomerProfile> get lowRiskCustomers =>
      _allCustomers.where((c) => c.churnProbability < 0.33).toList()
        ..sort((a, b) => b.churnProbability.compareTo(a.churnProbability));

  DataProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      _dataState = DataState.loading;
      notifyListeners();
      _allCustomers = await _dataService.loadAndMergeData();
      _filteredCustomers = _allCustomers;
      _dataState = DataState.loaded;
    } catch (e) {
      _dataState = DataState.error;
      log("Error fetching data: $e");
    }
    notifyListeners();
  }

  CustomerProfile? getCustomerById(String customerId) {
    try {
      return _allCustomers.firstWhere((c) => c.customerID == customerId);
    } catch (e) {
      return null;
    }
  }

  void search(String query) {
    _searchQuery = query;
    if (_searchQuery.isEmpty) {
      _filteredCustomers = _allCustomers;
    } else {
      _filteredCustomers = _allCustomers
          .where(
            (c) =>
                c.customerID.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }
}
