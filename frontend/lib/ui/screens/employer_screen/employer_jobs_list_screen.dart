import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/models/job_model.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/add_job.dart';
import 'package:worker_app/widgets/overlay_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final OverlayPortalController overlayPortalController =
      OverlayPortalController();
  late List<Job> jobsList = context.read<EmployerDataCubit>().jobsList;

  void showAddJobSheet() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) =>
            AddJobWidget(controller: overlayPortalController));
  }

  void removeJobFromListView(int index) {
    (jobsList[index]).removeThisJob();
    setState(() {
      jobsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: overlayPortalController,
      overlayChildBuilder: overlayChildBuilder,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            onPressed: showAddJobSheet,
            label: const Text("Add Job"),
            icon: const Icon(Icons.add),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 45,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    height: 150,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Lottie.asset('assets/lottie/job.json'),
                    // child: Image.asset(
                    //   'assets/images/job_employer.png',
                    //   height: 100,
                    // ),
                  ),
                  BlocBuilder<EmployerDataCubit, EmployerDataState>(
                    builder: (context, state) {
                      if (state is EmployerDataLoaded) {
                        jobsList = context.read<EmployerDataCubit>().jobsList;

                        return ListView.builder(
                            shrinkWrap: true,
                            // physics: const AlwaysScrollableScrollPhysics(),
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: jobsList.length,
                            itemBuilder: (context, index) {
                              return JobItem(
                                  job: jobsList[index],
                                  fxn: () => removeJobFromListView(index));
                            });
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                  jobsList.isNotEmpty
                      ? const SizedBox.shrink()
                      : Text(
                          "No Jobs Found",
                          style: GoogleFonts.urbanist(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )
                ],
              ),
            ),
          )),
    );
  }
}

class JobItem extends StatefulWidget {
  const JobItem({super.key, required this.job, required this.fxn});

  final Job job;
  final Function fxn;

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> with SingleTickerProviderStateMixin {
  late final Animation<double> heightFactorAnimation;
  late final AnimationController controller;
  bool isExpanded = false;
  late bool? done = widget.job.done;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
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

  void toggleTaskItem() {
    if (isExpanded) {
      controller.reverse();
    } else {
      controller.forward();
    }
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  void markThisJobAsCompleted() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Mark this job as completed?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure, you want to mark this job as completed? It will be removed from employee side.",
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
      if (result == true) {
        await widget.job.completeThisJob();
        setState(() {
          done = true;
        });
      }
    });
  }

  void removeThisJob() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Delete Job?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure, you want to delete this job from records?",
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
        await widget.job.removeThisJob();
        widget.fxn();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Column(
        children: [
          InkWell(
            onTap: toggleTaskItem,
            child: Card(
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              margin: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 4),
              surfaceTintColor: Colors.transparent,
              color: Colors.grey.shade200,
              shadowColor:
                  Colors.transparent, //const Color.fromARGB(255, 226, 181, 31),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    width: MediaQuery.sizeOf(context).width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outlined,
                              size: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.job.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          const Icon(Icons.currency_rupee),
                          const SizedBox(
                            width: 10,
                          ),
                          RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  text: "Amount : ",
                                  children: [
                                    const WidgetSpan(
                                        child: SizedBox(
                                      width: 10,
                                    )),
                                    TextSpan(
                                        text: "${widget.job.amount}/-",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ])),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          const Icon(Icons.check_circle),
                          const SizedBox(
                            width: 10,
                          ),
                          RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  text: "Status : ",
                                  children: [
                                    const WidgetSpan(
                                        child: SizedBox(
                                      width: 10,
                                    )),
                                    WidgetSpan(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(4)),
                                            color: done == true
                                                ? Colors.green
                                                : const Color.fromARGB(
                                                    255, 234, 196, 72)),
                                        child: Text(
                                          done == true ? "Completed" : "Active",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 23, 67, 25),
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ])),
                        ]),
                        SizeTransition(
                          sizeFactor: heightFactorAnimation,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    color: Color.fromARGB(255, 234, 196, 72)),
                                child: const Text(
                                  "Description",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 5),
                                child: Text(
                                  widget.job.desc,
                                  style: const TextStyle(fontSize: 15),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        done == true
                            ? const SizedBox.shrink()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: removeThisJob,
                                      label: const Text(
                                        "Remove",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                      )),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: ContinuousRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5))),
                                      onPressed: markThisJobAsCompleted,
                                      label: const Text(
                                        "Complete",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.black,
                                      )),
                                ],
                              )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                            width: 50,
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 226, 181, 31),
                                borderRadius: BorderRadius.circular(30)),
                            child:
                                Icon(isExpanded ? Icons.remove : Icons.add))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
