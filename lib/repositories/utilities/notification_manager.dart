import 'dart:async';

class NotificationManager {
  static final NotificationManager instance = NotificationManager._internal();
  final StreamController<Map<String, dynamic>> _notificationController =
      StreamController<Map<String, dynamic>>.broadcast();

  NotificationManager._internal();

  Stream<Map<String, dynamic>> get notificationStream =>
      _notificationController.stream;

  void sendNotification(Map<String, dynamic> message) {
    _notificationController.add(message);
  }

  void addListener(void Function(Map<String, dynamic>) listener) {
    _notificationController.stream.listen(listener);
  }

  void removeListener(void Function(Map<String, dynamic>) listener) {
    _notificationController.stream.drain().then((_) {
      _notificationController.stream.listen(listener);
    });
  }

  void dispose() {
    _notificationController.close();
  }
}
