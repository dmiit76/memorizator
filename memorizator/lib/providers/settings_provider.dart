import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forex_currency_conversion/forex_currency_conversion.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:memorizator/generated/intl/messages_all.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/services/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:memorizator/screens/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:currency_picker/currency_picker.dart';

class SettingsProvider extends ChangeNotifier {
  final BuildContext context;
  SettingsProvider(this.context) {
    pathPhoto();
    loadLocaleFromPreferences();
    getPackageInfo();
    signInSilently();
  }
  PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  Locale currentLocale = const Locale('en');

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  //GoogleSignIn _googleSignIn;
  GoogleSignIn get googleSignIn => _googleSignIn;

  //Locale get currentLocale => _currentLocale;

  DateTime lastBoxCompact = DateTime.now();
  bool setClearResult = true;
  bool setFrameDigit = true;
  double setWidthColumn3 = 130;
  double setFontSizeProduct = 16;
  String setPriceFormat = ",##0.00";
  String setCurrencyController = '1';
  String pathForPhoto = '';
  DonationStatus donationStatus = DonationStatus.none;
  //Currency? localCurrency;
  //Currency? myCurrency;
  String codeLocalCurrency = 'USD';
  String codeMyCurrency = 'USD';
  TextEditingController localCurrencyController =
      TextEditingController(text: '');
  TextEditingController myCurrencyController = TextEditingController(text: '');
  TextEditingController currencyController = TextEditingController(text: '1');
  GoogleSignInAccount? googleUser;
  String userEmail = '';
  String userId = '';

  Future<void> signInSilently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Читаем сохраненную настройку email
    userEmail = prefs.getString('useremail') ?? '';
    userId = prefs.getString('userid') ?? '';
    if (userEmail
        .isEmpty) // если не сохранен email пользователя, просим авторизацию
    {
      try {
        //if (googleUser == null) {
        GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
        //}

        if (googleUser != null) {
          userEmail = googleUser.email;
          prefs.setString('useremail', googleUser.email);
          prefs.setString('userid', googleUser.id);
          // print("Google User ID: ${googleUser.id}"); // ID пользователя
          // print("Google User Email: ${googleUser.email}"); // Email пользователя
        } else {
          // print("Пользователь не вошёл в систему.");
          signInWithGoogle();
        }
      } catch (error) {
        //print('Ошибка тихого входа в Google: $error');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userEmail = googleUser.email;
        prefs.setString('useremail', googleUser.email);
        prefs.setString('userid', googleUser.id);
      }
    } catch (error) {
      userEmail = error.toString();
      userId = error.toString();
      print('Ошибка входа в Google: $error');
    }
  }

