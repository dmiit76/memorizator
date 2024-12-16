import 'package:flutter/material.dart';

const Color aBlue = Color(0xff4664FF);
const Color aLightBlue = Color.fromARGB(255, 157, 224, 255);
// const Color aGray = Color(0xff9F9F9F);
// const Color aLightGray = Color.fromARGB(255, 224, 224, 224);
// const Color aWhite = Colors.white;
// const Color aLightBlack = Color.fromARGB(150, 0, 0, 0);
//const Color aViolet = Color(0xff788DFF);
//const Color aPink = Color.fromARGB(255, 255, 0, 247);
//IconData aa = Icons.menu;

//const Color aBlue = Color.fromARGB(255, 157, 0, 110);
//const Color aLightBlue = Color.fromARGB(255, 249, 196, 237);

//const Color aBlue = Color.fromARGB(255, 255, 0, 0);
//const Color aLightBlue = Color.fromARGB(255, 251, 215, 215);

const Color aGray = Color(0xff9F9F9F);
const Color aLightGray = Color.fromARGB(255, 224, 224, 224);
const Color aWhite = Colors.white;
const Color aLightBlack = Color.fromARGB(150, 0, 0, 0);
const myButtonStyle = ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(aWhite),
  shadowColor: WidgetStatePropertyAll(aGray),
  elevation: WidgetStatePropertyAll(20),
  padding: WidgetStatePropertyAll(EdgeInsets.all(10)),
);

enum DonationStatus {
  none,
  donate_1,
  donate_2,
  donate_5,
  donate_10,
}

// Рабочие настройки:
//Memorizator - ID приложения
//ca-app-pub-7889852441350586~7754231542
//MemorizatorBannerAd - баннер
//ca-app-pub-7889852441350586/1610790758
//MemorizatorBannerAdPage - межстраничная реклама
//ca-app-pub-7889852441350586/3551392536

// Тестовые настройки:
//Тестовый ID приложения (для AndroidManifest)
//ca-app-pub-3940256099942544~3347511713
//Тестовый ID баннера
//ca-app-pub-3940256099942544/6300978111, // Тестовый ID
//Тестовый ID межстраничного показа
//ca-app-pub-3940256099942544/1033173712, // Тестовый ID
// class AdMobConstants {
//   static const String memorizatorAdMobID =
//       'ca-app-pub-3940256099942544~3347511713';
//   static const String memorizatorBannerAd =
//       'ca-app-pub-3940256099942544/6300978111';
//   static const String memorizatorBannerAdPage =
//       'ca-app-pub-3940256099942544/1033173712';
//   static const String memorizatorAdMobIDiOS =
//       'ca-app-pub-3940256099942544~1458002511';
//   static const String memorizatorBannerAdiOS =
//       'ca-app-pub-3940256099942544/2934735716';
//   static const String memorizatorBannerAdPageiOS =
//       'ca-app-pub-3940256099942544/4411468910';

  // Добавь другие идентификаторы по необходимости
// }
