import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/services/card_storage.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class PurchaseNoGoogle extends StatefulWidget {
  const PurchaseNoGoogle({super.key});

  @override
  State<PurchaseNoGoogle> createState() => _PurchaseNoGoogleState();
}

class _PurchaseNoGoogleState extends State<PurchaseNoGoogle> {
  bool isLightTheme = false;
  String _startCardNumber = '';
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  CreditCardModel? _cardDetails;
  bool _isLoading = true;
  String? _errorMessage;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Future<CreditCardModel?>? _futureCardDetails;

  @override
  void initState() {
    super.initState();
    fetchDataCardDetails();
    _startCardNumber = cardNumber;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_cardDetails == null) {
      return const Center(child: Text('Нет сохраненных данных карты'));
    }

    final purchaseProvider = context.watch<PurchaseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Помощь разработчику'),
        // actions: [
        //   IconButton(
        //     onPressed: () => setState(() {
        //       isLightTheme = !isLightTheme;
        //     }),
        //     icon: Icon(
        //       isLightTheme ? Icons.light_mode : Icons.dark_mode,
        //       color: isLightTheme ? Colors.black : aLightGray,
        //     ),
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    margin:
                        EdgeInsets.only(left: 8, right: 4, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                      color: aLightGray,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Slider(
                      value: purchaseProvider.noGoogleDonateValue,
                      divisions: 3,
                      min: 1.0,
                      max: 4.0,
                      activeColor: aLightBlack,
                      thumbColor: aBlue,
                      onChanged: (double value) {
                        purchaseProvider.noGoogleDonateValue = value;
                        purchaseProvider.inputNoGoogleDonateValue(value);
                      },
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: aLightGray,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 80,
                  child: Text(
                    "\$" '${purchaseProvider.donationValue.truncate()}',
                    style: const TextStyle(fontSize: 28, color: aBlue),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 320,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: CreditCardWidget(
                  enableFloatingCard: useFloatingAnimation,
                  glassmorphismConfig: _getGlassmorphismConfig(),
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  bankName: 'Поддержка приложения',
                  frontCardBorder: Border.all(color: aLightBlue),
                  backCardBorder: Border.all(color: aLightBlue),
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor:
                      isLightTheme ? Colors.white : Colors.grey.shade800,
                  backgroundImage:
                      useBackgroundImage ? 'assets/card_bg.png' : null,
                  onCreditCardWidgetChange: (CreditCardBrand brand) {},
                ),
              ),
            ),
            // Виджет кредитной карты

            Expanded(
              child: SingleChildScrollView(
                child: CreditCardForm(
                  formKey: formKey,
                  obscureCvv: true,
                  obscureNumber: true,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  isHolderNameVisible: true,
                  isCardNumberVisible: true,
                  isExpiryDateVisible: true,
                  inputConfiguration: const InputConfiguration(
                    cardNumberDecoration: InputDecoration(
                      labelText: 'Number',
                      hintText: 'XXXX XXXX XXXX XXXX',
                    ),
                    expiryDateDecoration: InputDecoration(
                      labelText: 'Expired Date',
                      hintText: 'MM/YY',
                    ),
                    cvvCodeDecoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    cardHolderDecoration: InputDecoration(
                      labelText: 'Card Holder',
                    ),
                  ),
                  onCreditCardModelChange: onCreditCardModelChange,
                  // Добавляем валидаторы
                  cardNumberValidator: (String? cardNumber) {
                    if (cardNumber == null || cardNumber.isEmpty) {
                      return 'Введите номер карты';
                    } else if (cardNumber.replaceAll(' ', '').length != 16) {
                      return 'Номер карты должен содержать 16 цифр';
                    }
                    return null; // валидно
                  },
                  expiryDateValidator: (String? expiryDate) {
                    if (expiryDate == null || expiryDate.isEmpty) {
                      return 'Введите дату истечения';
                    } else if (!RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$')
                        .hasMatch(expiryDate)) {
                      return 'Введите дату в формате MM/YY';
                    }
                    return null;
                  },
                  cvvValidator: (String? cvv) {
                    if (cvv == null || cvv.isEmpty) {
                      return 'Введите CVV';
                    } else if (cvv.length != 3) {
                      return 'CVV должен содержать 3 цифры';
                    }
                    return null;
                  },
                  cardHolderValidator: (String? cardHolderName) {
                    if (cardHolderName == null || cardHolderName.isEmpty) {
                      return 'Введите имя владельца карты';
                    }
                    return null;
                  },
                ),
              ),
            ),
            GestureDetector(
              onTap: _onValidate,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: const Text(
                  'Validate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchDataCardDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final cardDetails = await CardStorage.loadCardDetails();
      setState(() {
        _cardDetails = cardDetails;
        cardNumber = cardDetails.cardNumber;
        expiryDate = cardDetails.expiryDate;
        cardHolderName = cardDetails.cardHolderName;
        cvvCode = cardDetails.cvvCode;
        isCvvFocused = cardDetails.isCvvFocused;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _onValidate() async {
    if (formKey.currentState?.validate() ?? true) {
      // Сохранение данных карты
      bool? resultAlert;
      final cardStorage = CardStorage();

// Если номер карты поменялся, Спрашиваем пользователя можно ли сохранить карту:
      if (_startCardNumber != cardNumber) {
        resultAlert = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Сохранить данные карты?'),
            content: Text(
                'Вы хотите сохранить данные карты? \nДанные хранятся в зашифрованном виде.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Нет'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Да'),
              ),
            ],
          ),
        );
      }
      if (resultAlert == true) {
        await cardStorage.saveCardDetails(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvvCode,
        );
      }

      try {
        // В зависимости от типа карты вызываем API для проведения платежа:
        if (cardNumber.startsWith('4') ||
            cardNumber.startsWith('51') ||
            cardNumber.startsWith('55')) {
          // Платёж через Payeer
          await _processPayeerPayment();
        } else if (cardNumber.startsWith('220')) {
          // Платёж через Enot.io
          await _processEnotPayment();
        } else {
          throw Exception('Карта не поддерживается');
        }
      } catch (e) {
        print('Ошибка проведения платежа: $e');
      }
    } else {
      print('Invalid!');
    }
  }

  Future<void> _processPayeerPayment() async {
    final url = Uri.parse('https://payeer-api-url.example/payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cardNumber': cardNumber.replaceAll(' ', ''),
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
        'amount': 1000, // Замените на фактическую сумму
        'currency': 'USD',
      }),
    );

    if (response.statusCode == 200) {
      print('Платёж через Payeer прошёл успешно');
    } else {
      throw Exception('Ошибка при платеже через Payeer');
    }
  }

  Future<void> _processEnotPayment() async {
    final url = Uri.parse('https://enot-api-url.example/payment');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cardNumber': cardNumber.replaceAll(' ', ''),
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
        'amount': 1000, // Замените на фактическую сумму
        'currency': 'RUB',
      }),
    );

    if (response.statusCode == 200) {
      print('Платёж через Enot.io прошёл успешно');
    } else {
      throw Exception('Ошибка при платеже через Enot.io');
    }
  }

  Glassmorphism _getGlassmorphismConfig() {
    return Glassmorphism(
      blurX: useGlassMorphism ? 8.0 : 0.0,
      blurY: useGlassMorphism ? 16.0 : 0.0,
      gradient: useGlassMorphism
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white.withValues(), Colors.white.withValues()],
              stops: const [0.3, 1.0],
            )
          : const LinearGradient(
              colors: [Colors.transparent, Colors.transparent],
            ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
