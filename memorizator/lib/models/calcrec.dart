import 'package:hive/hive.dart';

//part 'lib/models/calcrec.g.dart';
part 'calcrec.g.dart';
//part 'hive/calcrec_adapter.dart';
// flutter packages pub run build_runner build

@HiveType(typeId: 1)
class CalcRec {
  @HiveField(0)
  DateTime date; // дата записи

  @HiveField(1)
  String title; // продукт

  @HiveField(2)
  int weight; // вес

  @HiveField(3)
  double price; // цена в местной валюте

  @HiveField(11)
  double rating = 0.0; //рейтинг пользователя для товара

  @HiveField(12)
  String comment = ''; // продукт

  @HiveField(13)
  String customName = ''; // название магазина/салона/кафе где был товар

  @HiveField(4)
  String? codeName; // буквенный код валюты

  @HiveField(5)
  String? barcode; // штрихкод товара

  @HiveField(6)
  double? latitude; // широта  геопозиция места сохранения

  @HiveField(7)
  double? longitude; // долгота  геопозиция места сохранения

  @HiveField(10)
  String? place; // Текстовое представление адреса места

  @HiveField(8)
  List<String>? listPhotoPath; // ссылка на фото в галерее

  @HiveField(9)
  Map<String, double>? rateMap; // список активных валют на момент записи

  CalcRec(this.date, this.title, this.price, this.rating, this.comment,
      this.weight, this.customName,
      {this.codeName,
      this.barcode,
      this.latitude,
      this.longitude,
      this.place,
      this.listPhotoPath,
      this.rateMap});
}
