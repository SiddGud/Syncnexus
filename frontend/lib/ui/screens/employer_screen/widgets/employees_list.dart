import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesListWidget extends StatefulWidget {
  const EmployeesListWidget({super.key});

  @override
  State<EmployeesListWidget> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListWidget> {
  late List<Employee> employeesList =
      context.watch<EmployerDataCubit>().employeesList;

  void removeEmployeeFromListView() {
    setState(() {
      employeesList = context.read<EmployerDataCubit>().employeesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: employeesList.length,
      itemBuilder: (context, index) => EmployeeItem(
          employee: employeesList[index],
          fxn: () => removeEmployeeFromListView()),
    );
  }
}

class EmployeeItem extends StatefulWidget {
  const EmployeeItem({super.key, required this.employee, required this.fxn});

  final Employee employee;
  final Function fxn;

  @override
  State<EmployeeItem> createState() => _EmployeeItemState();
}

class _EmployeeItemState extends State<EmployeeItem> {
  void freeThisEmployee() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Remove Employee?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure, you want to remove this employee?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black),
              )),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 226, 181, 31),
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(15))),
            child: const Text(
              "No",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    ).then((result) async {
      if (result) {
        await context.read<EmployerDataCubit>().freeEmployee(widget.employee);
        widget.fxn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          context.push('/screens/employer/employee', extra: widget.employee),
      child: Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        Image.asset('assets/images/default_user.png').image,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.employee.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      ListenableBuilder(
                        listenable: widget.employee,
                        builder: (context, child) => Text(
                          "${widget.employee.phone} • ${widget.employee.tasks.length} Task",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.remove),
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 222, 95, 86),
                          shape: const CircleBorder()),
                      onPressed: freeThisEmployee),
                ],
              ),
            ],
          )),
    );
  }
}
