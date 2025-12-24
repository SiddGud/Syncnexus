import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/models/employee_model.dart';
import 'package:worker_app/models/worker_task_model.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/task_widget_employer.dart';
import 'package:worker_app/ui/screens/employer_screen/widgets/add_task.dart';

class EmployeeTaskListScreen extends StatefulWidget {
  const EmployeeTaskListScreen({super.key, required this.employee});

  final Employee employee;

  @override
  State<EmployeeTaskListScreen> createState() => _EmployeeTaskListScreenState();
}

class _EmployeeTaskListScreenState extends State<EmployeeTaskListScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late CameraPosition initialLocation =
      widget.employee.locationRecords.initialCameraPosition;

  late final employeeTasks = widget.employee.tasks;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generatePolylines();
    });

    // TODO: implement initState
    super.initState();
  }

  void generatePolylines() async {
    final latLongCollection = widget.employee.locationRecords;
    final List<LatLng> latLngCollection = latLongCollection.toLatLngList();

    Set<Marker> tempMarkers = {};
    Set<Polyline> tempPolylines = {};

    for (LatLng latLng in latLngCollection) {
      tempMarkers.add(Marker(
          markerId: MarkerId(latLng.hashCode.toString()),
          position: latLng,
          icon: BitmapDescriptor.defaultMarker));

      tempPolylines.add(Polyline(
          polylineId: const PolylineId('this'),
          points: latLngCollection.toList()));
    }

    setState(() {
      markers = tempMarkers;
      polylines = tempPolylines;
    });
  }

  void addTaskSheet() {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        isScrollControlled: true,
        builder: (context) => const AddTaskWidget());
  }

  void removeTaskFromEmployee(WorkerTask task) async {
    await widget.employee.removeThisTask(task);
  }

  void goToRatingScreen() {
    context.push('/screens/rating', extra: widget.employee.id);
  }

  @override
  Widget build(BuildContext context) {
    generatePolylines();
    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.grey.shade200, //const Color.fromARGB(255, 226, 181, 31),
          title: Text(
            "Tasks",
            style:
                GoogleFonts.urbanist(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
                onPressed: goToRatingScreen, icon: const Icon(Icons.star))
          ],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 5,
            backgroundColor: const Color.fromARGB(255, 226, 181, 31),
            onPressed: addTaskSheet,
            child: const Icon(Icons.add)),
        // backgroundColor: const Color.fromARGB(255, 234, 196, 72),
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height / 2.5,
                width: MediaQuery.sizeOf(context).width,
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: markers,
                    polylines: polylines,
                    initialCameraPosition: initialLocation,
                    onMapCreated: (controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
              ),
              ListenableBuilder(
                listenable: widget.employee,
                builder: (context, child) => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.employee.tasks.length,
                  itemBuilder: (context, index) => TaskWidgetEmployer(
                      task: widget.employee.tasks[index],
                      fxn: () =>
                          removeTaskFromEmployee(widget.employee.tasks[index])),
                ),
              ),
            ],
          ),
        ));
  }
}
