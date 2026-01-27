import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Custom delegate for Somali
class SomaliMaterialLocalizations extends DefaultMaterialLocalizations {
  const SomaliMaterialLocalizations();

  static Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(
      const SomaliMaterialLocalizations(),
    );
  }

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
  _SomaliMaterialLocalizationsDelegate();
}

class _SomaliMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _SomaliMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'so';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SomaliMaterialLocalizations.load(locale);

  @override
  bool shouldReload(_SomaliMaterialLocalizationsDelegate old) => false;
}

// Cupertino version
class SomaliCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const SomaliCupertinoLocalizations();

  static Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
      const SomaliCupertinoLocalizations(),
    );
  }

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
  _SomaliCupertinoLocalizationsDelegate();
}

class _SomaliCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _SomaliCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'so';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SomaliCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(_SomaliCupertinoLocalizationsDelegate old) => false;
}