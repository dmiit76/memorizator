import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
import 'package:memorizator/screens/settings_screen/instruction.dart';
import 'package:memorizator/screens/settings_screen/purchase_screen.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final currentLocale = settingsProvider.currentLocale;
    final supportedLocales = S.delegate.supportedLocales;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: aWhite,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
          ),
          onPressed: () async {
            await settingsProvider.controlCurrencyController(
              settingsProvider.currencyController.text,
            );

            if (mounted) {
              // Безопасный вызов Navigator.pop()
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              });
            }
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline, size: 36),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Instruction()));
            },
          ),
          const Text('  '),
        ],
        title: Text(
          S.of(context).settings,
          style: const TextStyle(color: aWhite),
        ),
        backgroundColor: aBlue,
      ),
      backgroundColor: aLightBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Выбор языка приложения

            ListTile(
              title: Center(
                child: Text(
                  S.of(context).selectALanguage,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
              trailing: Container(
                height: 40,
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Цвет тени
                      spreadRadius: 3, // Радиус распространения
                      blurRadius: 5, // Размытие
                      offset: const Offset(3, 13), // Смещение тени (по x и y)
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.43,
                child: DropdownButton<String>(
                  value: currentLocale.languageCode, // Текущая локаль
                  borderRadius: BorderRadius.circular(10),
                  style: const TextStyle(
                    color: aBlue,
                    fontSize: 16,
                    backgroundColor: aWhite,
                  ),
                  underline:
                      const SizedBox(), // Убираем темную полосу под выпадающим списком
                  isExpanded: true, // Расширяем, чтобы не было артефактов
                  items: supportedLocales.map((Locale locale) {
                    return DropdownMenuItem<String>(
                      value: locale.languageCode, // Присваиваем код локали
                      child: Center(
                        child: Text(
                          settingsProvider.getLocaleName(locale),
                          style: TextStyle(
                              color: locale.languageCode ==
                                      currentLocale.languageCode
                                  ? aBlue
                                  : aLightBlack,
                              fontWeight: locale.languageCode ==
                                      currentLocale.languageCode
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: locale.languageCode ==
                                      currentLocale.languageCode
                                  ? 16
                                  : 14), // Название локали
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      settingsProvider
                          .changeLocale(newValue); // Изменение локали
                      // SharedPreferences.getInstance().then((prefs) {
                      //   prefs.setString('languageCode', newValue);
                      // }
                      // );
                    }
                  },
                ),
              ),
            ),

            Container(
                margin: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 2,
                color: aBlue),
            ListTile(
              title: Text(
                S.of(context).localCurrencyPicker,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).selectTheCurrencyOfTheCountryYouAreIn,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  style: myButtonStyle,
                  onPressed: () {
                    settingsProvider.chooseCurrency(
                      context,
                      settingsProvider.codeLocalCurrency,
                      (selectedCode) {
                        settingsProvider.codeLocalCurrency =
                            selectedCode; // Сохраняем результат выбора в codeLocalCurrency
                        settingsProvider.inputLocalCurrency(selectedCode);
                      },
                    );
                  },
                  child: Text(
                    settingsProvider
                            .getCurrencyByCode(
                                settingsProvider.codeLocalCurrency)
                            ?.flag ??
                        S.of(context).noSet,
                  ),
                ),
              ),
            ),

            ListTile(
              title: Text(
                S.of(context).theCurrencyOfMyCountry,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).selectTheCurrencyYouWantToConvertTo,
                ),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  style: myButtonStyle,
                  onPressed: () {
                    settingsProvider.chooseCurrency(
                      context,
                      settingsProvider.codeMyCurrency,
                      (selectedCode) {
                        settingsProvider.codeMyCurrency =
                            selectedCode; // Сохраняем результат выбора в codeLocalCurrency
                        settingsProvider.inputMyCurrency(selectedCode);
                      },
                    );
                  },
                  child: Text(
                    settingsProvider
                            .getCurrencyByCode(settingsProvider.codeMyCurrency)
                            ?.flag ??
                        S.of(context).noSet,
                  ),
                ),
              ),
            ),

            ListTile(
              title: Text(
                S.of(context).localCurrencyRate,
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: FittedBox(
                alignment: Alignment.centerLeft,
                child: Text(
                  S.of(context).theValueOfYourMoneyInLocalCurrency,
                ),
              ),
              trailing: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: settingsProvider.currencyController,

                  onChanged: settingsProvider.inputCurrencyController,
                  // onSubmitted: funOnSubmitted,
                  // onEditingComplete: funOnEditComplete,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,9}'))
                  ],
                  //onSubmitted: (){},
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: false),
                ),
              ),
            ),

            Visibility(
              visible: settingsProvider.codeLocalCurrency !=
                  settingsProvider.codeMyCurrency,
              child: ListTile(
                contentPadding: const EdgeInsets.all(20),
                title: Text(
                  S.of(context).tryToGetTheExchangeRate,
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                      style: myButtonStyle,
                      onPressed: settingsProvider.getExchangeRate,
                      child: const Icon(Icons.download)),
                ),
                //onTap: () {},
              ),
            ),
            Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 2,
                color: aBlue),
            const BannerAdWidgetAdaptive(), // Показываем баннер
            Visibility(
              visible: !context.read<PurchaseProvider>().isPaidUser,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                title: Text(
                  S.of(context).supportTheApplicationTurnOffTheAds,
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: ElevatedButton(
                      style: myButtonStyle,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PurchaseScreen()),
                        );
                      },
                      child: const Icon(Icons.shopping_cart_outlined)),
                ),
                //onTap: () {},
              ),
            ),

            Container(
                margin: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 2,
                color: aBlue),

            ListTile(
              title: Text(
                S.of(context).learTheResultAfterSaving,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: CupertinoSwitch(
                onLabelColor: aWhite,
                thumbColor: aBlue,
                activeColor: aWhite,
                value: (settingsProvider.setClearResult ? true : false),
                onChanged: (bool value) {
                  settingsProvider.setClearResult = value;
                  settingsProvider.inputClearResult(value);
                },
              ),
              onTap: () {
                settingsProvider.setClearResult =
                    !settingsProvider.setClearResult;
                settingsProvider
                    .inputClearResult(settingsProvider.setClearResult);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: Text(
                S.of(context).displayPriceDigitsInTheList,
                style: const TextStyle(fontSize: 18),
              ),
              trailing: CupertinoSwitch(
                onLabelColor: aWhite,
                thumbColor: aBlue,
                activeColor: aWhite,
                value: settingsProvider.setFrameDigit,
                onChanged: (bool value) {
                  settingsProvider.setFrameDigit = value;
                  settingsProvider.inputFrameDigit(value);
                },
              ),
              onTap: () {
                settingsProvider.setFrameDigit =
                    !settingsProvider.setFrameDigit;
                settingsProvider
                    .inputFrameDigit(settingsProvider.setFrameDigit);
              },
            ),

            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).widthOfTheColumnWithPricesInTheListOf,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${settingsProvider.setWidthColumn3.truncate()}',
                      style: const TextStyle(fontSize: 28, color: aBlue),
                    ),
                  ),
                  Slider(
                    value: settingsProvider.setWidthColumn3,
                    divisions: 10,
                    min: 100.0,
                    max: 150.0,
                    activeColor: aLightBlack,
                    thumbColor: aBlue,
                    onChanged: (double value) {
                      settingsProvider.setWidthColumn3 = value;
                      settingsProvider.inputWidthColumn3(value);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      S.of(context).productNameFontSize,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '${settingsProvider.setFontSizeProduct.truncate()}',
                      style: const TextStyle(fontSize: 28, color: aBlue),
                    ),
                  ),
                  Slider(
                    value: settingsProvider.setFontSizeProduct,
                    divisions: 16,
                    min: 10.0,
                    max: 26.0,
                    activeColor: aLightBlack,
                    thumbColor: aBlue,
                    onChanged: (double value) {
                      //context.findAncestorStateOfType<ListOfRecordsState>());
                      settingsProvider.setFontSizeProduct = value;
                      settingsProvider.inputFontSizeProduct(value);
                    },
                  ),
                  // ListView(
                  //   children: asyncOperationLogs.entries.map((entry) {
                  //     return ListTile(
                  //       title: Text(
                  //         "${entry.key.toLocal()}: ${entry.value}",
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
            ),
            FutureBuilder(
              future: settingsProvider.pathPhoto(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                        '${S.of(context).thisAppsGallery}: \n${settingsProvider.pathForPhoto}'),
                  ),
                );
              },
            ),

            FutureBuilder(
              future: settingsProvider.getPackageInfo(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FittedBox(
                    child: Text(
                      'Version app: ${settingsProvider.packageInfo.version} (+${settingsProvider.packageInfo.buildNumber})',
                    ),
                  ),
                );
              },
            ),
            Text('userEmail: ${settingsProvider.userEmail}'),

            Visibility(
                visible: (settingsProvider.googleUser != null),
                child: Text(
                    'userID: ${(settingsProvider.googleUser == null ? '' : settingsProvider.googleUser!.id)}')),
          ],
        ),
      ),
    );
  }
}
