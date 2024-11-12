import 'dart:io';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:provider/provider.dart';

class PhotofileProvider extends ChangeNotifier {
  final BuildContext context;
  PhotofileProvider(this.context);

  String selectedImagePath = '';
  List<String> listPhotoFiles = [];
  int setItem = 0;
  String barcodeResult = '';

  selectImageFromGallery() async {
    List<XFile>? files = await ImagePicker().pickMultiImage(imageQuality: 10);
    if (files.isNotEmpty) {
      for (var element in files) {
        // если такого файла нет в списке, то добавляем
        if (!listPhotoFiles.contains(element.path)) {
          listPhotoFiles.add(element.path);
        }
      }
    }
    notifyListeners();
  }

  //
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      listPhotoFiles.add(file.path.toString());
    }
    notifyListeners();
  }

// Проверяем наличие файла
// Копируем файл в директорию программы
// Проверяем наличие файла
// Записываем в List новый путь
  void copyListPhotoFiles() {
    // Читаем путь хранения фотографий из настроек
    final path = context.read<SettingsProvider>().pathForPhoto;

    for (int i = 0; i < listPhotoFiles.length; i++) {
      String newPathFile = path +
          Platform.pathSeparator +
          listPhotoFiles[i].split(Platform.pathSeparator).last;

      if (File(newPathFile).existsSync()) {
        File(newPathFile).deleteSync();
      }

      var fileFrom = listPhotoFiles[i];
      if (File(fileFrom).existsSync()) {
        try {
          File(fileFrom).copySync(newPathFile); // Используй copySync
          listPhotoFiles[i] = newPathFile;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${S.current.errorWhenCopying}: $e')),
          );
        }
      }
    }
  }

  // Future<void> existFile(String dir) async {
  //   bool result = await File(dir).exists();
  //   if (result) {
  //     //print('Файл есть: $dir');
  //   } else {
  //     //print('Фвйла НЕТУ! $dir');
  //     Directory(dir);
  //   }
  // }

  // existFileSync(String dir) {
  //   bool result = File(dir).existsSync();
  //   if (result) {
  //     //print('Файл есть: $dir');
  //     return true;
  //   } else {
  //     //print('Фвйла НЕТУ! $dir');
  //     return false;
  //   }
  // }

  void clearListPhotoFiles() {
    listPhotoFiles.clear();
  }

  void removeFoto() {
    listPhotoFiles.removeAt(setItem);
    notifyListeners();
  }

  void setElementOfList(int i) {
    setItem = i;
  }

  Future<void> scanBarcode(bool work) async {
    try {
      // Вызов сканера штрихкодов
      // if (work) {
      //   var result = await BarcodeScanner.scan();
      //   barcodeResult = result.rawContent; // Сохраняем результат
      // }
      var result = await BarcodeScanner.scan();
      barcodeResult = result.rawContent; // Сохраняем результат
      //barcodeResult = '1234567890';
    } catch (e) {
      barcodeResult = 'Error fun scanBarcode()';
    }
    notifyListeners();
  }
}
