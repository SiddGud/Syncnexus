import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:worker_app/bloc/cubit/location_cubit.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/models/lat_long_model.dart';

class AddJobWidget extends StatefulWidget {
  const AddJobWidget({super.key, required this.controller});

  final OverlayPortalController controller;

  @override
  State<AddJobWidget> createState() => _AddJobWidgetState();
}

class _AddJobWidgetState extends State<AddJobWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool showTitleErrorText = false;
  bool showAmountErrorText = false;
  bool showDescErrorText = false;

  bool get inputIsValid {
    if (titleController.text.length < 5) {
      setState(() {
        showTitleErrorText = true;
      });
      return false;
    }

    final amount = int.tryParse(amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        showAmountErrorText = true;
      });
      return false;
    }

    if (descController.text.length < 5) {
      setState(() {
        showDescErrorText = true;
      });
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    descController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void addJob() async {
    if (inputIsValid) {
      widget.controller.show();
      final String title = titleController.text;
      final String amount = amountController.text;
      final String desc = descController.text;

      final LatLong latLong = await context.read<LocationCubit>().getLocation();

      await addJobs(desc, title, latLong.lat, latLong.long, int.parse(amount));
      await context.read<EmployerDataCubit>().getAllJobs(shoudEmit: true);

      widget.controller.hide();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<LocationCubit>().isLocationEnabled();

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Colors.white
          // color: Color.fromRGBO(234, 196, 72, 1),
          ),
      child: BlocBuilder<LocationCubit, LocationState>(
        builder: (context, state) {
          if (state is LocationOn) {
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Add New Job",
                        style: GoogleFonts.urbanist(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    "Title",
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (showTitleErrorText) {
                          setState(() {
                            showTitleErrorText = false;
                          });
                        }
                      }
                    },
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: const TextStyle(
                        // color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w500,
                        height: 0.06,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: showTitleErrorText
                          ? "Please enter valid title"
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFfafafa),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Payment (INR)",
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    controller: amountController,
                    onChanged: (value) {
                      final amount = int.tryParse(value);
                      if (amount != null && amount > 0) {
                        if (showAmountErrorText) {
                          setState(() {
                            showAmountErrorText = false;
                          });
                        }
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '0',
                      labelStyle: const TextStyle(
                        // color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w500,
                        height: 0.06,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: showAmountErrorText
                          ? "Please enter valid amount."
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFfafafa),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Description",
                    style: GoogleFonts.urbanist(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        if (showDescErrorText) {
                          setState(() {
                            showDescErrorText = false;
                          });
                        }
                      }
                    },
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLength: 100,
                    minLines: 3,
                    maxLines: 5,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      labelStyle: const TextStyle(
                        // color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Epilogue',
                        fontWeight: FontWeight.w500,
                        height: 0.06,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: showTitleErrorText
                          ? "Please enter valid description"
                          : null,
                      filled: true,
                      fillColor: const Color(0xFFfafafa),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFfafafa),
                              elevation: 0,
                              side: const BorderSide(color: Colors.black),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Text('Cancel',
                              style: GoogleFonts.urbanist(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      ElevatedButton(
                          onPressed: addJob,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor:
                                  const Color.fromARGB(255, 226, 181, 31),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          child: Text(
                            'Save',
                            style: GoogleFonts.urbanist(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ));
          } else {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height / 2,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/map.png',
                      height: 200,
                      width: 200,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Please Enable Location",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.urbanist(fontSize: 32),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
