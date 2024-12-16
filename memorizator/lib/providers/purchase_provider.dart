import 'dart:async';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:memorizator/services/constants.dart';
//import 'package:memorizator/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import 'package:uuid/uuid.dart';

class PurchaseProvider extends ChangeNotifier {
  final BuildContext context;
  PurchaseProvider(this.context) {
    _initialize();
    signInSilently();
  }

  // Блок авторизации - инициализация
  GoogleSignInAccount? googleUser;
  String userEmail = '';
  String userId = '';
  static const List<String> scopes = <String>[
    'email',
  ];
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: scopes,
  );
  GoogleSignIn get googleSignIn => _googleSignIn;
  // конец блока авторизации

  bool _shopIsAvailable = false;
  bool get isAvailable => _shopIsAvailable;
  List<ProductDetails> _products = [];
  List<ProductDetails> get products => _products;

  String purchaseMessage = '';
  Map mapPurchaseMessage = {
    'progress': 'Processing your purchase...',
    'complete': 'The purchase is completed.',
    'error': 'Error in the purchase process.'
  };

  bool _purchaseProcessing = true;
  bool get purchaseProcessing => _purchaseProcessing;
  bool isPurchaseComplete = false;

  String userDonationStatus = 'none';
  //bool isPaidUser = false; // платный пользователь
  bool isPaidUser = false;

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;

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
        //print('Магазин доступен');
        _loadProducts();
        _subscription = _iap.purchaseStream.listen((purchases) {
          _handlePurchaseUpdates(purchases);
        });
      } else {
        //print('Магазин недоступен');
      }
    } catch (e) {
      _shopIsAvailable = false;
      //print('Ошибка подключения к Google Play: $e');
      notifyListeners();
    }
  }

  Future<void> _loadDonationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getString('donationStatus');
    if (status != null) {
      if (status.isNotEmpty) {
        isPaidUser = true;
        userDonationStatus = status;
        return;
      }
    }

    getUserPurchases();
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
    notifyListeners();
  }

  void buyProduct(ProductDetails product, BuildContext context) {
    // формируем сообщения о ходе покупки для пользователя
    purchaseMessage = mapPurchaseMessage["progress"];
    // покупка в процессе
    _purchaseProcessing = true;
    isPurchaseComplete = false;
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyConsumable(purchaseParam: purchaseParam);
    //testPurchases(); // тестовая покупка
    notifyListeners();
  }

  Future<void> cleanStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('donationStatus', '');
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    //await waitForThreeSeconds(); // for test

    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        for (DonationStatus status in DonationStatus.values) {
          //String signedData = purchase.verificationData.localVerificationData;
          //String signature = purchase.verificationData.serverVerificationData;
          //bool isValid = Security.verifyPurchase(signedData, signature);
          if (purchase.productID == status.toString().split('.').last) {
            //print('Покупка доната успешно завершена: ${purchase.productID}');
            purchaseMessage = mapPurchaseMessage['complete'];
            _purchaseProcessing = false;
            isPurchaseComplete = true;
            saveUserData(userId, userEmail, purchase.productID);
            InAppPurchase.instance.completePurchase(purchase);
            userDonationStatus = status.toString().split('.').last;
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('donationStatus', userDonationStatus);
            isPaidUser = true;
            notifyListeners();
            break;
          }
        }
      } else if (purchase.status == PurchaseStatus.error) {
        //('Ошибка при покупке: ${purchase.error}');
        purchaseMessage = mapPurchaseMessage['error'];
        _purchaseProcessing = false;
        notifyListeners();
      }

      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
      }
    }
  }

