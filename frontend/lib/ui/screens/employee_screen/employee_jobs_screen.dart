import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:worker_app/bloc/cubit/location_cubit.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:worker_app/models/job_model.dart';
import 'package:worker_app/provider/employee_endpoints.dart';
import 'package:worker_app/provider/user_endpoints.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/models/lat_long_model.dart';

class EmployeeJobsScreen extends StatefulWidget {
  const EmployeeJobsScreen({super.key});

  @override
  State<EmployeeJobsScreen> createState() => _EmployeeJobsScreenState();
}

class _EmployeeJobsScreenState extends State<EmployeeJobsScreen> {
  Future<List<Job>> getNearbyJobs() async {
    LatLong latLong = await context.read<LocationCubit>().getLocation();

    List<Job> jobs = [];

    final rawJobs = await getJobs(latLong.lat, latLong.long);

    for (final rawJob in rawJobs) {
      final userData = await getUserByID(rawJob['employer_id']);
      Employer employer = Employer(
          name: userData['name'],
          phone: userData['phone_no'],
          email: userData['email'],
          id: userData['id']);

      jobs.add(Job(
          title: rawJob['title'],
          desc: rawJob['description'],
          employer: employer,
          amount: rawJob['amount'].toString(),
          jobId: rawJob['id']));
    }

    return jobs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Available Jobs",
            style:
                GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            color: const Color.fromARGB(255, 234, 196, 72),
          ),
        ),
        body: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            if (state is LocationDisabled) {
              return Center(
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
                    ),
                    ElevatedButton.icon(
                        onPressed: () =>
                            context.read<LocationCubit>().isLocationEnabled(),
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 234, 196, 72),
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.black,
                        ),
                        label: Text(
                          "Refresh",
                          style: GoogleFonts.urbanist(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ))
                  ],
                ),
              );
            } else {
              return FutureBuilder(
                future: getNearbyJobs(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Job> jobs = snapshot.data!;

                    if (jobs.isEmpty) {
                      return Center(
                          child: SizedBox(
                        height: 250,
                        width: MediaQuery.sizeOf(context).width,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Lottie.asset(
                                'assets/lottie/job_search.json',
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "No Jobs Found",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ));
                    }

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: jobs.length,
                          itemBuilder: (context, index) => JobItem(
                            job: jobs[index],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }
          },
        ));
  }
}

class JobItem extends StatefulWidget {
  const JobItem({super.key, required this.job});

  final Job job;

  @override
  State<JobItem> createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> with SingleTickerProviderStateMixin {
  late final Animation<double> heightFactorAnimation;
  late final AnimationController controller;
  bool isExpanded = false;

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
    isExpanded = !isExpanded;
  }

  void applyForJob() {
    launchUrlString("tel://+91${widget.job.employer.phone}");
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleTaskItem,
      child: Card(
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        margin: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 4),
        surfaceTintColor: Colors.transparent,
        color: Colors.grey.shade200,
        shadowColor:
            Colors.transparent, //const Color.fromARGB(255, 226, 181, 31),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                    style: GoogleFonts.urbanist(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.currency_rupee),
                          const SizedBox(
                            width: 10,
                          ),
                          RichText(
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  text: "Amount : ",
                                  children: [
                                    TextSpan(
                                        text: "${widget.job.amount}/-",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ])),
                        ]),
                        Row(children: [
                          const Icon(Icons.person),
                          const SizedBox(
                            width: 10,
                          ),
                          RichText(
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.left,
                              text: TextSpan(
                                  style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                  text: "Employer : ",
                                  children: [
                                    TextSpan(
                                        text: widget.job.employer.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.normal)),
                                  ])),
                        ]),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    onPressed: applyForJob,
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizeTransition(
                sizeFactor: heightFactorAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Color.fromARGB(255, 234, 196, 72)),
                      child: const Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }
}
