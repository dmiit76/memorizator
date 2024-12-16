import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/providers/photofile_provider.dart';
import 'package:memorizator/providers/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

class InfoProvider extends ChangeNotifier {
  final BuildContext context;

  TextEditingController priceController = TextEditingController(text: '');
  TextEditingController priceController2 = TextEditingController(text: '');
  TextEditingController titleController = TextEditingController(text: '');
  TextEditingController weightController = TextEditingController(text: '1000');
  TextEditingController noteController = TextEditingController(text: '');
  String _oldText = "";
  String priceText = "";
  double currency = 1;
  double latitude = 0.0;
  double longitude = 0.0;
  String place = '';
  String barcode = '';
  TextEditingController filterStringController =
      TextEditingController(text: '');
  bool filterOn = false;
  String titleItems = '';
  // Получаем все элементы из Hive
  var allItems = Hive.box<CalcRec>('calcrec').values.toList();
  var filteredItems = [];

  InfoProvider(this.context) {
    getCurrency();
    getPriceText();
    //getFilteredItems();
  }

  void setPlace(value) {
    place = value;
    notifyListeners();
  }

  // Получаем сохраненный курс
  Future getCurrency() async {
    //titleItems = 'last_records';
    //print('currency before = $currency');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getDouble('currency') ?? 2;
    //print('currency after = $currency');

    notifyListeners();
  }

  String textWeight(item) {
    String result = item.weight.toString();
    if (double.tryParse(result) != 0) {
      result = '($result g.)';
    } else {
      result = '';
    }
    return result;
  }

  String stringConvertedItem(map, item) {
    final settingsProvider = context.read<SettingsProvider>();
    String result = '';
    for (var element in map.entries) {
      if (item.codeName != element.key || item.price != element.value) {
        String aa =
            NumberFormat(settingsProvider.setPriceFormat).format(element.value);
        result = '${element.key}: $aa\n';
      }
    }
    return result;
  }

  Future<void> input1(stringtext) async {
    double? tempCounter = double.tryParse(priceController.text);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (tempCounter == null) {
      if (priceController.text.isEmpty) {
        priceController2.text = '';
        _oldText = '';
      } else {
        priceController.text = _oldText;
      }
    } else {
      // // Здесь расчитываем по курсу
      calculate(tempCounter); // double
      _oldText = priceController.text;
    }

    prefs.setString('text', priceController.text);
    notifyListeners();
  }

  // Расчитываем по курсу
  void calculate(double tempCounter) {
    if (currency == 0) {
      priceController2.text = ((0).roundToDouble()).toString();
    } else {
      priceController2.text =
          //(((tempCounter * 1 / currency)).roundToDouble()).toString();
          (((tempCounter * 100 / currency)).roundToDouble() / 100).toString();
    }
  }

  getPrice2Text() {
    return priceController2.text;
  }

  getPrice1Text() {
    return priceController.text;
  }

