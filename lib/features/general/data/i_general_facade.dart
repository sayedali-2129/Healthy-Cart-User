import 'package:healthy_cart_user/features/general/data/model/general_model.dart';

abstract class IGeneralFacade {
  Stream<GeneralModel?> fetchData() async* {
    throw UnimplementedError("fetchData() Not implemented");
  }
}
