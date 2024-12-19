import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class PurchaseNoGoogle extends StatefulWidget {
  const PurchaseNoGoogle({super.key});

  @override
  State<PurchaseNoGoogle> createState() => _PurchaseNoGoogleState();
}

class _PurchaseNoGoogleState extends State<PurchaseNoGoogle> {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      isLightTheme ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
    );
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
                    } else if (cardNumber.length != 16) {
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

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('Valid!');
    } else {
      print('Invalid!');
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
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.5)
              ],
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
