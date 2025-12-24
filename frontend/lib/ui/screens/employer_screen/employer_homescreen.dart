import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/employees_list.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/add_employee_widget.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/add_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployerHomeScreen extends StatefulWidget {
  const EmployerHomeScreen({super.key});

  @override
  State<EmployerHomeScreen> createState() => _EmployerHomeScreenState();
}

class _EmployerHomeScreenState extends State<EmployerHomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void addEmployeeSheet() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => const AddEmployeeWidget());
  }

  void addTaskSheet() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => const AddTaskWidget());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // backgroundColor: const Color.fromARGB(255, 234, 196, 72),
      appBar: AppBar(
        backgroundColor:
            Colors.grey.shade200, //const Color.fromARGB(255, 226, 181, 31),
        title: Text(
          "Dashboard",
          style:
              GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        openButtonBuilder: RotateFloatingActionButtonBuilder(
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            child: const Icon(
              Icons.add,
            )),
        closeButtonBuilder: RotateFloatingActionButtonBuilder(
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            child: const Icon(
              Icons.add,
            )),
        type: ExpandableFabType.up,
        distance: 65,
        children: [
          FloatingActionButton.extended(
            heroTag: 'btn2',
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            onPressed: addTaskSheet,
            label: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(Icons.lock_clock),
                Text(" Task"),
              ],
            ),
          ),
          FloatingActionButton.extended(
            heroTag: 'btn3',
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            onPressed: addEmployeeSheet,
            label: const Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [Icon(Icons.person), Text(' Employee')],
            ),
          ),
        ],
      ),
      body: BlocConsumer<EmployerDataCubit, EmployerDataState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is EmployerDataLoaded) {
            Employer employer = context.read<EmployerDataCubit>().employer;
            List<Employee> employeesList =
                context.read<EmployerDataCubit>().employeesList;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    // height: MediaQuery.sizeOf(context).height / 4,
                    width: MediaQuery.sizeOf(context).width,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors
                            .grey.shade200, //Color.fromARGB(255, 234, 196,
                        //72), //Color.fromARGB(255, 226, 181, 31),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20))),
                    child: ListTile(
                      minVerticalPadding: 0,

                      // isThreeLine: true,
                      title: Text(
                        "Hi,",
                        style: GoogleFonts.urbanist(fontSize: 18),
                      ),
                      subtitle: Text(
                        employer.name,
                        style: GoogleFonts.urbanist(
                            fontSize: 30, color: Colors.black),
                      ),
                      trailing: Stack(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              'assets/images/default_user.png',
                              height: 72,
                              width: 72,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color.fromARGB(255, 234, 196, 72),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 165,
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey
                              .shade300, //Color.fromARGB(255, 226, 181, 31),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          const Text(
                            "Total\nEmployees",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            employeesList.length.toString(),
                            style: const TextStyle(
                                fontSize: 64, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 165,
                      width: 150,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey
                              .shade300, //Color.fromARGB(255, 226, 181, 31),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Column(
                        children: [
                          const Text(
                            "Total\nJobs",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            context
                                .read<EmployerDataCubit>()
                                .jobsList
                                .length
                                .toString(),
                            style: const TextStyle(
                                fontSize: 64, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SingleChildScrollView(child: EmployeesListWidget())
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
