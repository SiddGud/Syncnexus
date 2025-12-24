import 'dart:convert';

import 'package:crclib/catalog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worker_app/models/payment_model.dart';

class EmployerPaymentDetailsSheet extends StatelessWidget {
  const EmployerPaymentDetailsSheet({super.key, required this.payment});

  final Payment payment;

  String convertToCrc32(String input) {
    return Crc32().convert(const Utf8Encoder().convert(input)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Container(
        height: MediaQuery.sizeOf(context).height / 1.5,
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(255, 226, 181, 31)),
              child: const Icon(
                Icons.check,
                size: 40,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              payment.amount.toString(),
              style: GoogleFonts.urbanist(
                  color: Colors.black,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              "Paid to ${payment.paidTo.name}",
              style: GoogleFonts.urbanist(color: Colors.grey.shade700),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              payment.paidTo.email,
              style: GoogleFonts.urbanist(color: Colors.grey.shade700),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                color: Colors.grey.shade200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("You have paid",
                            style: GoogleFonts.urbanist(
                                color: const Color(0xFF616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text(
                          payment.amount.toDouble().toString(),
                          style: GoogleFonts.urbanist(
                              color: const Color(
                                0xFF424242,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("To",
                            style: GoogleFonts.urbanist(
                                color: const Color(0xFF616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text(
                          payment.paidTo.name,
                          style: GoogleFonts.urbanist(
                              color: const Color(
                                0xFF424242,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Email",
                            style: GoogleFonts.urbanist(
                                color: const Color(0xFF616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text(
                          payment.paidTo.email,
                          style: GoogleFonts.urbanist(
                              color: const Color(
                                0xFF424242,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Date",
                            style: GoogleFonts.urbanist(
                                color: const Color(0xFF616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text(
                          payment.createdAt,
                          style: GoogleFonts.urbanist(
                              color: const Color(
                                0xFF424242,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Transaction ID",
                            style: GoogleFonts.urbanist(
                                color: const Color(0xFF616161),
                                fontSize: 16,
                                fontWeight: FontWeight.w500)),
                        Text(
                          convertToCrc32(payment.paymentId),
                          style: GoogleFonts.urbanist(
                              color: const Color(
                                0xFF424242,
                              ),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade500,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Notes",
                          style: GoogleFonts.urbanist(
                              color: const Color(0xFF616161),
                              fontSize: 16,
                              fontWeight: FontWeight.w500)),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        payment.remarks,
                        style: GoogleFonts.urbanist(
                            color: const Color(
                              0xFF424242,
                            ),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
