import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class PharmacyProvider extends ChangeNotifier {
  bool fetchLoading = false;
}