  Future getPriceText() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('text')) {
      priceText = prefs.getString('text') ?? '';
      notifyListeners();
    } else {
      priceText = '';
    }
    priceController.text = priceText;

    if (priceText == '') {
      calculate(0);
    } else {
      calculate(double.parse(priceText));
    }
    return priceText;
  }

  Future setPriceText(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('text', value);
  }

  void addCalcRec() {
    final settingsFileProvider = context.read<SettingsProvider>();

    final photoFileProvider =
        Provider.of<PhotofileProvider>(context, listen: false);
    photoFileProvider.copyListPhotoFiles();
    final myMap = <String, double>{};
    myMap[settingsFileProvider.codeMyCurrency] =
        priceController2.text.isEmpty ? 0 : double.parse(priceController2.text);
    getCurrentLocation();

    final currentCalcRec = CalcRec(
        DateTime.now(),
        titleController.text,
        double.tryParse(priceController.text) ?? 0.0,
        0.0, // rating
        noteController.text, // comment
        int.tryParse(weightController.text) ?? 0,
        '', // customName
        codeName: settingsFileProvider.codeLocalCurrency,
        listPhotoPath: photoFileProvider.listPhotoFiles,
        barcode: photoFileProvider.barcodeResult,
        latitude: latitude,
        longitude: longitude,
        place: place,
        rateMap: myMap);
    if (Hive.isBoxOpen('calcrec')) {
      Hive.box<CalcRec>('calcrec').add(currentCalcRec);
      allItems = Hive.box<CalcRec>('calcrec').values.toList();
      getFilteredItems();
    } else {
      throw Error();
    }
    latitude = 0.0;
    longitude = 0.0;
    getReset().then((reset) {
      if (reset == true) {
        // если в настройках установленно сбрасывать цену
        titleController.text = '';
        noteController.text = '';
        setPriceText('');
        priceController.text = '';
        priceController2.text = '0.0';
        weightController.text = '1000';
        barcode = '';
        photoFileProvider.clearListPhotoFiles();
      }
    });

    notifyListeners();
  }

  Future getReset() async {
    bool reset = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    reset = prefs.getBool('clearresult') ?? true;
    notifyListeners();
    return reset;
  }

  void editCalcRec(int index) {
    // при редактировании пользователь может изменить лишь title, comment и weight,
    // поэтому сохраняем только их
    final CalcRec currentCalcRec;
    currentCalcRec = Hive.box<CalcRec>('calcrec').getAt(index)!;
    currentCalcRec.title = titleController.text;
    currentCalcRec.comment = noteController.text;
    currentCalcRec.weight = int.parse(weightController.text);
    if (Hive.isBoxOpen('calcrec')) {
      Hive.box<CalcRec>('calcrec').putAt(index, currentCalcRec);
    } else {
      throw Error();
    }

    notifyListeners();
  }

  void refreshCalcRec(int index) {
    // при редактировании пользователь может изменить лишь title и weight,
    // поэтому сохраняем только их
    final CalcRec currentCalcRec;
    currentCalcRec = Hive.box<CalcRec>('calcrec').getAt(index)!;

    if (Hive.isBoxOpen('calcrec')) {
      Hive.box<CalcRec>('calcrec').putAt(index, currentCalcRec);
    } else {
      throw Error();
    }

    notifyListeners();
  }

  Future<void> deleteCalcRec(int index) async {
    await Hive.box<CalcRec>('calcrec')
        .deleteAt(index); // Ожидаем завершения удаления
    getFilteredItems(); // Обновляем список записей после удаления
    notifyListeners();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверяем, включена ли служба геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    // Проверяем наличие разрешений
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    // Разрешения на местоположение постоянно отклоняются, мы не можем запрашивать разрешения:
    if (permission == LocationPermission.deniedForever) {
      return;
    }

    // Если разрешения есть, получаем текущее местоположение
    // Получаем текущее местоположение с настройками
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high, // Высокая точность
          distanceFilter:
              10, // Обновлять данные, если перемещение больше 10 метров
          timeLimit: Duration(
              milliseconds: 30000), // Устанавливаем тайм-аут в 5 секунд
        ),
      );
      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      //print('Произошло исключение: $e');
    }

    // Получаем название места с помощью пакета geocoding
    getFullAddress(latitude, longitude);
  }

  Future<void> getFullAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placePoint = placemarks.first;
        // print('Название места: ${placePoint.name}');
        // print('Улица: ${placePoint.street}');
        // print('Код страны: ${placePoint.isoCountryCode}');
        // print('Страна: ${placePoint.country}');
        // print('Почтовый индекс: ${placePoint.postalCode}');
        // print('Административная область: ${placePoint.administrativeArea}');
        // print(
        //     'Район (суб-административная область): ${placePoint.subAdministrativeArea}');
        // print('Город: ${placePoint.locality}');
        // print('Район (часть города): ${placePoint.subLocality}');
        // print('Крупная улица или проспект: ${placePoint.thoroughfare}');
        // print('Номер дома: ${placePoint.subThoroughfare}');
        place =
            '${placePoint.name}, ${placePoint.street}, ${placePoint.locality}, ${placePoint.country}';
      }
    } catch (e) {
      //print('Ошибка: $e');
      place = 'error $e';
    }
  }

  setFilter(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: //Text('lll'),
              Text(S.of(context).filterProducts, textAlign: TextAlign.center),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CupertinoTextField(
                  controller: filterStringController,
                  //placeholder: 'search string',
                  placeholder: S.of(context).searchString,
                  clearButtonMode: OverlayVisibilityMode.always,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(S.of(context).cancel),
            ),
            FilledButton(
              onPressed: () {
                getFilteredItems();
                Navigator.pop(context, true);
              },
              child: Text(S.of(context).set),
            ),
          ],
        );
      },
    );
  }

  String getFilteredItems() {
    // Получаем все записи
    allItems = Hive.box<CalcRec>('calcrec').values.toList();
    // Применяем фильтр к элементам
    filteredItems = allItems.where((item) {
      return item.title.contains(filterStringController.text);
    }).toList();
    // формируем заголовок списка
    titleItems = filterStringController.text.isEmpty
        ? '${S.current.last_records} (${filteredItems.length}):'
        : '${S.current.selectedRecords} (${filteredItems.length}/${allItems.length}):';
    return titleItems;
  }
}
