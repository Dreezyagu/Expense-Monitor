import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_monitor/Screens%20and%20Widgets/auth.dart';
import 'package:expense_monitor/Screens%20and%20Widgets/maindash.dart';
import 'package:expense_monitor/Screens%20and%20Widgets/predashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({required this.news, Key? key}) : super(key: key);
  final int news;
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController regEmail = TextEditingController();
  TextEditingController regPass = TextEditingController();
  String month = '';
  int state = 0;

  @override
  void initState() {
    super.initState();
    state = widget.news;
    final int mont = DateTime.now().month;
    switch (mont) {
      case 1:
        month = 'January';
        break;
      case 2:
        month = 'February';
        break;
      case 3:
        month = 'March';
        break;
      case 4:
        month = 'April';
        break;
      case 5:
        month = 'May';
        break;
      case 6:
        month = 'June';
        break;
      case 7:
        month = 'July';
        break;
      case 8:
        month = 'August';
        break;
      case 9:
        month = 'September';
        break;
      case 10:
        month = 'October';
        break;
      case 11:
        month = 'November';
        break;
      case 12:
        month = 'December';
        break;
      default:
    }
    check(auth.currentUser);
  }

  Future check(User? user) async {
    if (user?.uid != null) {
      final DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc(month)
          .get();
      setState(() {
        ds.exists ? state = 2 : state = 1;
        // aa = ds.exists;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Container();
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return Auth(auth);
          }
          if (state == 2) {
            return Maindash(
              auth: auth,
              user: auth.currentUser,
            );
          } else if (state == 1) {
            return Dashboard(
              auth: auth,
              user: auth.currentUser,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        }
        return Column(
          children: const [
            Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}

class Textfield extends StatelessWidget {
  const Textfield({Key? key, required this.controller, required this.label})
      : super(key: key);

  final String label;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }
}
