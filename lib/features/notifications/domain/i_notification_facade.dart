import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/notifications/domain/models/notification_model.dart';

abstract class INotificationFacade {
  FutureResult<List<NotificationModel>> getAllNotifications();
  void clearNotificationData();
}
