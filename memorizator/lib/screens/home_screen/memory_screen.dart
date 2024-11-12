import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/providers/photofile_provider.dart';
import 'package:memorizator/providers/purchase_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:memorizator/screens/home_screen/view_foto.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
import 'package:memorizator/services/constants.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class MemoryScreen extends StatelessWidget {
  final dynamic snapshot;
  final int index;
  final List list;
  const MemoryScreen(
      {required this.snapshot,
      required this.index,
      required this.list,
      super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final photofileProvider = context.read<PhotofileProvider>();
    CalcRec item = snapshot.getAt(index);
    final list = item.listPhotoPath ?? [];
    final latitude = item.latitude ?? 0;
    final longitude = item.longitude ?? 0;
    // Получаем AdManager через провайдер
    final adManager = Provider.of<PurchaseProvider>(context, listen: false);
    // Загружаем рекламу
    adManager.loadInterstitialAd(); // Загружаем межстраничную рекламу

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: aBlue,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          S.of(context).memorizedPricesTitle,
          style: const TextStyle(color: aBlue),
        ),
      ),
      backgroundColor: aLightBlue,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              // Дата время, поделиться
              Container(
                margin: const EdgeInsets.all(8),
                height: 50,
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: aBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${S.of(context).date} ${DateFormat('dd.MM.yyyy HH:mm').format(snapshot.getAt(index)?.date ?? DateTime.now())}',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        onShareButtonPressed(context, settingsProvider, item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: aBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 0),
                          width: 48,
                          //height: 50,
                          //alignment: Alignment.,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.share,
                            color: aWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  padding: const EdgeInsetsDirectional.all(8),
                  //height: 100,
                  width: double.infinity,
                  color: Colors.white,
                  child: buildColumnFromMap(
                      context, snapshot.getAt(index), settingsProvider)),
              Visibility(
                visible: list.isNotEmpty,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
                  height: 150,
                  color: aWhite,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        //key: UniqueKey(),
                        // Просмотр фотографии:
                        onTap: () async {
                          photofileProvider.setItem = index;
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return ViewFoto(list[i], false);
                              },
                            ),
                          );
                        },

                        onLongPress: () {},
                        child: Container(
                          key: UniqueKey(),
                          margin: const EdgeInsets.only(right: 5),
                          //height: 60,
                          //width: 60,
                          color: aLightBlack,
                          child: Image(
                            image: FileImage(
                              File(list[i]),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                //visible: item.place!.isNotEmpty,
                visible: item.latitude! + item.longitude! != 0,
                child: Column(
                  children: [
                    FittedBox(
                      child: Text(
                        '${item.place}',
                        style:
                            const TextStyle(color: aLightBlack, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: item.latitude! + item.longitude! != 0,
                child: Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    margin: EdgeInsets.only(
                        bottom: 8,
                        left: 8,
                        right: 8,
                        top: (item.latitude! + item.longitude! != 0) ? 0 : 8),
                    height: 150,
                    color: aWhite,
                    width: double.infinity,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter:
                            LatLng(latitude, longitude), // Координаты Москвы
                        //LatLng(55.751244, 37.618423), // Координаты Москвы
                        initialZoom: 16.0, // Масштаб карты
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'info.memorizator',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(latitude,
                                  longitude), // Координаты для маркера
                              child: const Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const BannerAdWidgetAdaptive(), // Показываем баннер
              //Container()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumnFromMap(context, CalcRec item, settingsProvider) {
    //final settingsProvider = Provider.of<SettingsProvider>(context);
    // ignore: prefer_interpolation_to_compose_strings
    final String nameOfProduct = item.title +
        (item.latitude! + item.longitude! == 0
            ? ''
            : ' (${item.weight.toString()}${S.of(context).g_sentence})');
    final String product = '${S.of(context).product}: $nameOfProduct';
    final Map map = item.rateMap!;
    const textstyle1 =
        TextStyle(fontSize: 24, color: aBlue, fontWeight: FontWeight.bold);
    List<Widget> rows = [];

    for (var entry in map.entries) {
      if (entry.key == item.codeName || entry.value == item.price) {
        continue;
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            child: Text(
              '${entry.key}:',
              textAlign: TextAlign.start,
              style: textstyle1,
            ),
          ),
          SizedBox(
            child: Text(
              NumberFormat(settingsProvider.setPriceFormat).format(entry.value),
              textAlign: TextAlign.end,
              style: textstyle1,
            ),
          ),
        ],
      ));
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Text(
            product,
            textAlign: TextAlign.start,
            style: textstyle1,
          ),
        ),
        Visibility(
          visible: item.barcode!.isNotEmpty,
          child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              '${S.of(context).barcodeButton}: ${item.barcode}',
              textAlign: TextAlign.start,
              style: textstyle1,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Text(
                '${S.of(context).price} (${item.codeName}):',
                textAlign: TextAlign.start,
                style: textstyle1,
              ),
            ),
            SizedBox(
              child: Text(
                NumberFormat(settingsProvider.setPriceFormat)
                    .format(item.price),
                textAlign: TextAlign.end,
                style: textstyle1,
              ),
            ),
          ],
        ),
        ...rows,
        Visibility(
          visible: item.comment.isNotEmpty,
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              '${S.of(context).note} ${item.comment}',
              textAlign: TextAlign.left,
              style: const TextStyle(color: aBlue),
            ),
          ),
        )
      ],
    );
  }

  void onShareButtonPressed(
      BuildContext context, SettingsProvider settingsProvider, CalcRec item) {
    // формируем сообщение для шары
    String location = '';
    final list = item.listPhotoPath ?? [];
    List<XFile> filesToShare = list.map((path) => XFile(path)).toList();

    final latitude = item.latitude ?? 0;
    final longitude = item.longitude ?? 0;
    if (latitude + longitude != 0) {
      location = 'Location: https://maps.google.com/?q=$latitude,$longitude';
    }

    // Формируем сообщение для share
    String message =
        '${S.of(context).aGreatProductHasBeenFound} ${item.title} ${S.of(context).byPrice} ${NumberFormat(settingsProvider.setPriceFormat).format(item.price)} ${item.codeName}. $location';

    if (filesToShare.isNotEmpty) {
      Share.shareXFiles(filesToShare, text: message);
    } else {
      Share.share(message);
    }
  }

  bool areDatesEqualByDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
