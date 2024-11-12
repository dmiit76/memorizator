import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/models/calcrec.dart';

import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/providers/photofile_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:provider/provider.dart';

Future<dynamic> editRecord(BuildContext context, InfoProvider infoProvider,
    {snapshot, int? i}) async {
  // если получен индекс записи - показываем кнопку Delete и разрешаем удаление
  // и присваиваем текстконтроллерам начальные значения из текущего snapshot
  // иначе - заполняем значениями для новой записи в базу

  bool newRecord = false;
  final settingsProvider = context.read<SettingsProvider>();
  final photoProvider = context.read<PhotofileProvider>();
  final infoProvider = context.read<InfoProvider>();
  final myMap = <String, double>{};
  myMap[settingsProvider.codeMyCurrency] =
      infoProvider.priceController2.text.isEmpty
          ? 0
          : double.parse(infoProvider.priceController2.text);
  infoProvider.getCurrentLocation();
  CalcRec item;
  if (snapshot == null || i == null) {
    item = CalcRec(
        DateTime.now(),
        context.read<InfoProvider>().titleController.text,
        double.tryParse(infoProvider.priceController.text) ?? 0.0,
        0.0, // rating
        infoProvider.noteController.text, // comment
        int.tryParse(infoProvider.weightController.text) ?? 0,
        codeName: settingsProvider.codeLocalCurrency,
        listPhotoPath: photoProvider.listPhotoFiles,
        barcode: photoProvider.barcodeResult,
        latitude: infoProvider.latitude,
        longitude: infoProvider.longitude,
        rateMap: myMap);
  } else {
    item = snapshot.getAt(i);
  }

  if (i != null) {
    infoProvider.titleController.text = item.title;
    infoProvider.noteController.text = item.comment;
    infoProvider.weightController.text = item.weight.toString();
  } else {
    infoProvider.titleController.text = '';
    infoProvider.noteController.text = '';
    infoProvider.weightController.text = '1000';
    newRecord = true;
  }
  infoProvider.getCurrentLocation();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).savePrice, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoTextField(
                  controller: infoProvider.titleController,
                  // autofocus: true,
                  placeholder: S.of(context).enterProductName,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                  controller: infoProvider.weightController,
                  prefix: Text(S.of(context).weightG),
                  //suffix: const Text('g.'),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: false),
                  clearButtonMode: OverlayVisibilityMode.always,
                  autofocus: false,
                  placeholder: S.of(context).enterProductWeight,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${S.of(context).price}: ${item.codeName}: ${NumberFormat(settingsProvider.setPriceFormat).format(item.price)}',
                  //'${item.codeName}: ${NumberFormat(settingsProvider.setPriceFormat).format(item.price)}',
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: infoProvider
                      .stringConvertedItem(item.rateMap, item)
                      .isNotEmpty,
                  child: Text(
                    '${S.of(context).currency}: ${infoProvider.stringConvertedItem(item.rateMap, item)}',
                    //infoProvider.stringConvertedItem(item.rateMap, item),

                    textAlign: TextAlign.left,
                  ),
                ),
                CupertinoTextField(
                  // Примечание
                  controller: infoProvider.noteController,
                  // autofocus: true,
                  placeholder: S.of(context).note,
                  clearButtonMode: OverlayVisibilityMode.always,
                  minLines: 1,
                  maxLines: 5,
                  maxLength: 100,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                infoProvider.noteController.text = '';
                Navigator.pop(context);
              },
              child: Text(S.of(context).cancel),
            ),
            Visibility(
              visible: i == null ? false : true,
              child: TextButton(
                onPressed: () {
                  infoProvider.deleteCalcRec(i!);
                  Navigator.pop(context);
                },
                child: Text(S.of(context).deleteButton,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),
            FilledButton(
              onPressed: () {
                if (infoProvider.titleController.text.isNotEmpty) {
                  if (newRecord) {
                    infoProvider.addCalcRec();
                    if (settingsProvider.setClearResult) {
                      infoProvider.titleController.text = '';
                      photoProvider.listPhotoFiles = [];
                      photoProvider.barcodeResult = '';
                    }
                  } else {
                    infoProvider.editCalcRec(i!);
                  }
                  Navigator.pop(context, true);
                }
              },
              child: Text(S.of(context).save),
            ),
          ],
        );
      });
}
