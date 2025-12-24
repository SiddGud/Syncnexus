import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employee/data_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/worker_task_model.dart';
import 'package:worker_app/ui/screens/employee_screen/widgets/workers/task_widget.dart';

class EmployeeTasksList extends StatefulWidget {
  const EmployeeTasksList({super.key});

  @override
  State<EmployeeTasksList> createState() => _EmployeeTasksListState();
}

class _EmployeeTasksListState extends State<EmployeeTasksList> {
  late final Employee employee = context.read<EmployeeDataCubit>().employee;

  void markTaskAsComplete(WorkerTask task) async {
    await employee.completeThisTask(task);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: employee,
        builder: (context, child) {
          if (employee.tasks.isNotEmpty) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: employee.tasks.length,
                itemBuilder: (context, index) {
                  WorkerTask task = employee.tasks[index];
                  return TaskWidgetEmployee(
                    task: task,
                    completeTaskFxn: () => markTaskAsComplete(task),
                  );
                });
          } else {
            return SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  children: [
                    Lottie.asset('assets/lottie/no_tasks.json',
                        width: 200, height: 200),
                    Center(
                        child: Text(
                      "NO TASKS LEFT",
                      style: GoogleFonts.urbanist(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                  ],
                ));
          }
        });
  }
}
