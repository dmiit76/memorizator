import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
import 'package:memorizator/services/constants.dart';
import 'package:memorizator/services/security.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseProvider extends ChangeNotifier {
  bool _shopIsAvailable = false;
  bool get isAvailable => _shopIsAvailable;
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  String _purchaseMessage = 'Processing your purchase...';
  String get purchaseMessage => _purchaseMessage;
  bool _purchaseProcessing = true;
  bool get purchaseProcessing => _purchaseProcessing;

  DonationStatus _userDonationStatus = DonationStatus.none;
  DonationStatus get userDonationStatus => _userDonationStatus;
  //bool isPaidUser = false; // платный пользователь
  bool get isPaidUser => _userDonationStatus != DonationStatus.none;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final AdManager _adManager = AdManager(); // Экземпляр AdManager

  PurchaseProvider() {
    _initialize(); // Только один вызов _initialize()
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _initializePurchaseSystem();
    await _loadDonationStatus();
  }

  // Подключааемся к системе покупок, получаем информацию.
  Future<void> _initializePurchaseSystem() async {
    try {
      bool shopAvailable = await _iap.isAvailable();
      _shopIsAvailable = shopAvailable;
      notifyListeners();

      if (_shopIsAvailable) {
        print('Магазин доступен');
        _loadProducts();
        _subscription = _iap.purchaseStream.listen((purchases) {
          _handlePurchaseUpdates(purchases);
        });
      } else {
        print('Магазин недоступен');
      }
    } catch (e) {
      _shopIsAvailable = false;
      print('Ошибка подключения к Google Play: $e');
      notifyListeners();
    }
  }

  Future<void> _loadDonationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString('donationStatus');
    if (status != null) {
      _userDonationStatus =
          DonationStatus.values.firstWhere((e) => e.toString() == status);
      //isPaidUser = (_userDonationStatus != DonationStatus.none) ? true : false;
    }
    notifyListeners();
  }

  Future<void> _loadProducts() async {
    // Получаем список статусов
    Set<String> kIds =
        DonationStatus.values.map((e) => e.toString().split('.').last).toSet();
    // Получаем список доступных продуктов
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Обработка продуктов, которые не были найдены
      // здесь продукт 'none'
    }
    // здесь список доступных продуктов
    List<ProductDetails> loadedProducts = response.productDetails;
    //Сортируем продукты по цене
    loadedProducts.sort((a, b) {
      double priceA = double.parse(a.price.replaceAll(RegExp(r'[^\d.]'), ''));
      double priceB = double.parse(b.price.replaceAll(RegExp(r'[^\d.]'), ''));
      return priceA.compareTo(priceB); // Сортировка по возрастанию
    });

    // // Обновляем список продуктов
    _products = loadedProducts;
    // notifyListeners(); // Если используется ChangeNotifier для уведомления слушателей об изменениях
    //_products = response.productDetails;
    notifyListeners();
  }

// вызывается по нажатию кнопки "купить"
  void buyProduct(ProductDetails product) {
    // формируем сообщения о ходе покупки для пользователя
    _purchaseMessage = 'Processing your purchase...';
    // покупка в процессе
    _purchaseProcessing = true;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        for (DonationStatus status in DonationStatus.values) {
          String signedData = purchase.verificationData.localVerificationData;
          String signature = purchase.verificationData.serverVerificationData;
          bool isValid = Security.verifyPurchase(signedData, signature);
          if (isValid &&
              purchase.productID == status.toString().split('.').last) {
            print('Покупка доната успешно завершена: ${purchase.productID}');
            _purchaseMessage = 'The purchase is completed.';
            _purchaseProcessing = false;
            InAppPurchase.instance.completePurchase(purchase);
            updateDonationStatus(status);
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('donationStatus', status.toString());
            break;
          }
        }
      } else if (purchase.status == PurchaseStatus.error) {
        print('Ошибка при покупке: ${purchase.error}');
        _purchaseMessage = 'Error in the purchase process.';
        _purchaseProcessing = false;
      }

      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

  // Пример метода для обновления статуса доната
  void updateDonationStatus(DonationStatus newStatus) {
    _userDonationStatus = newStatus;
    notifyListeners();
  }

  void restorePurchases() {
    _iap.restorePurchases();
  }

  void loadInterstitialAd() {
    _adManager.loadInterstitialAd();
  }

  void showInterstitialAd() {
    _adManager.showInterstitialAd();
  }
}
