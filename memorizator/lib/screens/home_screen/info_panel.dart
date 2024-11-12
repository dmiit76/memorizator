import 'package:flutter/material.dart';
import 'package:memorizator/generated/l10n.dart';

import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';

class InfoPanel extends StatelessWidget {
  const InfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final infoProvider = context.read<InfoProvider>();
    final settingProvider = context.read<SettingsProvider>();
    infoProvider.getCurrency();
    infoProvider.getPrice2Text();

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 5, right: 10),
      child: Column(
        children: [
          Row(
            children: [
              //const Icon(Icons.monetization_on, size: 40),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsetsDirectional.only(bottom: 20),
                width: 30,
                height: 80,
                //color: aLightBlack,
                child: RotatedBox(
                  quarterTurns:
                      1, // 1 = 90 градусов, 2 = 180 градусов, 3 = 270 градусов
                  child: Text(
                    textAlign: TextAlign.center,
                    'IN ${settingProvider.codeLocalCurrency}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: infoProvider.priceController,

                  onChanged: infoProvider.input1,
                  enableInteractiveSelection: false,
                  maxLength: 12,
                  maxLines: 1,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: false),
                  decoration: InputDecoration(
                      labelText: S.of(context).enterPrice,
                      border: const OutlineInputBorder(gapPadding: 2),
                      isCollapsed: false),
                  //autofocus: true,
                  cursorWidth: 4,
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    height: 0.0,
                    color: aLightBlack,
                  ),
                ),
              )
            ],
          ),
          FutureBuilder<bool>(
            future: context.watch<SettingsProvider>().isVisibleS(),
            //future: context.watch<InfoProvider>().isVisibleS(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Пока результат загружается, отображаем индикатор
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Если произошла ошибка, можно обработать её
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData && snapshot.data == true) {
                // Если результат true, отображаем виджет
                return Row(
                  children: [
                    //const Icon(Icons.monetization_on, size: 40),
                    Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsetsDirectional.only(bottom: 20),
                      width: 30,
                      height: 80,
                      //color: aLightBlack,
                      child: RotatedBox(
                        quarterTurns:
                            1, // 1 = 90 градусов, 2 = 180 градусов, 3 = 270 градусов
                        child: Text(
                          textAlign: TextAlign.end,
                          'TO ${settingProvider.codeMyCurrency}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Selector<SettingsProvider, String>(
                          selector: (context, settingsProvider) =>
                              settingsProvider.setCurrencyController,
                          builder: (context, setCurrencyController, child) {
                            final infoProv = Provider.of<InfoProvider>(context,
                                listen: false);
                            // Пересчитываем input1 при изменении someProperty
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              infoProv.input1(
                                  setCurrencyController); // вызываем пересчет при изменении someProperty
                            });

                            return TextField(
                              controller: Provider.of<InfoProvider>(context)
                                  .priceController2,
                              onChanged:
                                  Provider.of<InfoProvider>(context).input1,
                              enabled: false,
                              enableInteractiveSelection: false,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(gapPadding: 2),
                                  isCollapsed: false),
                              cursorWidth: 4,
                              style: const TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                                height: 0.0,
                                color: aLightBlack,
                              ),
                            );
                            //
                            //
                            //
                          }),
                    )
                  ],
                );
              } else {
                // Если результат false или данных нет, возвращаем пустой виджет
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
