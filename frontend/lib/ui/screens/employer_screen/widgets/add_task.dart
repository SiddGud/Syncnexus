import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/provider/employer_endpoints.dart';
import 'package:worker_app/widgets/overlay_widget.dart';

class AddTaskWidget extends StatefulWidget {
  const AddTaskWidget({super.key});

  @override
  State<AddTaskWidget> createState() => _AddTaskWidgetState();
}

class _AddTaskWidgetState extends State<AddTaskWidget> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  late final List<Employee> employeesList =
      context.read<EmployerDataCubit>().employeesList;
  Employee? selectedEmployee;
  DateTime? deadline;
  bool showTitleErrorText = false;

  @override
  void dispose() {
    descController.dispose();
    titleController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void pickDate() {
    showDatePicker(
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          deadline = pickedDate;
        });
      }
    });
  }

  bool get inputIsValid {
    if (titleController.text.length < 5) {
      showTitleErrorText = true;
      return false;
    }

    if (selectedEmployee == null) {
      return false;
    }

    if (deadline == null) {
      return false;
    }

    return true;
  }

  void assignTaskToEmployee() async {
    if (inputIsValid) {
      final String title = titleController.text;
      final String desc = descController.text;
      overlayPortalController.show();
      addTask(selectedEmployee!.id, title, desc, deadline!)
          .then((success) async {
        await Future.delayed(const Duration(seconds: 1));
        if (success) {
          await selectedEmployee!.getMyTasks();
        }
        overlayPortalController.hide();
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: overlayChildBuilder,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white
            // color: Color.fromRGBO(234, 196, 72, 1),
            ),
        child: SingleChildScrollView(
            child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text("Add New Task",
                    style: GoogleFonts.urbanist(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
              Text(
                "Title",
                style: GoogleFonts.urbanist(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              TextField(
                controller: titleController,
                onChanged: (value) {
                  if (value.length > 5 && showTitleErrorText) {
                    showTitleErrorText = false;
                  }
                },
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  errorText: showTitleErrorText
                      ? "Title should be at least 5 characters long."
                      : null,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFfafafa),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Employee",
                style: GoogleFonts.urbanist(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              DropdownButtonFormField(
                  decoration: InputDecoration(
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
                    filled: true,
                    fillColor: const Color(0xFFfafafa),
                  ),
                  items: employeesList
                      .map((employee) => DropdownMenuItem<Employee>(
                            value: employee,
                            child: Text(employee.name),
                          ))
                      .toList(),
                  onChanged: (employee) {
                    selectedEmployee = employee;
                  }),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Deadline",
                style: GoogleFonts.urbanist(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8)),
                child: ListTile(
                  onTap: pickDate,
                  leading: const Icon(Icons.calendar_month),
                  title: Text(
                    deadline != null
                        ? deadline.toString().split(" ")[0]
                        : "Pick a date",
                    style: const TextStyle(fontSize: 18),
                  ),
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                      onPressed: assignTaskToEmployee,
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor:
                              const Color.fromARGB(255, 226, 181, 31),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      child: Text(
                        'Add Task',
                        style: GoogleFonts.urbanist(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
