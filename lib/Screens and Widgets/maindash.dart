import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_monitor/Screens%20and%20Widgets/spaces.dart';
import 'package:expense_monitor/Utils/expensemodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:expense_monitor/Utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class Maindash extends StatefulWidget {
  final FirebaseAuth auth;
  final User? user;

  const Maindash({Key? key, required this.auth, this.user}) : super(key: key);

  @override
  _MaindashState createState() => _MaindashState();
}

class _MaindashState extends State<Maindash> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;
  String month = '';
  late CollectionReference expenses;
  TextEditingController amount = TextEditingController();
  TextEditingController description = TextEditingController();

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
    _usersStream = FirebaseFirestore.instance
        .collection(widget.user!.uid)
        .doc(month)
        .snapshots(includeMetadataChanges: true);
    expenses = FirebaseFirestore.instance.collection(widget.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () => widget.auth.signOut(),
                icon: const Icon(Icons.door_back))
          ],
          title: Text(
            "Home",
            style: TextStyle(color: white),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dropdown();
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        // physics: BouncingScrollPhysics(),
        children: [
          Hspace(context.height(.02)),
          Balance(usersStream: _usersStream),
          Indicator(usersStream: _usersStream),
          Expenses(
            usersStream: _usersStream,
            expenses: expenses,
          )
        ],
      ),
    );
  }

  void dropdown() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
            insetPadding: EdgeInsets.zero,
            elevation: 5,
            title: Text(
              "Add an Expense",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: context.width() * .042,
                  fontWeight: FontWeight.w900),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: amount,
                  style: TextStyle(fontSize: context.width(.035)),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(context.width(.03)),
                      hintStyle: TextStyle(fontSize: context.width(.03)),
                      hintText: 'Amount'),
                ),
                Hspace(context.height(.03)),
                TextField(
                  controller: description,
                  style: TextStyle(fontSize: context.width(.035)),
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(context.width(.03)),
                      hintStyle: TextStyle(fontSize: context.width(.03)),
                      hintText: 'Description'),
                ),
                Hspace(context.height(.05)),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {
                      if (amount.text.isEmpty) return;
                      FocusScope.of(context).requestFocus(FocusNode());
                      EasyLoading.show(
                          indicator: const CircularProgressIndicator(),
                          dismissOnTap: false);
                      expenses
                          .doc(month)
                          .update({
                            "expenses": FieldValue.arrayUnion([
                              Expensemodel(
                                      id: DateTime.now().toString(),
                                      value: int.parse(amount.text),
                                      description: description.text,
                                      date: DateTime.now().toString())
                                  .toJson(),
                            ])
                          })
                          .catchError(
                              (error) => print("Failed to add amount: $error"))
                          .then((value) {
                            EasyLoading.dismiss();
                            amount.clear();
                            description.clear();
                            Navigator.pop(context);
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: black, fontSize: context.width(.05)),
                      ),
                    )),
              ],
            )));
  }
}

class Expenses extends StatefulWidget {
  const Expenses(
      {Key? key,
      required Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream,
      required this.expenses})
      : _usersStream = usersStream,
        super(key: key);
  final CollectionReference expenses;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;

