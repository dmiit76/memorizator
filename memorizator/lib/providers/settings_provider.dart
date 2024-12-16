import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forex_currency_conversion/forex_currency_conversion.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:memorizator/generated/intl/messages_all.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
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
    fetchConfig();
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

  DateTime lastBoxCompact = DateTime.now();
  bool setClearResult = true;
  bool setFrameDigit = true;
  double setWidthColumn3 = 130;
  double setFontSizeProduct = 16;
  String setPriceFormat = ",##0.00";
  String setCurrencyController = '1';
  String pathForPhoto = '';
  DonationStatus donationStatus = DonationStatus.none;
  String codeLocalCurrency = 'USD';
  String codeMyCurrency = 'USD';
  TextEditingController localCurrencyController =
      TextEditingController(text: '');
  TextEditingController myCurrencyController = TextEditingController(text: '');
  TextEditingController currencyController = TextEditingController(text: '1');

  final AdManager _adManager = AdManager(); // Экземпляр AdManager

  final remoteConfig = FirebaseRemoteConfig.instance;
  bool _testMode = true; // Храним значение конфигурации
  double _percentAdPage = 30.0;
  bool get testMode => _testMode;
  String memorizatorAdMobID = 'ca-app-pub-3940256099942544~3347511713';
  String memorizatorBannerAd = 'ca-app-pub-3940256099942544/6300978111';
  String memorizatorBannerAdPage = 'ca-app-pub-3940256099942544/1033173712';
  String memorizatorAdMobIDiOS = 'ca-app-pub-3940256099942544~1458002511';
  String memorizatorBannerAdiOS = 'ca-app-pub-3940256099942544/2934735716';
  String memorizatorBannerAdPageiOS = 'ca-app-pub-3940256099942544/4411468910';

// await remoteConfig.setConfigSettings(RemoteConfigSettings(
//     fetchTimeout: const Duration(minutes: 1),
//     minimumFetchInterval: const Duration(hours: 1),
// ));

  Future<void> fetchConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(minutes: 60),
        ),
      );
      // Заменяем expiration на cacheExpiration
      await remoteConfig.fetchAndActivate();
      // Читаем значение переменной testMode
      _testMode = remoteConfig.getBool('testMode');
      _percentAdPage = remoteConfig.getDouble('percentAdPage');
      // Сохраняем её в памяти
      await prefs.setBool('testmode', _testMode);

      // Уведомляем всех слушателей, что данные обновились
      notifyListeners();
    } catch (e) {
      //print('Error fetching remote config: $e');
      // Если не удается получить из Firebase, читаем сохраненную в настройках
      _testMode = prefs.getBool('testmode') ?? false;
    }
    if (testMode) {
      memorizatorAdMobID = 'ca-app-pub-3940256099942544~3347511713';
      memorizatorBannerAd = 'ca-app-pub-3940256099942544/6300978111';
      memorizatorBannerAdPage = 'ca-app-pub-3940256099942544/1033173712';
//memorizatorAdMobIDiOS = 'ca-app-pub-3940256099942544~1458002511';
//memorizatorBannerAdiOS = 'ca-app-pub-3940256099942544/2934735716';
//memorizatorBannerAdPageiOS = 'ca-app-pub-3940256099942544/4411468910';
    } else {
      memorizatorAdMobID = 'ca-app-pub-7889852441350586~7754231542';
      memorizatorBannerAd = 'ca-app-pub-7889852441350586/1610790758';
      memorizatorBannerAdPage = 'ca-app-pub-7889852441350586/3551392536';
//memorizatorAdMobIDiOS = '';
//memorizatorBannerAdiOS = '';
//memorizatorBannerAdPageiOS = '';
    }
  }

// Загрузчик межстраничной рекламы
  void loadInterstitialAd() {
    String adUnitId = Platform.isAndroid
        ? memorizatorBannerAdPage
        : memorizatorBannerAdPageiOS;
    var intValue = Random().nextInt(100);
    if (intValue <= _percentAdPage) {
      _adManager.loadInterstitialAd(adUnitId);
    }
  }

  void showInterstitialAd() {
    String adUnitId = Platform.isAndroid
        ? memorizatorBannerAdPage
        : memorizatorBannerAdPageiOS;
    _adManager.showInterstitialAd(adUnitId);
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
  }

  // 'ar':
  // 'bn':
  // 'de':
  // 'en':
  // 'es':
  // 'fr':
  // 'hi':
  // 'it':
  // 'ja':
  // 'ko':
  // 'pt':
  // 'ru':
  // 'tr':
  // 'vi':
  // 'zh':

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
