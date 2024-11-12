// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Last records`
  String get last_records {
    return Intl.message(
      'Last records',
      name: 'last_records',
      desc: '',
      args: [],
    );
  }

  /// `Filter products:`
  String get filterProducts {
    return Intl.message(
      'Filter products:',
      name: 'filterProducts',
      desc: '',
      args: [],
    );
  }

  /// `search string`
  String get searchString {
    return Intl.message(
      'search string',
      name: 'searchString',
      desc: '',
      args: [],
    );
  }

  /// `No records...`
  String get noRecords {
    return Intl.message(
      'No records...',
      name: 'noRecords',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get set {
    return Intl.message(
      'Set',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Selected records`
  String get selectedRecords {
    return Intl.message(
      'Selected records',
      name: 'selectedRecords',
      desc: '',
      args: [],
    );
  }

  /// `Error when copying`
  String get errorWhenCopying {
    return Intl.message(
      'Error when copying',
      name: 'errorWhenCopying',
      desc: '',
      args: [],
    );
  }

  /// `Choose source`
  String get chooseSource {
    return Intl.message(
      'Choose source',
      name: 'chooseSource',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Foto`
  String get fotoButton {
    return Intl.message(
      'Foto',
      name: 'fotoButton',
      desc: '',
      args: [],
    );
  }

  /// `BarCode`
  String get barcodeButton {
    return Intl.message(
      'BarCode',
      name: 'barcodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Save price:`
  String get savePrice {
    return Intl.message(
      'Save price:',
      name: 'savePrice',
      desc: '',
      args: [],
    );
  }

  /// `Enter product name `
  String get enterProductName {
    return Intl.message(
      'Enter product name ',
      name: 'enterProductName',
      desc: '',
      args: [],
    );
  }

  /// `weight, g`
  String get weightG {
    return Intl.message(
      'weight, g',
      name: 'weightG',
      desc: '',
      args: [],
    );
  }

  /// `Enter product weight`
  String get enterProductWeight {
    return Intl.message(
      'Enter product weight',
      name: 'enterProductWeight',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Currency`
  String get currency {
    return Intl.message(
      'Currency',
      name: 'currency',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteButton {
    return Intl.message(
      'Delete',
      name: 'deleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Memorized prices`
  String get memorizedPricesTitle {
    return Intl.message(
      'Memorized prices',
      name: 'memorizedPricesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Date:`
  String get date {
    return Intl.message(
      'Date:',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `g.`
  String get g_sentence {
    return Intl.message(
      'g.',
      name: 'g_sentence',
      desc: '',
      args: [],
    );
  }

  /// `A great product has been found!`
  String get aGreatProductHasBeenFound {
    return Intl.message(
      'A great product has been found!',
      name: 'aGreatProductHasBeenFound',
      desc: '',
      args: [],
    );
  }

  /// `by price`
  String get byPrice {
    return Intl.message(
      'by price',
      name: 'byPrice',
      desc: '',
      args: [],
    );
  }

  /// `Current entry`
  String get currentEntry {
    return Intl.message(
      'Current entry',
      name: 'currentEntry',
      desc: '',
      args: [],
    );
  }

  /// `Records`
  String get records {
    return Intl.message(
      'Records',
      name: 'records',
      desc: '',
      args: [],
    );
  }

  /// `View foto`
  String get viewFoto {
    return Intl.message(
      'View foto',
      name: 'viewFoto',
      desc: '',
      args: [],
    );
  }

  /// `remove foto from saving`
  String get removeFotoFromSaving {
    return Intl.message(
      'remove foto from saving',
      name: 'removeFotoFromSaving',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Local currency picker`
  String get localCurrencyPicker {
    return Intl.message(
      'Local currency picker',
      name: 'localCurrencyPicker',
      desc: '',
      args: [],
    );
  }

  /// `Select the currency of the country you are in`
  String get selectTheCurrencyOfTheCountryYouAreIn {
    return Intl.message(
      'Select the currency of the country you are in',
      name: 'selectTheCurrencyOfTheCountryYouAreIn',
      desc: '',
      args: [],
    );
  }

  /// `No set`
  String get noSet {
    return Intl.message(
      'No set',
      name: 'noSet',
      desc: '',
      args: [],
    );
  }

  /// `The currency of my country`
  String get theCurrencyOfMyCountry {
    return Intl.message(
      'The currency of my country',
      name: 'theCurrencyOfMyCountry',
      desc: '',
      args: [],
    );
  }

  /// `Select the currency you want to convert to`
  String get selectTheCurrencyYouWantToConvertTo {
    return Intl.message(
      'Select the currency you want to convert to',
      name: 'selectTheCurrencyYouWantToConvertTo',
      desc: '',
      args: [],
    );
  }

  /// `Local currency rate`
  String get localCurrencyRate {
    return Intl.message(
      'Local currency rate',
      name: 'localCurrencyRate',
      desc: '',
      args: [],
    );
  }

  /// `the value of your money in local currency`
  String get theValueOfYourMoneyInLocalCurrency {
    return Intl.message(
      'the value of your money in local currency',
      name: 'theValueOfYourMoneyInLocalCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Try to get the exchange rate`
  String get tryToGetTheExchangeRate {
    return Intl.message(
      'Try to get the exchange rate',
      name: 'tryToGetTheExchangeRate',
      desc: '',
      args: [],
    );
  }

  /// `Сlear the result after saving`
  String get learTheResultAfterSaving {
    return Intl.message(
      'Сlear the result after saving',
      name: 'learTheResultAfterSaving',
      desc: '',
      args: [],
    );
  }

  /// `Display price digits in the list`
  String get displayPriceDigitsInTheList {
    return Intl.message(
      'Display price digits in the list',
      name: 'displayPriceDigitsInTheList',
      desc: '',
      args: [],
    );
  }

  /// `Width of the column with prices in the list of records (100-150):`
  String get widthOfTheColumnWithPricesInTheListOf {
    return Intl.message(
      'Width of the column with prices in the list of records (100-150):',
      name: 'widthOfTheColumnWithPricesInTheListOf',
      desc: '',
      args: [],
    );
  }

  /// `Product name font size (10-26):`
  String get productNameFontSize {
    return Intl.message(
      'Product name font size (10-26):',
      name: 'productNameFontSize',
      desc: '',
      args: [],
    );
  }

  /// `This apps gallery`
  String get thisAppsGallery {
    return Intl.message(
      'This apps gallery',
      name: 'thisAppsGallery',
      desc: '',
      args: [],
    );
  }

  /// `INSTRUCTION (EN)`
  String get instructionTitle {
    return Intl.message(
      'INSTRUCTION (EN)',
      name: 'instructionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Support us by removing the ads.`
  String get supportUsByRemovingTheAds {
    return Intl.message(
      'Support us by removing the ads.',
      name: 'supportUsByRemovingTheAds',
      desc: '',
      args: [],
    );
  }

  /// `Support the app`
  String get supportTheApp {
    return Intl.message(
      'Support the app',
      name: 'supportTheApp',
      desc: '',
      args: [],
    );
  }

  /// `The store is unavailable. Check the connection.`
  String get theStoreIsUnavailableCheckTheConnection {
    return Intl.message(
      'The store is unavailable. Check the connection.',
      name: 'theStoreIsUnavailableCheckTheConnection',
      desc: '',
      args: [],
    );
  }

  /// `Select a language`
  String get selectALanguage {
    return Intl.message(
      'Select a language',
      name: 'selectALanguage',
      desc: '',
      args: [],
    );
  }

  /// `Support the application. Turn off the ads.`
  String get supportTheApplicationTurnOffTheAds {
    return Intl.message(
      'Support the application. Turn off the ads.',
      name: 'supportTheApplicationTurnOffTheAds',
      desc: '',
      args: [],
    );
  }

  /// `Error fun scanBarcode()`
  String get errorFunScanbarcode {
    return Intl.message(
      'Error fun scanBarcode()',
      name: 'errorFunScanbarcode',
      desc: '',
      args: [],
    );
  }

  /// `Enter price`
  String get enterPrice {
    return Intl.message(
      'Enter price',
      name: 'enterPrice',
      desc: '',
      args: [],
    );
  }

  /// `Note:`
  String get note {
    return Intl.message(
      'Note:',
      name: 'note',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'vi'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
