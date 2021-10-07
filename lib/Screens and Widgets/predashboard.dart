import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_monitor/Screens%20and%20Widgets/spaces.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_monitor/Utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Dashboard extends StatefulWidget {
  final FirebaseAuth auth;
  final User? user;

  const Dashboard({Key? key, required this.auth, required this.user})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late CollectionReference amounts;
  // CollectionReference spendings =
  //     FirebaseFirestore.instance.collection('Spendings');

  TextEditingController amount = TextEditingController();
  String month = '';

  @override
  void initState() {
    super.initState();

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
    amounts = FirebaseFirestore.instance.collection(widget.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: newMonth(widget.user, amounts, amount, month));
  }

  Widget newMonth(
    User? user,
    CollectionReference amounts,
    TextEditingController amount,
    String month,
  ) {
    return Padding(
      padding: EdgeInsets.all(context.width(.04)),
      child: Column(
        children: [
          Hspace(context.height(.05)),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Welcome, ${widget.user?.displayName}",
              style: TextStyle(
                  fontSize: context.width(.07),
                  color: Colors.purple,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Hspace(context.height(.07)),
          Text(
            "Please enter your total cash to monitor the month of $month",
            style: TextStyle(
                fontSize: context.width(.045), fontWeight: FontWeight.w500),
          ),
          Hspace(context.height(.02)),
          TextField(
            controller: amount,
            style: TextStyle(fontSize: context.width(.05)),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.all(context.width(.04)),
                hintText: 'E.g, 100,000'),
          ),
          Hspace(context.height(.075)),
          ElevatedButton(
              onPressed: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                EasyLoading.show(
                    indicator: const CircularProgressIndicator(),
                    dismissOnTap: false);
                amounts
                    .doc(month)
                    .set({
                      "amount": amount.text,
                      "expenses": [],
                    })
                    .catchError(
                        (error) => print("Failed to add amount: $error"))
                    .then((value) {
                      EasyLoading.dismiss();
                      Navigator.pushReplacementNamed(context, 'homepage');
                    });
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.width(.03)),
                child: Center(
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: context.width(.05),
                        fontWeight: FontWeight.w700),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
