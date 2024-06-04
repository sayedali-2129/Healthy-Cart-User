import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:healthy_cart_user/features/laboratory/domain/facade/i_lab_facade.dart';
import 'package:healthy_cart_user/features/laboratory/domain/models/lab_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class LabProvider with ChangeNotifier {
  LabProvider(this.iLabFacade);
  final ILabFacade iLabFacade;

  bool isLabOnlySelected = true;
  TextEditingController labSearchController = TextEditingController();

  List<LabModel> labList = [];
  bool labFetchLoading = false;

/* ----------------------------- TEST SELECTION ----------------------------- */
  void labTabSelection() {
    isLabOnlySelected = !isLabOnlySelected;
    notifyListeners();
  }
  /* -------------------------------------------------------------------------- */

/* --------------------------- GET AND SEARCH LABS -------------------------- */
  Future<void> getLabs() async {
    labFetchLoading = true;
    notifyListeners();

    final result =
        await iLabFacade.getLabs(labSearch: labSearchController.text);

    result.fold(
      (err) {
        log(err.errMsg);
        labFetchLoading = false;
        notifyListeners();
      },
      (success) {
        labList.addAll(success);
        log('labs fetched successfully');
      },
    );
    labFetchLoading = false;
    notifyListeners();
  }

  void searchLabs() {
    clearLabData();
    getLabs();
    notifyListeners();
  }

  void clearLabData() {
    iLabFacade.clearData();
    labList = [];
    notifyListeners();
  }

  void init(ScrollController scrollController) {
    scrollController.addListener(
      () {
        if (scrollController.position.atEdge &&
            scrollController.position.pixels != 0 &&
            labFetchLoading == false) {
          getLabs();
        }
      },
    );
  }
  /* -------------------------------------------------------------------------- */
}
