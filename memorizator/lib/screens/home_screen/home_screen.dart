import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/providers/toppanel_provider.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';
import 'control_panel.dart';
import 'database_panel.dart';
import 'info_panel.dart';
import 'top_panel.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';

final ValueNotifier<double> refreshList = ValueNotifier(0);
final ValueNotifier<double> fontSize = ValueNotifier(16.0);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeApp();
  }

  Future<void> _initializeApp() async {
    await MobileAds.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка загрузки: ${snapshot.error}'));
        }

        // Основной интерфейс после загрузки
        return Scaffold(
          backgroundColor: aLightBlue,
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const TopPanel(),
                  Visibility(
                    visible: !context.watch<TopPanelProvider>().recordMode,
                    child: const Column(
                      children: [
                        InfoPanel(),
                        ControlPanel(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  const DatabasePanel(),
                  Visibility(
                    visible: !context.read<PurchaseProvider>().isPaidUser,
                    child: const BannerAdWidgetAdaptive(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
