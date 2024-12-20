import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CardStorage {
  final _secureStorage = const FlutterSecureStorage();

  // Ключи для хранения данных
  static const _cardNumberKey = 'memorizator_card_number';
  static const _expiryDateKey = 'memorizator_expiry_date';
  static const _cardHolderNameKey = 'memorizator_card_holder_name';
  static const _cvvCodeKey = 'memorizator_cvv_code';

  // Сохранение данных карты
  Future<void> saveCardDetails({
    required String cardNumber,
    required String expiryDate,
    required String cardHolderName,
    required String cvvCode,
  }) async {
    await _secureStorage.write(key: _cardNumberKey, value: cardNumber);
    await _secureStorage.write(key: _expiryDateKey, value: expiryDate);
    await _secureStorage.write(key: _cardHolderNameKey, value: cardHolderName);
    await _secureStorage.write(key: _cvvCodeKey, value: cvvCode);
  }

  // Загрузка данных карты
  static Future<CreditCardModel> loadCardDetails() async {
    final secureStorage = FlutterSecureStorage();

    final cardNumber = await secureStorage.read(key: _cardNumberKey) ?? '';
    final expiryDate = await secureStorage.read(key: _expiryDateKey) ?? '';
    final cardHolderName =
        await secureStorage.read(key: _cardHolderNameKey) ?? '';
    final cvvCode = await secureStorage.read(key: _cvvCodeKey) ?? '';

    return CreditCardModel(
      cardNumber,
      expiryDate,
      cardHolderName,
      cvvCode,
      false,
    );
  }

  // Удаление данных карты
  Future<void> deleteCardDetails() async {
    await _secureStorage.delete(key: _cardNumberKey);
    await _secureStorage.delete(key: _expiryDateKey);
    await _secureStorage.delete(key: _cardHolderNameKey);
    await _secureStorage.delete(key: _cvvCodeKey);
  }

  // Проверка наличия данных
  Future<bool> dataSaved() async {
    final cardNumber = await _secureStorage.read(key: _cardNumberKey);
    final expiryDate = await _secureStorage.read(key: _expiryDateKey);
    final cardHolderName = await _secureStorage.read(key: _cardHolderNameKey);
    final cvvCode = await _secureStorage.read(key: _cvvCodeKey);

    return cardNumber != null ||
        expiryDate != null ||
        cardHolderName != null ||
        cvvCode != null;
  }
}
