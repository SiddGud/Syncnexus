import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worker_app/bloc/cubit/authentication_cubit.dart';
import 'package:worker_app/bloc/cubit/location_cubit.dart';
import 'package:worker_app/provider/uid_provider.dart';
import 'package:worker_app/provider/user_provider.dart';
import 'package:worker_app/router/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  UidProvider uidProvider = UidProvider();
  UserProvider userProvider = UserProvider();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthenticationCubit()),
        BlocProvider(create: (_) => LocationCubit()),
      ],
      child: MultiProvider(
        providers: [
          Provider(create: (_) => prefs),
          ChangeNotifierProvider(create: (_) => userProvider),
          ChangeNotifierProvider(create: (_) => uidProvider)
        ],
        child: MaterialApp.router(
          routeInformationParser: MyAppRouter.goRouter.routeInformationParser,
          routeInformationProvider:
              MyAppRouter.goRouter.routeInformationProvider,
          routerDelegate: MyAppRouter.goRouter.routerDelegate,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
                seedColor: const Color.fromARGB(255, 226, 181, 31)),
            useMaterial3: true,
          ),
        ),
      ),
    ),
  );
}
