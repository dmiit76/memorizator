import 'package:flutter/material.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/toppanel_provider.dart';
import 'package:memorizator/screens/settings_screen/setting_screen.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class TopPanel extends StatelessWidget {
  const TopPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final contextProvider = context.read<TopPanelProvider>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              height: 38,
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (contextProvider.recordMode) {
                          context.read<TopPanelProvider>().switchMode();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.read<TopPanelProvider>().recordMode
                              ? Colors.white
                              : aBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            S.of(context).currentEntry,
                            style: TextStyle(
                              fontSize: 14,
                              color: contextProvider.recordMode
                                  ? aGray
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!contextProvider.recordMode) {
                          context.read<TopPanelProvider>().switchMode();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: context.watch<TopPanelProvider>().recordMode
                                ? aBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                          child: Text(
                            S.of(context).records,
                            style: TextStyle(
                              fontSize: 14,
                              color: context.read<TopPanelProvider>().recordMode
                                  ? Colors.white
                                  : aGray,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return const SettingScreen();
                  },
                ),
              );
            },
            child: Container(
              height: 38,
              width: 56,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.only(left: 20),
              alignment: Alignment.center,
              //child: SvgPicture.asset('assets/img/asset_menu.svg'),
              child: const Icon(
                Icons.settings_outlined,
                size: 30,
                color: aBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
