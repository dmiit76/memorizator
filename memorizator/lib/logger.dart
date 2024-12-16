import 'dart:async';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:intl/intl.dart';

// Использование:
// try {
//   // Ваш код здесь
//   Logger.instance.addLog('Action performed successfully');
// } catch (e) {
//   Logger.instance.addLog('Error performing action: $e');
// }

class Logger {
  // Приватный конструктор
  Logger._privateConstructor() {
    // Запуск таймера при создании экземпляра
    _timer =
        Timer.periodic(const Duration(seconds: 15), (Timer t) => writeLog());
  }
  //String message = '';
  static Logger? _instance;
  StringBuffer logBuffer = StringBuffer();
  Timer? _timer;

  void dispose() {
    _timer?.cancel(); // Отмена таймера при удалении Logger
  }

  // Публичный фабричный метод для доступа к экземпляру
  static Logger get instance {
    // Возвращает существующий экземпляр или создает новый
    _instance ??= Logger._privateConstructor();
    return _instance!;
  }

  Future<void> writeLog() async {
    if (logBuffer.isEmpty) {
      return;
    }
    final directory = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS);
    final now = DateTime.now();
    final formatter = DateFormat('ddMMHHmm');
    final formatted = formatter.format(now);
    final fileName = 'log$formatted.txt';
    final filePath = '$directory/$fileName';

    final file = File(filePath);
    String finalString = logBuffer.toString();
    try {
      await file.writeAsString(finalString, mode: FileMode.append);
      logBuffer.clear(); // Очищаем буфер после записи
    } catch (e) {
      var time = DateTime.now().toString();
      await file.writeAsString("$time: Error: $e\n", mode: FileMode.append);
      //print("Failed to write log: $e");
    }
  }

  void addLog(String message) {
    logBuffer.writeln('${DateTime.now().toString()}:  $message');
  }

  // Деструктор для удаления экземпляра
  static void destroyInstance() {
    if (_instance != null) {
      _instance?._timer?.cancel(); // Отменяем таймер
      _instance = null; // Уничтожаем экземпляр
      //print("Logger instance has been destroyed.");
    } else {
      //print("No Logger instance to destroy.");
    }
  }
}
