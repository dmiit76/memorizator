import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class AdManager {
  late BannerAd _bannerAd;
  bool isBannerAdReady = false;
  late InterstitialAd? _interstitialAd;
  bool isInterstitialAdReady = false;

  // Метод для загрузки баннера
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? AdMobConstants.memorizatorBannerAd
          : AdMobConstants.memorizatorBannerAdiOS, // баннер
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady = true;
        },
        onAdFailedToLoad: (ad, error) {
          //print('Ошибка загрузки баннера: $error');
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  // Возвращаем баннер для показа в UI
  BannerAd get bannerAd => _bannerAd;

  void disposeBannerAd() {
    _bannerAd.dispose();
  }

  // Межстраничная реклама
  bool _isInterstitialAdLoaded = false;

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? AdMobConstants.memorizatorBannerAdPage
          : AdMobConstants.memorizatorBannerAdPageiOS, // межстраничный
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialAdLoaded = true;
          //print('Межстраничная реклама загружена.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          //print('Ошибка загрузки межстраничной рекламы: $error');
          _isInterstitialAdLoaded = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    if (_isInterstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isInterstitialAdLoaded = false;
      loadInterstitialAd(); // Загружаем следующую рекламу после показа
    } else {
      //print('Межстраничная реклама ещё не загружена.');
    }
  }

  void disposeInterstitialAd() {
    _interstitialAd?.dispose();
  }
}

class BannerAdWidget extends StatelessWidget {
  final Future<BannerAd> _bannerAdFuture = Future(() {
    final BannerAd bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? AdMobConstants.memorizatorBannerAd
          : AdMobConstants.memorizatorBannerAdiOS, // Баннер
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          //print('Тестовый баннер загружен');
        },
        onAdFailedToLoad: (ad, error) {
          //print('Ошибка загрузки баннера: $error');
          ad.dispose();
        },
      ),
    );
    bannerAd.load();
    return bannerAd;
  });

  BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    // если пользователь купил любой донат, не показываем рекламу!
    if (purchaseProvider.isPaidUser) {
      // Пользователь уже совершил пожертвование, поэтому выходим и не показываем баннер
      return const SizedBox.shrink(); // Возвращаем пустой виджет
    }
    return FutureBuilder<BannerAd>(
      future: _bannerAdFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final BannerAd bannerAd = snapshot.data!;
          return SizedBox(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
        } else if (snapshot.hasError) {
          return const Text('loader error...');
        } else {
          return const CircularProgressIndicator(); // Пока загружается, показываем индикатор
        }
      },
    );
  }
}

class BannerAdWidgetAdaptive extends StatelessWidget {
  const BannerAdWidgetAdaptive({super.key});

  @override
  Widget build(BuildContext context) {
    //print('Ширина пространства: ${MediaQuery.of(context).size.width.toInt()}');
    final purchaseProvider = Provider.of<PurchaseProvider>(context);
    // если пользователь купил любой донат, не показываем рекламу!
    if (purchaseProvider.isPaidUser) {
      // Пользователь уже совершил пожертвование, поэтому выходим и не показываем баннер
      return const SizedBox.shrink(); // Возвращаем пустой виджет
    }
    // Используем FutureBuilder для получения адаптивного размера баннера

    return FutureBuilder<AnchoredAdaptiveBannerAdSize?>(
      future: AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.toInt() -
            ((MediaQuery.of(context).orientation == Orientation.portrait)
                ? 0
                : 33),
      ),
      builder: (context, adSizeSnapshot) {
        if (adSizeSnapshot.connectionState == ConnectionState.done &&
            adSizeSnapshot.hasData) {
          final AnchoredAdaptiveBannerAdSize? adSize = adSizeSnapshot.data;

          if (adSize == null) {
            return BannerAdWidget(); // если не можем получить размер экрана, выводим неадаптивный баннер
          }

          // После получения размера создаём баннер
          final BannerAd bannerAd = BannerAd(
            adUnitId: Platform.isAndroid
                ? AdMobConstants.memorizatorBannerAd
                : AdMobConstants.memorizatorBannerAdiOS, // баннер
            size: adSize,
            request: const AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (_) {
                //print('Адаптивный баннер загружен');
              },
              onAdFailedToLoad: (ad, error) {
                //print('Ошибка загрузки адаптивного банннера: $error');
                ad.dispose();
              },
            ),
          );

          bannerAd.load();

          // Показ баннера после загрузки
          return SizedBox(
            width: adSize.width.toDouble(),
            height: adSize.height.toDouble(),
            child: AdWidget(ad: bannerAd),
          );
        } else if (adSizeSnapshot.hasError) {
          return Text(
              'Ошибка получения размера баннера: ${adSizeSnapshot.error}');
        } else {
          return const CircularProgressIndicator(); // Пока загружается, показываем индикатор
        }
      },
    );
  }
}
