import 'dart:convert';
import 'package:flutter/services.dart';

class CurrencyMapper {
  static Map<String, String> _currencyMap = {};

  static Future<void> initialize() async {
    if (_currencyMap.isEmpty) {
      String jsonString = await rootBundle.loadString('assets/currencies.json');
      _currencyMap = Map<String, String>.from(json.decode(jsonString));
    }
  }

  static Map<String, String> getAllCurrencies() {
    return _currencyMap;
  }

  static String? getSymbol(String currencyCode) {
    return _currencyMap[currencyCode];
  }
}