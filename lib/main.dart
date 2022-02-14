import 'package:chat_app/helpers/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'helpers/route_generator.dart';
import 'ui/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: allProviders,
      child: const MaterialApp(
        onGenerateRoute: AppRouter.generateRoute,
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: () {
          return MaterialApp(
            title: 'Chat App',
            theme: ThemeData(
              fontFamily: "DM Sans",
              primarySwatch: Colors.blue,
            ),
            home: const SplashScreen(),
            onGenerateRoute: AppRouter.generateRoute,
          );
        });
  }
}
