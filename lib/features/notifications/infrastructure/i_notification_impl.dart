import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:healthy_cart_user/core/failures/main_failure.dart';
import 'package:healthy_cart_user/core/general/firebase_collection.dart';
import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/notifications/domain/i_notification_facade.dart';
import 'package:healthy_cart_user/features/notifications/domain/models/notification_model.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: INotificationFacade)
class INotificationImpl implements INotificationFacade {
  INotificationImpl(this._firestore);
  final FirebaseFirestore _firestore;

  DocumentSnapshot<Map<String, dynamic>>? lastDoc;
  bool noMoreData = false;
  @override
  FutureResult<List<NotificationModel>> getAllNotifications() async {
    if (noMoreData) return right([]);
    int limit = lastDoc == null ? 15 : 8;
    try {
      Query query = _firestore
          .collection(FirebaseCollections.notificationCollection)
          .orderBy('isCreated', descending: true);

      if (lastDoc != null) {
        query = query.startAfterDocument(lastDoc!);
      }
      final snapshot = await query.limit(limit).get();
      if (snapshot.docs.length < limit || snapshot.docs.isEmpty) {
        noMoreData = true;
      } else {
        lastDoc = snapshot.docs.last as DocumentSnapshot<Map<String, dynamic>>;
      }

      final notificationList = snapshot.docs
          .map((e) =>
              NotificationModel.fromMap(e.data() as Map<String, dynamic>)
                  .copyWith(id: e.id))
          .toList();

      return right(notificationList);
    } catch (e) {
      return left(MainFailure.generalException(errMsg: e.toString()));
    }
  }

  @override
  void clearNotificationData() {
    lastDoc = null;
    noMoreData = false;
  }
}