// Загрузка сохраненной локали из SharedPreferences
  Future<void> loadLocaleFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    String? countryCode = prefs.getString('countryCode');

    if (languageCode != null) {
      currentLocale = Locale(languageCode, countryCode);
    } else {
      // Установим системную локаль по умолчанию
      currentLocale = PlatformDispatcher.instance.locale;
    }
  }

  // Сохранение выбранной локали в SharedPreferences
  Future<void> changeLocale(String languageCode) async {
    var countryCode = getLocaleName(Locale(languageCode));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    await prefs.setString('countryCode', countryCode);
    currentLocale = Locale(languageCode, countryCode);
    // Инициализация новой локали
    await initializeMessages(languageCode);
    Intl.defaultLocale = languageCode;

    notifyListeners();
  }

  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'bn':
        return 'বাংলা';
      case 'de':
        return 'Deutsch';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'hi':
        return 'हिन्दी';
      case 'it':
        return 'Italiano';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'pt':
        return 'Português';
      case 'ru':
        return 'Русский';
      case 'tr':
        return 'Türkçe';
      case 'vi':
        return 'Tiếng Việt';
      case 'zh':
        return '中文';
      default:
        return locale.languageCode;
    }

    // switch (locale.languageCode) {
    //   case 'en':
    //     return 'English';
    //   case 'ar':
    //     return 'Arabic';
    //   case 'bn':
    //     return 'Bengali';
    //   case 'de':
    //     return 'German';
    //   case 'es':
    //     return 'Spanish';
    //   case 'fr':
    //     return 'French';
    //   case 'hi':
    //     return 'Hindi';
    //   case 'it':
    //     return 'Italian';
    //   case 'ja':
    //     return 'Japanese';
    //   case 'ko':
    //     return 'Korean';
    //   case 'pt':
    //     return 'Portuguese';
    //   case 'ru':
    //     return 'Russian';
    //   case 'tr':
    //     return 'Turkish';
    //   case 'vi':
    //     return 'Vietnamese';
    //   case 'zh':
    //     return 'Chinese';
    //   default:
    //     return locale.languageCode;
    // }
  }

  Future inputCurrencyController(String setCurrencyController) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('currency', double.tryParse(setCurrencyController) ?? 1);
    currencyController.text = setCurrencyController;

    notifyListeners();
  }

  // Проверяем, если введёён курс 0 или меньше, то устанавливаем курс 1.0
  Future controlCurrencyController(String setCurrencyController) async {
    refreshList.value = refreshList.value + 1;
    if (setCurrencyController.isEmpty ||
        double.tryParse(setCurrencyController)! <= 0) {
      setCurrencyController = '0.0';
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('currency', double.tryParse(setCurrencyController) ?? 1);
    currencyController.text = setCurrencyController;
    notifyListeners();
  }

  Future inputLocalCurrency(String codeLocalCurrency) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('codelocalcurrency', codeLocalCurrency);
    notifyListeners();
  }

  Future inputMyCurrency(String codeMyCurrency) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('codemycurrency', codeMyCurrency);
    notifyListeners();
  }

  Future inputClearResult(bool setClearResult) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('clearresult', setClearResult);
    notifyListeners();
  }

  Future inputFrameDigit(bool setFrameDigit) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('setframedigit', setFrameDigit);
    setPriceFormat = setFrameDigit ? ",##0.00" : "##0.00";
    notifyListeners();
  }

  Future inputWidthColumn3(double setWidthColumn3) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('setwidthcolumn3', setWidthColumn3);
    notifyListeners();
  }

  Future inputFontSizeProduct(double setFontSizeProduct) async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('setfontsizeproduct', setFontSizeProduct);
    refreshList.value = setFontSizeProduct;
    notifyListeners();
  }

  Future initSettings() async {
    refreshList.value = refreshList.value + 1;
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getDouble('currency') == null) {
      setCurrencyController = '1';
      prefs.setDouble('currency', double.parse(setCurrencyController));
    } else {
      setCurrencyController = prefs.getDouble('currency').toString();
      currencyController.text = setCurrencyController;
    }

    if (prefs.getBool('clearresult') == null) {
      setClearResult = true;
      prefs.setBool('clearresult', setClearResult);
    } else {
      setClearResult = prefs.getBool('clearresult') ?? true;
    }

    if (prefs.getBool('setframedigit') == null) {
      setFrameDigit = true;
      prefs.setBool('setframedigit', setFrameDigit);
    } else {
      setFrameDigit = prefs.getBool('setframedigit') ?? true;
    }
    setPriceFormat = setFrameDigit ? ",##0.00" : "##0.00";

    if (prefs.getDouble('setwidthcolumn3') == null) {
      setWidthColumn3 = 130.0; // 100-150
      prefs.setDouble('setwidthcolumn3', setWidthColumn3);
    } else {
      setWidthColumn3 = prefs.getDouble('setwidthcolumn3') ?? 100.0;
    }

    if (prefs.getDouble('setfontsizeproduct') == null) {
      setFontSizeProduct = 18.0; // 10-26
      prefs.setDouble('setfontsizeproduct', setFontSizeProduct);
    } else {
      setFontSizeProduct = prefs.getDouble('setfontsizeproduct') ?? 10.0;
    }

    codeLocalCurrency = prefs.getString('codelocalcurrency') ?? 'USD';
    if (codeLocalCurrency.isEmpty) {
      prefs.setString('codelocalcurrency', 'USD');
    }
    codeLocalCurrency = prefs.getString('codelocalcurrency') ?? 'USD';

    codeMyCurrency = prefs.getString('codemycurrency') ?? 'USD';
    if (codeMyCurrency.isEmpty) {
      prefs.setString('codemycurrency', 'USD');
    }
    codeMyCurrency = prefs.getString('codemycurrency') ?? 'USD';

    notifyListeners();
  }

  void doubleControl(String text) {
    currencyController.text;
    notifyListeners();
  }

  Future<String> pathPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    pathForPhoto = prefs.getString('pathgallery') ?? '';
    if (pathForPhoto.isNotEmpty) {
      if (Directory(pathForPhoto).existsSync()) {
        return pathForPhoto; // Возвращаем сохраненную дирректорию для фото
      }
    }
    Directory? appDirEx = await getExternalStorageDirectory();
    Directory appDir = await getApplicationDocumentsDirectory();

    if (Directory(appDirEx!.path).existsSync()) {
      appDir = appDirEx;
    }

    pathForPhoto = '${appDir.path}${Platform.pathSeparator}mygallery';
    Directory(pathForPhoto).create();
    prefs.setString('pathgallery', pathForPhoto);

    notifyListeners();
    return pathForPhoto;
  }

  Future<bool> isVisibleS() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double value = prefs.getDouble('currency') ?? 1;
    if (value == 0 || value == 1) {
      return false;
    } else {
      return true;
    }
  }

  String chooseCurrency1(BuildContext context, String code) {
    List<String> favofite = [];
    if (!favofite.contains(code)) {
      favofite.add(code);
    }
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showSearchField: true,
      favorite: favofite, // список валют для топа "избранные"
      onSelect: (Currency currency) {
        code = currency.code;
        //print('Selected currency: ${currency.name} (${currency.code})');
      },
    );
    return code;
  }

  void chooseCurrency2(BuildContext context, String currentCode) {
    List<String> favorite = [];
    if (!favorite.contains(currentCode)) {
      favorite.add(currentCode);
    }
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showSearchField: true,
      favorite: favorite, // список валют для топа "избранные"
      onSelect: (Currency currency) {
        currentCode = currency.code;
      },
    );
  }

  void chooseCurrency(BuildContext context, String initialCode,
      Function(String) onCurrencySelected) {
    List<String> favorite = [];
    if (!favorite.contains(initialCode)) {
      favorite.add(initialCode);
    }
    showCurrencyPicker(
      context: context,
      showFlag: true,
      showSearchField: true,
      favorite: favorite, // список валют для топа "избранные"
      onSelect: (Currency currency) {
        onCurrencySelected(
            currency.code); // Вызываем коллбек для изменения переменной
        notifyListeners(); // Обновляем UI
      },
    );
  }