// Тестовая функция для имитации покупок

  void testPurchases() {
    // формируем сообщения о ходе покупки для пользователя
    purchaseMessage = mapPurchaseMessage["progress"];
    // покупка в процессе
    _purchaseProcessing = true;
    isPurchaseComplete = false;

    //waitForThreeSeconds();

    StreamController<List<PurchaseDetails>> controller =
        StreamController<List<PurchaseDetails>>();
    _subscription = controller.stream.listen((purchases) {
      _handlePurchaseUpdates(purchases);
    });

    // Триггерирование обновления потока с тестовыми данными
    PurchaseDetails testPurchase = createTestPurchaseDetails();
    controller.add([testPurchase]); // Отправляем тестовые данные покупок

    // Подождите немного времени перед закрытием для имитации асинхронной обработки
    Future.delayed(
      const Duration(seconds: 3),
      () {
        controller.close();
        _subscription!.cancel();
      },
    );
  }

  Future<void> waitForThreeSeconds() async {
    await Future.delayed(const Duration(seconds: 3));
  }

  PurchaseDetails createTestPurchaseDetails() {
    final String fakePurchaseID = const Uuid().v4();

    return PurchaseDetails(
      productID: "donate_5",
      purchaseID: fakePurchaseID,
      status: PurchaseStatus.purchased,
      transactionDate: DateTime.now().millisecondsSinceEpoch.toString(),
      verificationData: PurchaseVerificationData(
          localVerificationData: "test_local_verification_data",
          serverVerificationData: "test_server_verification_data",
          source: "test_source"),
    );
  }

  // Пример метода для обновления статуса доната

  void restorePurchases() {
    _iap.restorePurchases();
  }

  Future<bool> userAuth() async {
    // Проверяем, авторизован ли пользователь
    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Если пользователь не авторизован, выполняем вход через Google Sign-In
      if (user == null) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          //print("Google Sign-In был отменен пользователем.");
          return false;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Выполняем авторизацию в Firebase с использованием учетных данных
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        user = userCredential.user;
        //print("Пользователь вошел: ${user?.uid}");
        return true;
      } else {
        return true;
      }
    } catch (e) {
      //print("Ошибка при авторизации Auth() пользователя: $e");
      return false;
    }
  }

  Future<void> saveUserData(
      String userId, String userEmail, String productID) async {
    await userAuth();
    try {
      // Сохраняем данные о покупке в Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

// Сначала сохраняем информацию о пользователе, если её ещё нет
      await firestore.collection('users').doc(userId).set({
        'userId': userId,
        'userEmail': userEmail,
      }, SetOptions(merge: true));

// Затем добавляем информацию о покупке в подколлекцию 'purchases'
      await firestore
          .collection('users')
          .doc(userId)
          .collection('purchases')
          .add({
        'purchaseDate': DateTime.now(), // Дата покупки
        'productID': productID, // Идентификатор продукта
      });

      //print("Данные пользователя и информация о покупке успешно сохранены.");
    } catch (e) {
      //print("Ошибка при сохранении данных пользователя saveUserData(): $e");
    }
  }

  Future<List<Map<String, dynamic>>> getUserPurchases() async {
    await userAuth();
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Запрашиваем коллекцию purchases для данного пользователя
      QuerySnapshot purchasesSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('purchases')
          .get();

      // Преобразуем данные в список карт
      List<Map<String, dynamic>> purchases = purchasesSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      // Получаем последнюю по времени покупку
      purchases.sort((a, b) {
        Timestamp timestampA = a['purchaseDate'] as Timestamp;
        Timestamp timestampB = b['purchaseDate'] as Timestamp;
        return timestampA.compareTo(timestampB);
      });
      Map<String, dynamic> latestPurchase =
          purchases.isNotEmpty ? purchases.last : {};
      if (latestPurchase.isNotEmpty) {
        isPaidUser = true;
        String status = latestPurchase['productID'] as String;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('donationStatus', status);
        userDonationStatus = status;
      }
      notifyListeners();
      return purchases;
    } catch (e) {
      //print("Error fetching user purchases saveUserData(): $e");
      return [];
    }
  }

  Future<void> signInSilently() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Читаем сохраненную настройку email
    userEmail = prefs.getString('useremail') ?? '';
    userId = prefs.getString('userid') ?? '';

    // если не сохранен email пользователя, просим авторизацию
    if (userEmail.isEmpty) {
      try {
        //if (googleUser == null) {
        GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently();
        //}

        if (googleUser != null) {
          userEmail = googleUser.email;
          userId = googleUser.id;
          prefs.setString('useremail', googleUser.email);
          prefs.setString('userid', googleUser.id);
        } else {
          signInWithGoogle();
        }
      } catch (error) {
        //print('Ошибка тихого входа в Google: $error');
        userEmail = error.toString();
        userId = error.toString();
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      //GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        userEmail = googleUser.email;
        userId = googleUser.id;
        prefs.setString('useremail', googleUser.email);
        prefs.setString('userid', googleUser.id);
      }
    } catch (error) {
      userEmail = error.toString();
      userId = error.toString();
    }
  }
}
