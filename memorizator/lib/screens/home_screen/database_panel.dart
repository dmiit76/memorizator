import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:memorizator/screens/home_screen/edit_record.dart';
import 'package:memorizator/screens/home_screen/home_screen.dart';
import 'package:memorizator/screens/home_screen/icons_record.dart';
import 'package:memorizator/screens/home_screen/memory_screen.dart';
import 'package:memorizator/services/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/calcrec.dart';

class DatabasePanel extends StatelessWidget {
  const DatabasePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final infoProvider = context.watch<InfoProvider>();
    //infoProvider.filterStringController.text = '';
    context.read<SettingsProvider>().checkAndCompactDatabase(context);
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: aBlue,
          //color: Colors.white,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
          //color: Colors.yellow,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  infoProvider.setFilter(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      color: aWhite,
                    ),
                    Text(
                      infoProvider.getFilteredItems(),
                      style: const TextStyle(color: aWhite),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Container(
                    width: (infoProvider.titleItems.length + 3) * 7.0,
                    height: 2,
                    color: aWhite),
              ),
              const ListOfRecords()
            ],
          ),
        ),
      ),
    );
  }
}

class ListOfRecords extends StatelessWidget {
  const ListOfRecords({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final infoProvider = context.read<InfoProvider>();
    // получаем Map со списком валют и выводим список цен

    return Expanded(
      child: FutureBuilder(
          future: settingsProvider.initSettings(),
          builder: (context, snapshot) {
            return ValueListenableBuilder(
                valueListenable: Hive.box<CalcRec>('calcrec').listenable(),
                builder: (context, snapshot, _) {
                  // Строим виджет на основе отфильтрованных элементов

                  if (infoProvider.filteredItems.isNotEmpty) {
                    return Consumer<InfoProvider>(
                      builder: (context, infoProvider, child) {
                        return ListView.builder(
                          itemCount: infoProvider.filteredItems.length,
                          itemBuilder: (context, originalIndex) {
                            final index =
                                (infoProvider.filteredItems.length - 1) -
                                    originalIndex;
                            final item = infoProvider.filteredItems[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: aLightGray,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: ValueListenableBuilder(
                                  valueListenable: refreshList,
                                  builder:
                                      (BuildContext context, double value, _) {
                                    return Column(
                                      children: [
                                        // Row(
                                        //   mainAxisAlignment:
                                        //       MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     Container(
                                        //       alignment: Alignment.topLeft,
                                        //       width: 75,
                                        //       child: Column(
                                        //         children: [
                                        //           Text(
                                        //             DateFormat('dd.MM.yyyy')
                                        //                 .format(item.date),
                                        //             style: const TextStyle(
                                        //                 fontSize: 12),
                                        //           ),
                                        //           Text(
                                        //             DateFormat('HH:mm')
                                        //                 .format(item.date),
                                        //             style: const TextStyle(
                                        //                 fontSize: 12),
                                        //           ),
                                        //           IconsRecord(item: item),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //     Flexible(
                                        //       fit: FlexFit.tight,
                                        //       child: GestureDetector(
                                        //         onTap: () {
                                        //           // Получаем экземпляр purchaseProvider до перехода
                                        //           final purchaseProvider =
                                        //               Provider.of<
                                        //                       PurchaseProvider>(
                                        //                   context,
                                        //                   listen: false);

                                        //           // Переходим на экран MemoryScreen
                                        //           Navigator.push(
                                        //             context,
                                        //             MaterialPageRoute<void>(
                                        //               builder: (BuildContext
                                        //                   context) {
                                        //                 // Загружаем межстраничную рекламу
                                        //                 purchaseProvider
                                        //                     .loadInterstitialAd();
                                        //                 return MemoryScreen(
                                        //                   snapshot: snapshot,
                                        //                   index: index,
                                        //                   list:
                                        //                       item.listPhotoPath ??
                                        //                           [],
                                        //                 );
                                        //               },
                                        //             ),
                                        //           ).then((_) {
                                        //             // Показываем межстраничную рекламу при возврате
                                        //             purchaseProvider
                                        //                 .showInterstitialAd();
                                        //           });
                                        //         },
                                        //         onLongPress: () {
                                        //           editRecord(
                                        //               context, infoProvider,
                                        //               snapshot: snapshot,
                                        //               i: index);
                                        //         },
                                        //         child: Container(
                                        //           color: aLightGray,
                                        //           child: Column(
                                        //             crossAxisAlignment:
                                        //                 CrossAxisAlignment
                                        //                     .start,
                                        //             children: [
                                        //               Text(
                                        //                 item.title,
                                        //                 style: TextStyle(
                                        //                   fontSize: settingsProvider
                                        //                       .setFontSizeProduct,
                                        //                   fontWeight:
                                        //                       FontWeight.bold,
                                        //                   color: aLightBlack,
                                        //                 ),
                                        //               ),
                                        //               Text(
                                        //                 infoProvider
                                        //                     .textWeight(item),
                                        //                 // infoProvider.textWeight(
                                        //                 //     snapshot, index),
                                        //                 style: const TextStyle(
                                        //                   fontSize: 12,
                                        //                   fontWeight:
                                        //                       FontWeight.bold,
                                        //                   color: aLightBlack,
                                        //                 ),
                                        //               ),
                                        //             ],
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ),
                                        //     Container(
                                        //       color: aLightGray,
                                        //       alignment: Alignment.centerRight,
                                        //       width: settingsProvider
                                        //           .setWidthColumn3,
                                        //       child: Column(
                                        //         crossAxisAlignment:
                                        //             CrossAxisAlignment.end,
                                        //         children: [
                                        //           Text(
                                        //             textAlign: TextAlign.right,
                                        //             '${item.codeName}: ${NumberFormat(settingsProvider.setPriceFormat).format(item.price)}',
                                        //           ),
                                        //           Text(
                                        //             textAlign: TextAlign.right,
                                        //             infoProvider
                                        //                 .stringConvertedItem(
                                        //                     item.rateMap, item),
                                        //           ),
                                        //         ],
                                        //       ),
                                        //     ),
                                        //   ],
                                        // ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              width: 75,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    DateFormat('dd.MM.yyyy')
                                                        .format(item.date),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  Text(
                                                    DateFormat('HH:mm')
                                                        .format(item.date),
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                  IconsRecord(item: item),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  final purchaseProvider =
                                                      Provider.of<
                                                              PurchaseProvider>(
                                                          context,
                                                          listen: false);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute<void>(
                                                      builder: (BuildContext
                                                          context) {
                                                        purchaseProvider
                                                            .loadInterstitialAd();
                                                        return MemoryScreen(
                                                          snapshot: snapshot,
                                                          index: index,
                                                          list:
                                                              item.listPhotoPath ??
                                                                  [],
                                                        );
                                                      },
                                                    ),
                                                  ).then((_) {
                                                    purchaseProvider
                                                        .showInterstitialAd();
                                                  });
                                                },
                                                onLongPress: () {
                                                  editRecord(
                                                      context, infoProvider,
                                                      snapshot: snapshot,
                                                      i: index);
                                                },
                                                child: Container(
                                                  color: aLightGray,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.title,
                                                        style: TextStyle(
                                                          fontSize: settingsProvider
                                                              .setFontSizeProduct,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: aLightBlack,
                                                        ),
                                                      ),
                                                      Text(
                                                        infoProvider
                                                            .textWeight(item),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: aLightBlack,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Flexible(
                                              fit: FlexFit.tight,
                                              child: Container(
                                                color: aLightGray,
                                                alignment:
                                                    Alignment.centerRight,
                                                width: settingsProvider
                                                    .setWidthColumn3,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      textAlign:
                                                          TextAlign.right,
                                                      '${item.codeName}: ${NumberFormat(settingsProvider.setPriceFormat).format(item.price)}',
                                                    ),
                                                    Text(
                                                      textAlign:
                                                          TextAlign.right,
                                                      infoProvider
                                                          .stringConvertedItem(
                                                              item.rateMap,
                                                              item),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Visibility(
                                          visible: (item.latitude +
                                                  item.longitude) !=
                                              0,
                                          child: Text(
                                            item.place,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal,
                                              color: aLightBlack,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text(
                        S.of(context).noRecords,
                        style: const TextStyle(color: aWhite),
                      ),
                    );
                  }
                });
          }),
    );
  }
}
