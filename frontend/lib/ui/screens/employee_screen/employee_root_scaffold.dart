import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:worker_app/bloc/cubit/employee/data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:worker_app/bloc/cubit/location_cubit.dart';
import 'package:worker_app/models/lat_long_model.dart';
import 'package:worker_app/provider/employee_endpoints.dart';

class EmployeeRootScaffold extends StatefulWidget {
  const EmployeeRootScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<EmployeeRootScaffold> createState() => _EmployeeRootScaffoldState();
}

class _EmployeeRootScaffoldState extends State<EmployeeRootScaffold> {
  int _selectedIndex = 0;

  void sendLocationAfter5Minutes() {
    BlocListener<LocationCubit, LocationState>(
      listener: (context, state) async {
        final LatLong latLong =
            await context.read<LocationCubit>().getLocation();
        await addLocation(latLong.lat, latLong.long);

        Future.delayed(const Duration(minutes: 5)).then((_) {
          if (state is LocationOn) {
            sendLocationAfter5Minutes();
          }
        });
      },
    );
  }

  @override
  void initState() {
    sendLocationAfter5Minutes();
    // TODO: implement initState
    super.initState();
  }

  void onItemTapped(int selected) {
    setState(() {
      _selectedIndex = selected;
    });

    if (selected == 0) {
      context.go('/screens/employee/homescreen');
    } else if (selected == 1) {
      context.go('/screens/employee/jobs');
    } else if (selected == 2) {
      context.go('/screens/employee/payment');
    } else if (selected == 3) {
      context.go('/screens/employee/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmployeeDataCubit()),
      ],
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 226, 181, 31),
          onTap: onItemTapped,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                label: "Dashboard", icon: Icon(Icons.dashboard)),
            BottomNavigationBarItem(label: "Jobs", icon: Icon(Icons.work)),
            BottomNavigationBarItem(
                label: "Payment", icon: Icon(Icons.payment)),
            BottomNavigationBarItem(label: "Profile", icon: Icon(Icons.person))
          ],
        ),
      ),
    );
  }
}
