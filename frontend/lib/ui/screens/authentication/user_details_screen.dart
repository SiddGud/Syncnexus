import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_app/provider/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/widgets/overlay_widget.dart';

class OthersDetailScreen extends StatefulWidget {
  const OthersDetailScreen({super.key});

  @override
  State<OthersDetailScreen> createState() => _OthersDetailScreenState();
}

class _OthersDetailScreenState extends State<OthersDetailScreen> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();

  late SharedPreferences prefs = context.read<SharedPreferences>();
  late UserProvider userProvider = context.read<UserProvider>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool nameIsValid = false;
  bool phoneIsValid = false;

  bool showPhoneErrorText = false;
  bool showNameErrorText = false;

  String? role;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void nextEmployee() async {
    userProvider.employee = true;

    try {
      userProvider.createUser().then((_) {
        prefs.setBool('employee', true);

        context.go('/screens/employee/homescreen');
        overlayPortalController.hide();
      });
    } catch (e) {
      overlayPortalController.hide();
    }
  }

  void nextEmployer() async {
    userProvider.employee = false;

    try {
      userProvider.createUser().then((_) {
        prefs.setBool('employee', false);

        overlayPortalController.hide();
        context.go('/screens/employer/homescreen');
      });
    } catch (e) {
      overlayPortalController.hide();
    }
  }

  void nameValidation(String value) {
    setState(() {
      if (value.length >= 3) {
        nameIsValid = true;
        setState(() {
          showNameErrorText = false;
        });
      } else {
        nameIsValid = false;
      }
    });
  }

  void phoneValidation(String value) {
    setState(() {
      if (value.length == 10) {
        phoneIsValid = true;
        setState(() {
          showPhoneErrorText = false;
        });
      } else {
        phoneIsValid = false;
      }
    });
  }

  bool get inputsAreValid {
    if (!nameIsValid) {
      setState(() {
        showNameErrorText = true;
      });
      return false;
    }

    if (!phoneIsValid) {
      setState(() {
        showPhoneErrorText = true;
      });
      return false;
    }

    if (role == null) {
      return false;
    }

    return true;
  }

  void submit() {
    if (inputsAreValid) {
      overlayPortalController.show();

      userProvider.uid = FirebaseAuth.instance.currentUser!.uid;
      userProvider.email = FirebaseAuth.instance.currentUser!.email!;
      userProvider.phone = phoneController.text;
      userProvider.name = nameController.text;

      if (role == "Employee") {
        nextEmployee();
      } else {
        nextEmployer();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfcfcfc),
      body: OverlayPortal(
        controller: overlayPortalController,
        overlayChildBuilder: overlayChildBuilder,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(),
              Text(
                "Getting started!✌️",
                style: GoogleFonts.dmSans(
                    fontSize: 22, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  "Look like you are new to us! Create an account for a complete experience.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mulish(
                      color: const Color(0xFF8e8ea9),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextField(
                  controller: nameController,
                  onChanged: nameValidation,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: nameIsValid
                          ? SvgPicture.asset(
                              'assets/images/icon.svg',
                              height: 20,
                              width: 20,
                            )
                          : const SizedBox.shrink(),
                    ),
                    errorText:
                        showNameErrorText ? "Please Enter correct name." : null,
                    labelStyle: GoogleFonts.mulish(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      height: 0.06,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: TextField(
                  controller: phoneController,
                  onChanged: phoneValidation,
                  maxLength: 10,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixText: "+91 ",
                    labelText: 'Phone Number',
                    suffixIcon: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: phoneIsValid
                          ? SvgPicture.asset(
                              'assets/images/icon.svg',
                              height: 20,
                              width: 20,
                            )
                          : const SizedBox.shrink(),
                    ),
                    errorText: showPhoneErrorText
                        ? "Phone Number should be 10 digits long."
                        : null,
                    labelStyle: GoogleFonts.mulish(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                      height: 0.06,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      label: const Text("Role"),
                      floatingLabelStyle: GoogleFonts.mulish(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                        height: 0.06,
                      ),
                      suffixIconConstraints: BoxConstraints.tight(role != null
                          ? const Size(48, 48)
                          : const Size(10, 48)),
                      suffixIcon: role != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: SvgPicture.asset('assets/images/icon.svg'),
                            )
                          : const SizedBox(
                              width: 0,
                            ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: "Employer",
                        child: Text(
                          'Employer',
                          style: GoogleFonts.mulish(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            height: 0.06,
                          ),
                        ),
                      ),
                      DropdownMenuItem<String>(
                        value: "Employee",
                        child: Text(
                          'Employee',
                          style: GoogleFonts.mulish(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                            height: 0.06,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        role = value;
                      });
                    }),
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: MediaQuery.sizeOf(context).width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor:
                            const Color.fromARGB(255, 226, 181, 31),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Next",
                      style: GoogleFonts.mulish(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 0.06,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
