import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/widgets/overlay_widget.dart';

class AddEmployeeWidget extends StatefulWidget {
  const AddEmployeeWidget({super.key});

  @override
  State<AddEmployeeWidget> createState() => _AddEmployeeWidgetState();
}

class _AddEmployeeWidgetState extends State<AddEmployeeWidget> {
  final TextEditingController phoneController = TextEditingController();
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();

  List<Employee> searchedEmployee = [];
  bool notFound = false;

  @override
  void dispose() {
    phoneController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void searchEmployeeOnBackend() async {
    if (phoneController.text.isEmpty || phoneController.text.length < 10) {
      return;
    }
    Map<dynamic, dynamic> searchResult =
        await searchByPhone(phoneController.text);
    if (searchResult.isNotEmpty) {
      Employee employee = Employee(
          name: searchResult['name'],
          phone: searchResult['phone_no'],
          email: searchResult['email'],
          id: searchResult['id']);
      await employee.getMyRating();
      setState(() {
        searchedEmployee.add(employee);
        if (notFound) {
          notFound = false;
        }
      });
    } else {
      setState(() {
        if (searchedEmployee.isEmpty) {
          notFound = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: overlayChildBuilder,
      child: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 8),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text("Add New Employee",
                            style: GoogleFonts.urbanist(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              decoration: InputDecoration(
                                labelText: 'Phone',
                                prefixText: "+91 ",
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
                                filled: true,
                                fillColor: const Color(0xFFfafafa),
                                labelStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: 'Epilogue',
                                  fontWeight: FontWeight.w500,
                                  height: 0.06,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              onPressed: searchEmployeeOnBackend,
                              icon: const Icon(Icons.check),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: const CircleBorder()))
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchedEmployee.length,
                        itemBuilder: (context, index) => SearchedEmployeeItem(
                          employee: searchedEmployee[index],
                          overlayController: overlayPortalController,
                        ),
                      ),
                      searchedEmployee.isEmpty
                          ? Lottie.asset('assets/lottie/employee_search.json',
                              height: 250, width: 250)
                          : const SizedBox.shrink(),
                      notFound
                          ? Text(
                              "No Employee Found",
                              style: GoogleFonts.urbanist(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
              )),
    );
  }
}

class SearchedEmployeeItem extends StatefulWidget {
  const SearchedEmployeeItem(
      {super.key, required this.employee, required this.overlayController});

  final Employee employee;
  final OverlayPortalController overlayController;

  @override
  State<SearchedEmployeeItem> createState() => _SearchedEmployeeItemState();
}

class _SearchedEmployeeItemState extends State<SearchedEmployeeItem> {
  void bindEmployeeToEmployer() async {
    widget.overlayController.show();
    await context.read<EmployerDataCubit>().bindEmployee(widget.employee);
    widget.overlayController.hide();
    Navigator.pop(context);
  }

  void showConfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Are You Sure?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You are going to employ a employee, please confirm the action",
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
      ),
    ).then((result) {
      if (result) {
        bindEmployeeToEmployer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              // dense: true,
              leading: ClipOval(
                child: Image.asset('assets/images/default_user.png'),
              ),
              title: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    widget.employee.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RatingBar.builder(
                    itemSize: 16,
                    initialRating: double.parse(widget.employee.rating!),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 234, 196, 72),
                    ),
                    onRatingUpdate: (value) {},
                  ),
                ],
              ),
              subtitle: Text(
                widget.employee.phone,
                style: const TextStyle(color: Colors.black, fontSize: 17),
              ),
              trailing: IconButton(
                  icon: const Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: const CircleBorder()),
                  onPressed: () => showConfirmDialog(context)),
            ),
          ],
        ));
  }
}
