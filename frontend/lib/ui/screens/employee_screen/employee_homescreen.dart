import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:worker_app/bloc/cubit/employee/data_cubit.dart';
import 'package:worker_app/bloc/cubit/location_cubit.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/employer_model.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/models/worker_task_model.dart';
import 'package:worker_app/models/lat_long_model.dart';
import 'package:worker_app/provider/employee_endpoints.dart';
import 'package:worker_app/ui/screens/employee_screen/widgets/workers/heading_text_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/ui/screens/employee_screen/widgets/workers/tasks_list.dart';

class WorkerHomeScreen extends StatefulWidget {
  const WorkerHomeScreen({super.key});

  @override
  State<WorkerHomeScreen> createState() => _WorkerHomeScreenState();
}

class _WorkerHomeScreenState extends State<WorkerHomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? initialLocation;
  final CameraPosition defaultMapLocation = const CameraPosition(
    target: LatLng(15.5937, 80.9629),
    zoom: 4,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setPositionOnMap(
      {required double lat, required double long, double zoom = 14.4746}) {
    _controller.future.then((value) => value.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, long), zoom: zoom))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      bottomSheet: const MyBottomSheet(),
      body: Center(
        child: Column(
          children: [
            SizedBox(
                height: MediaQuery.sizeOf(context).height / 2.5,
                width: MediaQuery.sizeOf(context).width,
                child: BlocConsumer<LocationCubit, LocationState>(
                  listener: (context, state) async {
                    if (state is LocationOn) {
                      LatLong latLong =
                          await context.read<LocationCubit>().getLocation();
                      setPositionOnMap(lat: latLong.lat, long: latLong.long);
                    }
                  },
                  builder: (context, state) {
                    if (state is LocationOn) {
                      context
                          .read<LocationCubit>()
                          .getLocation()
                          .then((LatLong latLong) {
                        setPositionOnMap(lat: latLong.lat, long: latLong.long);
                      });
                    } else {
                      setPositionOnMap(lat: 15.5937, long: 80.9629, zoom: 4);
                    }

                    return GoogleMap(
                      onCameraMove: (position) {
                        position.zoom;
                      },
                      mapType: MapType.normal,
                      buildingsEnabled: true,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      trafficEnabled: true,
                      initialCameraPosition:
                          initialLocation ?? defaultMapLocation,
                      onMapCreated: (controller) {
                        _controller.complete(controller);
                      },
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  late final Employee employee = context.read<EmployeeDataCubit>().employee;
  late final Employer? employer = context.read<EmployeeDataCubit>().employer;

  void markTaskAsComplete(WorkerTask task) async {
    await employee.completeThisTask(task);
  }

  void markJobCompleted() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Action?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Are you sure, you want to mark this job as completed?",
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
        await leaveJob().then((value) {
          context.read<EmployeeDataCubit>().getAllData();
        });
        showRatingScreen();
      }
    });
  }

  void showRatingScreen() {
    context.push('/screens/rating', extra: employer!.id);
  }

  void getFreeFromEmployer() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "You want to leave this job?",
          style:
              GoogleFonts.urbanist(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "You understand the consequences and want to leave this job?",
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
        await leaveJob().then((value) {
          context.read<EmployeeDataCubit>().getAllData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) {
        return Container(
          height: 500,
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: BlocBuilder<EmployeeDataCubit, EmployeeDataState>(
            builder: (context, state) {
              if (state is EmployeeDataLoaded) {
                if (context.read<EmployeeDataCubit>().employer == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Lottie.asset('assets/lottie/not_employed.json',
                            height: 250, width: 250),
                        Text(
                          "You do not have an active job.",
                          style: GoogleFonts.urbanist(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadingText(text: 'Employer'),
                        ],
                      ),
                      ListTile(
                        titleAlignment: ListTileTitleAlignment.center,
                        leading: ClipOval(
                          child: Image.asset('assets/images/default_user.png'),
                        ),
                        title: Text(
                          employer!.name,
                          style: GoogleFonts.urbanist(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          employer!.phone,
                          style: GoogleFonts.urbanist(fontSize: 16),
                        ),
                        trailing: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 234, 196, 72),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Icon(
                            Icons.call,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: getFreeFromEmployer,
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.red,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4))),
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              child: Text(
                                "Leave Job",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.urbanist(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          ListenableBuilder(
                            listenable: employee,
                            builder: (context, child) => InkWell(
                              onTap: employee.tasks.isEmpty
                                  ? markJobCompleted
                                  : null,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: employee.tasks.isEmpty
                                        ? Colors.green
                                        : Colors.grey,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4))),
                                margin: const EdgeInsets.only(
                                    top: 20, left: 20, right: 20),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                child: Text(
                                  "Complete Job",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.urbanist(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const HeadingText(text: 'Tasks'),
                      const EmployeeTasksList()
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }
}
