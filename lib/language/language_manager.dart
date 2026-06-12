import 'package:flutter/material.dart';
import 'strings.dart';

class LanguageManager extends ChangeNotifier {
  String _currentLanguageCode = 'EN';
  String _dropdownValue = 'English';

  String get currentLanguageCode => _currentLanguageCode;
  String get dropdownValue => _dropdownValue;

  void setLanguageFromDropdown(String dropdownValue) {
    _dropdownValue = dropdownValue;
    if (dropdownValue == 'Bahasa') {
      _currentLanguageCode = 'ID';
    } else if (dropdownValue == '忍者') {
      _currentLanguageCode = 'JP';
    } else {
      // 'English' or 'Tamriel'
      _currentLanguageCode = 'EN';
    }
    notifyListeners();
  }

  void setLanguageCode(String code) {
    _currentLanguageCode = code;
    if (code == 'ID') {
      _dropdownValue = 'Bahasa';
    } else if (code == 'JP') {
      _dropdownValue = '忍者';
    } else {
      _dropdownValue = 'English';
    }
    notifyListeners();
  }

  String getString(String key) {
    return AppStrings.translations[_currentLanguageCode]?[key] ?? key;
  }
}
