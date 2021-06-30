import 'package:expense_monitor/Screens%20and%20Widgets/homepage.dart';
import 'package:expense_monitor/Utils/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CircularProgressIndicator();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Expense Monitor',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Roboto',
              brightness: Brightness.dark,
              secondaryHeaderColor: white,
              primaryColor: Color(0xff7AF7FD),
              primarySwatch: MaterialColor(0xff7AF7FD, {
                100: Color(0xff7AF7FD),
                200: Color(0xff7AF7FD),
                300: Color(0xff7AF7FD),
                400: Color(0xff7AF7FD),
                500: Color(0xff7AF7FD),
                600: Color(0xff7AF7FD),
                700: Color(0xff7AF7FD),
                800: Color(0xff7AF7FD),
                900: Color(0xff7AF7FD),
              }),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              appBarTheme: Theme.of(context).appBarTheme.copyWith(
                  color: dark, iconTheme: IconThemeData(color: white)),
              scaffoldBackgroundColor: dark,
              cardColor: dark,
              dividerColor: lightGrey.withOpacity(.2),
              bottomAppBarColor: dark,
              bottomSheetTheme: BottomSheetThemeData(backgroundColor: dark),
            ),
            home: Homepage(
              news: false,
            ),
            builder: EasyLoading.init(),
            routes: {
              'homepage': (context) => Homepage(news: false),
            },
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
