import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/providers/photofile_provider.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:memorizator/providers/toppanel_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';
import 'services/constants.dart';
import 'firebase_options.dart';

void main() async {
  // Логгируем ошибки
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load(fileName: '.env'); // Загрузка .env файла
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

      // Initialize SharedPreferences
      await SharedPreferences.getInstance();
      await S.load(const Locale.fromSubtags(languageCode: 'en'));

      // Вернуть инициализацию базы данных Hive в main
      await Hive.initFlutter();
      Hive.registerAdapter(CalcRecAdapter());
      await Hive.openBox<CalcRec>(
          'calcrec'); // Убедись, что это завершено до создания InfoProvider

      runApp(const Memorizator());
    },
    (error, stackTrace) {
      // Логирование ошибок во внешние сервисы
    },
  );
}

class Memorizator extends StatelessWidget {
  const Memorizator({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(context),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => PurchaseProvider(context),
          //lazy: false,
        ),
        ChangeNotifierProvider(create: (context) => PhotofileProvider(context)),
        ChangeNotifierProvider(
          create: (context) => InfoProvider(context),
          //lazy: false,
        ),
        ChangeNotifierProvider(create: (context) => TopPanelProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return GlobalLoaderOverlay(
            child: MaterialApp(
              locale: settingsProvider
                  .currentLocale, // Используем текущую локаль из провайдера
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              home: const HomeScreen(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Gilroy',
                colorScheme: const ColorScheme(
                    brightness: Brightness.light,
                    primary: aBlue,
                    onPrimary: Colors.white,
                    secondary: aGray,
                    onSecondary: aLightGray,
                    error: Colors.red,
                    onError: Colors.red,
                    surface: Colors.white,
                    onSurface: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
