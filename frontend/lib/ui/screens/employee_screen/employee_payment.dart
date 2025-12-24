import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employee/data_cubit.dart';
import 'package:worker_app/bloc/cubit/employee/payments_cubit.dart';
import 'package:worker_app/models/payment_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/ui/screens/employee_screen/widgets/workers/payment_details_sheet.dart';

class EmployeePaymentScreen extends StatefulWidget {
  const EmployeePaymentScreen({super.key});

  @override
  State<EmployeePaymentScreen> createState() => _EmployeePaymentScreenState();
}

class _EmployeePaymentScreenState extends State<EmployeePaymentScreen> {
  late final EmployeeDataCubit employerDataCubit =
      context.read<EmployeeDataCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EmployeePaymentsCubit(employeeId: employerDataCubit.employee.id),
      child: Scaffold(
        body: BlocBuilder<EmployeePaymentsCubit, EmployeePaymentsState>(
          builder: (context, state) {
            if (state is EmployeePaymentsLoaded) {
              List<Payment> payments =
                  context.read<EmployeePaymentsCubit>().payments;

              if (payments.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/payment.png',
                      ),
                      Text(
                        "No Payments Found",
                        style: GoogleFonts.urbanist(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/payment.png',
                      ),
                    ),
                    payments.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: payments.length,
                            itemBuilder: (context, index) =>
                                PaymentCard(payment: payments[index]),
                          )
                        : const SizedBox.shrink()
                  ],
                );
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class PaymentCard extends StatefulWidget {
  const PaymentCard({super.key, required this.payment});

  final Payment payment;

  @override
  State<PaymentCard> createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard>
    with SingleTickerProviderStateMixin {
  late final Animation<double> heightFactorAnimation;
  late final AnimationController controller;
  bool isExpanded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    heightFactorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void toggleExpand() {
    if (isExpanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    isExpanded = !isExpanded;
  }

  void showDetailedPaymentDetails() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: EmployeePaymentDetailsSheet(payment: widget.payment)));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: showDetailedPaymentDetails, //toggleExpand,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        // color: Colors.white,
        surfaceTintColor: Colors.transparent,
        color: Colors.grey.shade200,
        shadowColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/images/default_user.png'),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.payment.paidBy.name,
                          style: GoogleFonts.urbanist(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.payment.createdAt,
                          style: GoogleFonts.urbanist(
                              fontSize: 13,
                              color: Colors.grey.shade900,
                              fontWeight: FontWeight.w500),
                        )
                        // Text(
                        //   "For transportation asdashdkj asdjash jkashdasdjk djsahdjk ashdkj sahkdjk haskj dhskajdhsakj dnash ahsjkd nhasjkd nhasjkd nhndhjdnhsajdhn kasd nhk",
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        //   style: GoogleFonts.urbanist(
                        //     color: Colors.grey.shade700,
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Wrap(
                      spacing: -3,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(
                          Icons.currency_rupee,
                          size: 20,
                        ),
                        Text(
                          '${widget.payment.amount.toDouble()}',
                          style: GoogleFonts.urbanist(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // SizeTransition(
              //   sizeFactor: heightFactorAnimation,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const HeadingText(text: "Notes"),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(
              //             horizontal: 24, vertical: 8),
              //         child: Text(widget.payment.remarks),
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
