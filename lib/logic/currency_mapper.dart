import 'dart:convert';
import 'package:equaly/logic/utils/snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    final regExp = RegExp(r'^\d*\.?\d{0,2}$');
    if (regExp.hasMatch(text)) {
      return newValue;
    }

    return oldValue;
  }
}

class CurrencyMapper {
  static Map<String, String> _currencyMap = {};
  static Map<String, dynamic> _currencyConversionMap = {};

  static Future<void> initialize() async {
    if (_currencyMap.isEmpty) {
      String jsonString = await rootBundle.loadString('assets/currencies.json');
      _currencyMap = Map<String, String>.from(json.decode(jsonString));
    }

    try {
      final response = await http.get(Uri.parse('http://www.convertmymoney.com/rates.json'));
      if (response.statusCode != 200) {
        throw Exception("${response.statusCode} ${response.body}");
      }
      var data = json.decode(response.body) as Map<String, dynamic>;
      _currencyConversionMap = data.remove("rates");
    } on http.ClientException catch (_) {
      showSnackBarWithException("Connection Timeout");
    } on Exception catch (exception) {
      showSnackBarWithException(exception.toString());
    }
  }

  static Map<String, String> getAllCurrencies() {
    return _currencyMap;
  }

  static String? getSymbol(String currencyCode) {
    return _currencyMap[currencyCode];
  }

  static double convertToMainCurrency(double value, String from, String to) {
    var fromUSDRate = _currencyConversionMap[from];
    var targetUSDRate = _currencyConversionMap[to];

    var valueAsUSD = value / fromUSDRate;
    var valueAsTargetCurrency = valueAsUSD * targetUSDRate;
    return valueAsTargetCurrency;
  }
}