// Используем CurrencyService для поиска валюты по коду
  Currency? getCurrencyByCode(String code) {
    return CurrencyService().findByCode(code);
  }

  // Widget getFlagWidget(String code) {
  //   Currency? currency = getCurrencyByCode(code);
  //   if (currency != null) {
  //     // Возвращаем флаг в формате текста
  //     return Text(currency.flag as String);
  //   } else {
  //     return const Text('Flag not found'); // Если код валюты не найден
  //   }
  // }

  Future<void> checkAndCompactDatabase(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt('lastboxcompact');
    // если настройка еще не определена, сохраняем текущую дату
    if (value == null) {
      value = DateTime.now().millisecondsSinceEpoch;
      prefs.setInt('lastboxcompact', value);
    }
    lastBoxCompact = DateTime.fromMillisecondsSinceEpoch(value);

    // Открываем box, если он не открыт
    var box = Hive.box<CalcRec>('calcrec');
    if (!box.isOpen) {
      box = await Hive.openBox<CalcRec>('calcrec');
    }

    // Проверяем, пора ли уплотнять базу данных
    if (DateTime.now().difference(lastBoxCompact).inDays >= 30) {
      try {
        // Проверяем, монтирован ли еще виджет перед показом индикатора загрузки
        if (context.mounted) {
          context.loaderOverlay.show();
        }

        // Имитация задержки
        await Future.delayed(const Duration(seconds: 1));

        // Уплотняем базу данных
        await box.compact();
        lastBoxCompact = DateTime.now();

        // Сохраняем дату последнего уплотнения в настройки
        prefs.setInt('lastboxcompact', DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        //print('Ошибка при уплотнении базы данных: $e');
      } finally {
        // Проверяем, монтирован ли еще виджет перед скрытием индикатора загрузки
        if (context.mounted) {
          context.loaderOverlay.hide();
        }
      }
    }
  }

  Future<void> getExchangeRate() async {
    final fx = Forex();

    // Получаем список поддерживаемых валют
    List<String> availableCurrencies = await fx.getAvailableCurrencies();

    // Проверяем, поддерживаются ли необходимые валюты
    if (availableCurrencies.contains(codeLocalCurrency) &&
        availableCurrencies.contains(codeMyCurrency)) {
      double rate = await fx.getCurrencyConverted(
          sourceCurrency: codeMyCurrency,
          destinationCurrency: codeLocalCurrency,
          sourceAmount: 1000000.0);
      currencyController.text = (rate / 1000000).toString();
      notifyListeners();
    } else {
      //print('Одна из валют не поддерживается');
    }
  }

  Future<void> getPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