  @override
  _ExpensesState createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
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
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController amountc = TextEditingController();
    final TextEditingController descriptionc = TextEditingController();
    void dropdown(amount, description) {
      amountc.text = amount.toString();
      descriptionc.text = description.toString();
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              insetPadding: EdgeInsets.zero,
              elevation: 5,
              title: Text(
                "Add an Expense",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: context.width() * .042,
                    fontWeight: FontWeight.w900),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: amountc,
                    style: TextStyle(fontSize: context.width(.035)),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(context.width(.03)),
                        hintStyle: TextStyle(fontSize: context.width(.03)),
                        hintText: 'Amount'),
                  ),
                  Hspace(context.height(.03)),
                  TextField(
                    controller: descriptionc,
                    style: TextStyle(fontSize: context.width(.035)),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(context.width(.03)),
                        hintStyle: TextStyle(fontSize: context.width(.03)),
                        hintText: 'Description'),
                  ),
                  Hspace(context.height(.05)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                  color: black, fontSize: context.width(.04)),
                            ),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {
                            if (amount.text.isEmpty) return;
                            FocusScope.of(context).requestFocus(FocusNode());
                            EasyLoading.show(
                                indicator: const CircularProgressIndicator(),
                                dismissOnTap: false);
                            widget.expenses
                                .doc(month)
                                .update({
                                  "expenses": FieldValue.arrayUnion([
                                    Expensemodel(
                                            id: DateTime.now().toString(),
                                            value: int.parse(amount.text),
                                            description: description.text,
                                            date: DateTime.now().toString())
                                        .toJson(),
                                  ])
                                })
                                .catchError((error) =>
                                    print("Failed to add amount: $error"))
                                .then((value) {
                                  EasyLoading.dismiss();
                                  amount.clear();
                                  description.clear();
                                  Navigator.pop(context);
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Save",
                              style: TextStyle(
                                  color: black, fontSize: context.width(.04)),
                            ),
                          )),
                    ],
                  ),
                ],
              )));
    }

    return Container(
      height: context.height(.25),
      padding: EdgeInsets.symmetric(
        horizontal: context.width(.03),
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: widget._usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            // var a =
            // Expensemodel.fromJson(snapshot.data!.data()?["expenses"]);
            // print(a);

            final List expensemode = snapshot.data!
                .data()?["expenses"]
                .map((e) => Expensemodel.fromJson(e))
                .toList();
            final List expensemodel = expensemode.reversed.toList();

            return Padding(
              padding: EdgeInsets.all(context.width(.05)),
              child: Column(children: [
                Hspace(context.height(.01)),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Recent Expenses",
                    style: TextStyle(
                      fontSize: context.width(.06),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Hspace(context.height(.02)),
                Expanded(
                  child: Scrollbar(
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: expensemodel.length,
                        itemBuilder: (context, index) {
                          final d = DateFormat.yMMMMd();

                          final String date = d
                              .format(DateTime.parse(expensemodel[index].date));

                          return InkWell(
                            onTap: () {
                              dropdown(expensemodel[index].value,
                                  expensemodel[index].description);
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      context.width(.02))),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xff1F242A),
                                    borderRadius: BorderRadius.circular(
                                        context.width(.02))),
                                height: context.width(.4),
                                width: context.width(.4),
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.width(.04)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      date,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w300,
                                        fontSize: context.width(.035),
                                      ),
                                    ),
                                    Text(
                                      "${expensemodel[index].description}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: context.width(.038),
                                      ),
                                    ),
                                    Text(
                                      "₦${expensemodel[index].value}"
                                          .replaceAllMapped(
                                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                        (Match m) => '${m[1]},',
                                      ),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: context.width(.05),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                )
                // Text(snapshot.data!.data().toString())
              ]),
            );
          }),
    );
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    required Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream,
  })  : _usersStream = usersStream,
        super(key: key);

  final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height(.43),
      padding: EdgeInsets.symmetric(
        horizontal: context.width(.03),
      ),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            final List expensemodel = snapshot.data!
                .data()?["expenses"]
                .map((e) => Expensemodel.fromJson(e))
                .toList();
            int total = 0;
            expensemodel.forEach((element) {
              total += int.parse((element.value).toString());
            });
            final int amount = int.parse(snapshot.data?.data()?["amount"]);
            final int remain = amount - total;

            return Padding(
              padding: EdgeInsets.all(context.width(.05)),
              child: Column(children: [
                Hspace(context.height(.01)),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${snapshot.data?.id}, ${DateTime.now().year}",
                    style: TextStyle(
                      fontSize: context.width(.06),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Hspace(context.height(.04)),
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    SizedBox(
                      width: context.width(.6),
                      height: context.width(.6),
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        strokeWidth: context.width(.08),
                        value: remain / amount,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${((remain / amount) * 100).round()}%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: context.width(.1)),
                        ),
                        Text(
                          'Left',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: context.width(.05)),
                        )
                      ],
                    )
                  ],
                )
                // Text(snapshot.data!.data().toString())
              ]),
            );
          }),
    );
  }
}

class Balance extends StatelessWidget {
  const Balance({
    Key? key,
    required Stream<DocumentSnapshot<Map<String, dynamic>>> usersStream,
  })  : _usersStream = usersStream,
        super(key: key);

  final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height(.16),
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            final List expensemodel = snapshot.data!
                .data()?["expenses"]
                .map((e) => Expensemodel.fromJson(e))
                .toList();
            int total = 0;
            expensemodel.forEach((element) {
              total += int.parse((element.value).toString());
            });
            final int amount = int.parse(snapshot.data?.data()?["amount"]);

            return Card(
              color: const Color(0xff1F242A),
              child: Padding(
                padding: EdgeInsets.all(context.width(.02)),
                child: Column(children: [
                  Hspace(context.height(.01)),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Current Balance",
                      style: TextStyle(
                        fontSize: context.width(.045),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Hspace(context.height(.02)),
                  Text(
                    "₦${amount - total}".replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]},'),
                    style: TextStyle(
                      fontSize: context.width(.1),
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                  // Text(snapshot.data!.data().toString())
                ]),
              ),
            );
          }),
    );
  }
}
