// logger.dart
Map<DateTime, String> asyncOperationLogs = {};

void logAsyncOperation(String message) {
  asyncOperationLogs[DateTime.now()] = message;
}
