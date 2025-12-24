import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employee/data_cubit.dart';
import 'package:worker_app/provider/user_endpoints.dart';
import 'package:worker_app/widgets/overlay_widget.dart';
import 'package:go_router/go_router.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployerProfileScreenState();
}

class _EmployerProfileScreenState extends State<EmployeeProfileScreen> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  late final EmployeeDataCubit employeeDataCubit =
      context.read<EmployeeDataCubit>();
  late final email = employeeDataCubit.employee.email;
  bool showNameErrorText = false;
  bool showPhoneErrorText = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    nameController.text = employeeDataCubit.employee.name;
    phoneController.text = employeeDataCubit.employee.phone;

    // TODO: implement initState
    super.initState();
  }

  bool get inputIsValid {
    if (nameController.text.length < 3) {
      setState(() {
        showNameErrorText = true;
      });
      return false;
    }

    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      setState(() {
        showPhoneErrorText = true;
      });
      return false;
    }

    return true;
  }

  void profileUpdatedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: const Color.fromARGB(255, 226, 181, 31),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        behavior: SnackBarBehavior.fixed,
        content: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 226, 181, 31),
              borderRadius: BorderRadius.circular(20)),
          child: Text(
            "Profile Updated",
            style: GoogleFonts.urbanist(fontSize: 16, color: Colors.black),
          ),
        )));
  }

  void updateProfile() async {
    overlayPortalController.show();
    if (inputIsValid) {
      await updateUser(nameController.text, phoneController.text, email);

      employeeDataCubit.getEmployeeData();
    }
    overlayPortalController.hide();
    profileUpdatedSnackbar();
  }

  void showSignOutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                "Confirm Logout",
                style: GoogleFonts.urbanist(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure, you want to logout?",
                style: TextStyle(fontSize: 16),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.black),
                    )),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 226, 181, 31),
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: const Text(
                    "Confirm",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            )).then((result) async {
      if (result) {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().signOut();
        await context.read<EmployeeDataCubit>().close();
        context.go('/screens/authentication/signup');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: overlayChildBuilder,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey.shade200,
            title: Text(
              "Profile",
              style: GoogleFonts.urbanist(
                  fontSize: 32, fontWeight: FontWeight.bold),
            ),
            actions: [
              IconButton(
                  onPressed: showSignOutDialog, icon: const Icon(Icons.logout))
            ],
            centerTitle: true,
          ),
          backgroundColor: Colors.grey.shade100,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                ),
              ),
              Positioned(
                left: (MediaQuery.sizeOf(context).width / 2) - 48,
                top: 120 - 48,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                          width: 48 * 2,
                          height: 48 * 2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: Image.asset(
                            'assets/images/default_user.png',
                          )),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black87,
                        ),
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                  top: MediaQuery.sizeOf(context).height / 3.5,
                  child: Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: const TextStyle(
                                // color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w500,
                                height: 0.06,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                              errorText: showNameErrorText
                                  ? "Please enter valid name"
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFFfafafa),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            onChanged: (value) {
                              if (value.length == 10) {
                                setState(() {
                                  showPhoneErrorText = false;
                                });
                              }
                            },
                            controller: phoneController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: const TextStyle(
                                // color: Colors.black,
                                fontSize: 16,
                                fontFamily: 'Epilogue',
                                fontWeight: FontWeight.w500,
                                height: 0.06,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
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
                              errorText: showPhoneErrorText
                                  ? "Phone number must be 10 digits long"
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFFfafafa),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: SizedBox(
                                width: MediaQuery.sizeOf(context).width / 3.5,
                                child: ElevatedButton(
                                    onPressed: updateProfile,
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: const Color.fromARGB(
                                            255, 226, 181, 31),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20))),
                                    child: Text(
                                      'Save',
                                      style: GoogleFonts.urbanist(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ),
                        ]),
                  )),
            ],
          )),
    );
  }
}
