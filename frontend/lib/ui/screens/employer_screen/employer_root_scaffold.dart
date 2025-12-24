import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:worker_app/bloc/cubit/employer/data_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployerRootScaffold extends StatefulWidget {
  const EmployerRootScaffold({super.key, required this.child});

  final Widget child;

  @override
  State<EmployerRootScaffold> createState() => _EmployerRootScaffoldState();
}

class _EmployerRootScaffoldState extends State<EmployerRootScaffold> {
  int _selectedIndex = 0;

  void onItemTapped(int selected) {
    setState(() {
      _selectedIndex = selected;
    });

    if (selected == 0) {
      context.go('/screens/employer/homescreen');
    } else if (selected == 1) {
      context.go('/screens/employer/jobs');
    } else if (selected == 2) {
      context.go('/screens/employer/payment');
    } else if (selected == 3) {
      context.go('/screens/employer/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => EmployerDataCubit()),
      ],
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 226, 181, 31),
          onTap: onItemTapped,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
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
