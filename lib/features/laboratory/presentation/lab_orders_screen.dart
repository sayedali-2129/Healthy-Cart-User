// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:healthy_cart_user/core/custom/app_bars/sliver_custom_appbar.dart';
// import 'package:healthy_cart_user/features/authentication/application/provider/authenication_provider.dart';
// import 'package:healthy_cart_user/features/laboratory/application/provider/lab_orders_provider.dart';
// import 'package:healthy_cart_user/features/laboratory/presentation/widgets/accept_card.dart';
// import 'package:provider/provider.dart';

// class LabOrdersScreen extends StatefulWidget {
//   const LabOrdersScreen({super.key});

//   @override
//   State<LabOrdersScreen> createState() => _LabOrdersScreenState();
// }

// class _LabOrdersScreenState extends State<LabOrdersScreen> {
//   @override
//   void initState() {
//     final authProvider = context.read<AuthenticationProvider>();
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) {
//         context
//             .read<LabOrdersProvider>()
//             .getLabOrder(userId: authProvider.userFetchlDataFetched!.id!);
//       },
//     );
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Consumer<LabOrdersProvider>(builder: (context, ordersProvider, _) {
//       return Scaffold(
//         body: CustomScrollView(
//           slivers: [
//             SliverCustomAppbar(
//                 title: 'Lab Orders', onBackTap: () => Navigator.pop(context)),
//             SliverPadding(
//               padding: const EdgeInsets.all(16),
//               sliver: SliverList.separated(
//                   separatorBuilder: (context, index) => const Gap(12),
//                   itemCount: ordersProvider.ordersList.length,
//                   itemBuilder: (context, index) {
//                     return AcceptCard(
//                       screenWidth: screenWidth,
//                       index: index,
//                     );
//                   }),
//             )
//           ],
//         ),
//       );
//     });
//   }
// }
