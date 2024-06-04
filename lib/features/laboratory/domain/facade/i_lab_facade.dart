import 'package:healthy_cart_user/core/general/typdef.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';

abstract class ILabFacade {
  FutureResult<List<LabModel>> getLabs({required String? labSearch});
  void clearData();
}
