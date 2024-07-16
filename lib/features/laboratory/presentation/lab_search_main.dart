import 'package:animate_do/animate_do.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:healthy_cart_user/core/custom/app_bars/sliver_search_appbar.dart';
import 'package:healthy_cart_user/core/custom/loading_indicators/loading_indicater.dart';
import 'package:healthy_cart_user/core/custom/no_data/no_data_widget.dart';
import 'package:healthy_cart_user/core/custom/toast/toast.dart';
import 'package:healthy_cart_user/core/services/easy_navigation.dart';
import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
import 'package:healthy_cart_user/features/authentication/presentation/login_ui.dart';
import 'package:healthy_cart_user/features/laboratory/application/provider/lab_provider.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/lab_details_screen.dart';
import 'package:healthy_cart_user/features/laboratory/presentation/widgets/lab_list_card.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class LaboratoriesMainSearch extends StatefulWidget {
  const LaboratoriesMainSearch({super.key});

  @override
  State<LaboratoriesMainSearch> createState() => _LaborataryMainSearchState();
}

class _LaborataryMainSearchState extends State<LaboratoriesMainSearch> {
  @override
  void dispose() {
    super.dispose();
    EasyDebounce.cancel('labsearch');
  }

  @override
  Widget build(BuildContext context) {
    final screenwidth = MediaQuery.of(context).size.width;
    return Consumer2<LabProvider, AuthenticationProvider>(
        builder: (context, labProvider, authProvider, _) {
      return Scaffold(
        body: PopScope(
          onPopInvoked: (didPop) {
            labProvider.clearLabData();
          },
          child: CustomScrollView(
            controller: labProvider.searchScrollController,
            slivers: [
              CustomSliverSearchAppBar(
                searchHint: 'Search Laboratories',
                controller: labProvider.labSearchController,
                onTapBackButton: () {
                  EasyNavigation.pop(context: context);
                },
                searchOnChanged: (value) {
                  if (value.trim().isEmpty) {
                    labProvider.clearLabData();
                    return;
                  }
                  EasyDebounce.debounce(
                    'labsearch',
                    const Duration(milliseconds: 500),
                    () {
                      labProvider.searchLabs();
                    },
                  );
                },
              ),
              if (labProvider.labFetchLoading == true &&
                  labProvider.labSearchList.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: LoadingIndicater(),
                  ),
                )
              else if (labProvider.labSearchList.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: NoDataImageWidget(
                      text: (labProvider.labSearchController.text == '')
                          ? 'Search results will be shown here.'
                          : 'No Search results found.'),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList.separated(
                      separatorBuilder: (context, index) => const Gap(12),
                      itemCount: labProvider.labSearchList.length,
                      itemBuilder: (context, index) {
                        final labDetails = labProvider.labSearchList[index];
                        return FadeInUp(
                          child: LabListCard(
                            screenwidth: screenwidth,
                            labortaryData: labDetails,
                            onTap: () {
                              if (authProvider.auth.currentUser == null) {
                                  EasyNavigation.push(
                            type: PageTransitionType.rightToLeft,
                            context: context, page:const LoginScreen() );
                                CustomToast.infoToast(
                                    text: 'Login to continue !');
                              } else {
                                EasyNavigation.push(
                                    context: context,
                                    type: PageTransitionType.rightToLeft,
                                    page: LabDetailsScreen(
                                      labId: labDetails.id!,
                                      index: index,
                                    ));
                              }
                            },
                          ),
                        );
                      }),
                ),
              SliverToBoxAdapter(
                child: (labProvider.labFetchLoading == true &&
                        labProvider.labSearchList.isNotEmpty)
                    ? const Center(child: LoadingIndicater())
                    : null
              ),
            ],
          ),
        ),
      );
    });
  }
}
