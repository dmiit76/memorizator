import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:latlong2/latlong.dart';
import 'package:memorizator/generated/l10n.dart';
import 'package:memorizator/models/calcrec.dart';
import 'package:memorizator/providers/info_provider.dart';
import 'package:memorizator/screens/settings_screen/ad_manager.dart';
import 'package:memorizator/services/constants.dart';
import 'package:memorizator/widgets/autocomplete_text_field.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  final CalcRec item;
  final int index;
  const MapScreen(this.item, this.index, {super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  TextEditingController customPlaceController = TextEditingController();
  TextEditingController mapPlaceController = TextEditingController();
  final MapController _mapController = MapController();
  double latitude = 0;
  double longitude = 0;
  // название текущей локации
  String place = '';
  //Список названий локаций
  List<String> places = [];
  // список координат локаций
  //List<Location> locations = [];
  String placeNew = '';
  bool _enableButtonSave = false;

  @override
  void initState() {
    super.initState();
    customPlaceController =
        TextEditingController(text: widget.item.place ?? '');
    mapPlaceController = TextEditingController(text: widget.item.place ?? '');
    latitude = widget.item.latitude ?? 0;
    longitude = widget.item.longitude ?? 0;
    place = widget.item.place ?? '';

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    customPlaceController.dispose();
    mapPlaceController.dispose();
    super.dispose();
  }

  void _updateMarkerPosition() {
    setState(() {
      // Обновляем центр карты, чтобы он соответствовал новой метке
      _mapController.move(
          LatLng(latitude, longitude), 16.0); // move(center, zoom)
    });
  }

  Future<void> getCoordinatesFromAddress(String address) async {
    // Кнопка "Найти на карте" - определяем List<Location> locations из возможных адресов
    try {
      // customPlaceController.text = placeNew;
      // Получаем список возможных геолокаций по адресу
      List<Location> locations = await locationFromAddress(address);
      //Если есть хотя бы одно совпадение используем его
      //для получения списка возможных адресов по локации
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
        // запрашиваем список возможных адресов по локации
        await getFullAddress(latitude, longitude);
      } else {
        // if (context.mounted) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(content: Text('Не выбран вариант адреса..')),
        //   );
        // }
      }
    } catch (e) {
      //List<Location> locations = [];
      //print('Ошибка при получении координат: $e');
    }
    _updateMarkerPosition();
    setState(() {});
  }

  Future<void> _setFirstLocation(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        latitude = locations.first.latitude;
        longitude = locations.first.longitude;
      }
    } catch (e) {
      //List<Location> locations = [];
      //print('Ошибка при получении координат: $e');
    }
    _updateMarkerPosition();
    setState(() {});
  }

  Future<void> saveLocationInBase() async {
    // записываем в базу новые координаты
    final CalcRec currentCalcRec;
    currentCalcRec = Hive.box<CalcRec>('calcrec').getAt(widget.index)!;
    currentCalcRec.latitude = latitude;
    currentCalcRec.longitude = longitude;
    currentCalcRec.place = place;

    if (Hive.isBoxOpen('calcrec')) {
      Hive.box<CalcRec>('calcrec').putAt(widget.index, currentCalcRec);
      Provider.of<InfoProvider>(context, listen: false).setPlace(place);
    } else {
      throw Error();
    }
  }

  Future<String> getFullAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        places.clear();
        //locations.clear();
        for (var element in placemarks) {
          //locations.add(Location(
          //    latitude: latitude,
          //    longitude: longitude,
          //    timestamp: DateTime.now()));
          places.add(
              '${element.name}, ${element.street}, ${element.locality}, ${element.country}');
        }
        //Placemark placePoint = placemarks.first;

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

        //placeNew =
        //    '${placePoint.name}, ${placePoint.street}, ${placePoint.locality}, ${placePoint.country}';
      }
    } catch (e) {
      //print('Ошибка: $e');
      place = 'error $e';
    }
    return placeNew.isNotEmpty ? placeNew : '';
  }

  void _onButtonPressed() {
    setState(() {
      saveLocationInBase();
      customPlaceController.text = place;
      _updateMarkerPosition();
    });
  }

  @override
  Widget build(BuildContext context) {
    //final infoProvider = context.read<InfoProvider>();
    final mapScreenButtonStyle = ElevatedButton.styleFrom(
      disabledBackgroundColor:
          Colors.grey, // Цвет фона, когда кнопка недоступна
      disabledForegroundColor:
          Colors.black45, // Цвет текста, когда кнопка недоступна
      backgroundColor: aWhite,
      shadowColor: aGray,
      elevation: 20,
      padding: const EdgeInsets.only(left: 8, right: 8),
      minimumSize: const Size(
          double.infinity, 60), // Устанавливаем минимальную высоту кнопки
    );
    return Scaffold(
      backgroundColor: aLightBlue,
      appBar: AppBar(
        title: Text(
          S.of(context).locationClarification,
          style: const TextStyle(color: aBlue),
        ),
        foregroundColor: aBlue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SizedBox(
          // height: (MediaQuery.of(context).orientation == Orientation.portrait)
          //     ? MediaQuery.of(context).size.height -
          //         kToolbarHeight -
          //         kTextTabBarHeight
          //     : 1500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                color: aLightBlue,
                width: double.infinity,
                //height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoTextField(
                            controller: customPlaceController,
                            clearButtonMode: OverlayVisibilityMode.always,
                            placeholder: S
                                .of(context)
                                .enterAddress, // Можно добавить плейсхолдер
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            onChanged: (value) {
                              _enableButtonSave = false;
                            },
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: CupertinoColors
                                      .inactiveGray), // Добавляем границу
                            ),
                            style: const TextStyle(
                                height: 1.1,
                                color: CupertinoColors.black), // Цвет текста
                            minLines: 2,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 60,
                          width: 120,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getCoordinatesFromAddress(
                                    customPlaceController.text);
                              });
                              setState(() {});
                            },
                            style: mapScreenButtonStyle,
                            child: Center(
                              // Центрируем текст
                              child: Text(
                                S.of(context).findOnMap,
                                textAlign: TextAlign
                                    .center, // Центрируем текст по горизонтали
                                style: const TextStyle(
                                    fontSize:
                                        12), // Можно изменить размер шрифта, если нужно
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Visibility(
                      visible: places.isNotEmpty,
                      child: const SizedBox(
                        height: 8,
                      ),
                    ),
                    Visibility(
                      visible: places.isNotEmpty,
                      child: Row(
                        children: [
                          Expanded(
                            child: AutocompleteTextField(
                              items: places,
                              defaultValue: '', //customPlaceController.text,
                              decoration: InputDecoration(
                                  labelText:
                                      S.of(context).chooseALocationOption,
                                  border: const OutlineInputBorder()),
                              validator: (val) {
                                if (places.contains(val)) {
                                  return null;
                                } else {
                                  return 'Invalid Adress';
                                }
                              },
                              onItemSelect: (selected) {
                                setState(() {
                                  place = selected;
                                  _enableButtonSave = true;
                                  _setFirstLocation(selected);
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            height: 60,
                            width: 120,
                            child: ElevatedButton(
                              onPressed:
                                  _enableButtonSave ? _onButtonPressed : null,
                              style: mapScreenButtonStyle,
                              child: Center(
                                // Центрируем текст
                                child: Text(
                                  S.of(context).saveLocation,
                                  textAlign: TextAlign
                                      .center, // Центрируем текст по горизонтали
                                  style: const TextStyle(
                                      fontSize:
                                          12), // Можно изменить размер шрифта, если нужно
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(1),
                  //width: double.infinity,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        latitude,
                        longitude,
                        // widget.item.latitude ?? 0,
                        // widget.item.longitude ?? 0,
                      ),
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
                            // Координаты для маркера
                            point: LatLng(
                              latitude,
                              longitude,

                              // widget.item.latitude ?? 0,
                              // widget.item.longitude ?? 0,
                            ),
                            child: const Icon(Icons.location_on,
                                color: Colors.red, size: 40),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Visibility(
              //   visible: !Provider.of<PurchaseProvider>(context).isPaidUser,
              //   child: const SizedBox(
              //     height: 8,
              //   ),
              // ), // Показываем баннер

              const BannerAdWidgetAdaptive(), //  баннер
            ],
          ),
        ),
      ),
    );
  }
}
