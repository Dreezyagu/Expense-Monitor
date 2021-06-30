import 'dart:async';

import 'package:expense_monitor/Screens%20and%20Widgets/spaces.dart';
import 'package:expense_monitor/Utils/constants.dart';
import 'package:expense_monitor/Utils/functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth extends StatefulWidget {
  final FirebaseAuth auth;

  const Auth(this.auth);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  TextEditingController lemail = TextEditingController();
  TextEditingController lpass = TextEditingController();
  TextEditingController remail = TextEditingController();
  TextEditingController rpass = TextEditingController();
  TextEditingController rpassCon = TextEditingController();
  TextEditingController name = TextEditingController();
  bool obscure1 = false;
  bool obscure2 = false;
  bool obscure3 = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
              isScrollable: false,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(
                fontSize: context.width(.06),
                fontWeight: FontWeight.w900,
                color: white,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: context.width(.055),
                fontWeight: FontWeight.w400,
                color: white,
              ),
              tabs: [
                Text(
                  'Log in',
                ),
                Text(
                  'Sign up',
                ),
              ]),
        ),
        body: Container(
          child: ListView(
            children: [
              Hspace(context.height(.1)),
              Container(
                height: context.height(.7),
                child: TabBarView(
                    // controller: _tabController,
                    children: [
                      logIn(lemail: lemail, lpass: lpass, auth: widget.auth),
                      signUp(
                          auth: widget.auth,
                          name: name,
                          remail: remail,
                          rpass: rpass,
                          rpassCon: rpassCon),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget signUp(
      {required TextEditingController name,
      required TextEditingController remail,
      required TextEditingController rpass,
      required TextEditingController rpassCon,
      required FirebaseAuth auth}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width(.075)),
        child: Column(
          children: [
            TextField(
              controller: name,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Name'),
            ),
            Hspace(context.height(.05)),
            TextField(
              controller: remail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email'),
            ),
            Hspace(context.height(.05)),
            TextField(
              controller: rpass,
              obscureText: !obscure1,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure1 = !obscure1;
                        });
                      },
                      icon: Icon(
                          obscure1 ? Icons.visibility_off : Icons.visibility)),
                  hintText: 'Password'),
            ),
            Hspace(context.height(.05)),
            TextField(
              controller: rpassCon,
              obscureText: !obscure2,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure2 = !obscure2;
                        });
                      },
                      icon: Icon(
                          obscure2 ? Icons.visibility_off : Icons.visibility)),
                  hintText: 'Confirm Password'),
            ),
            Hspace(context.height(.08)),
            ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (rpassCon.text.trim() != rpass.text.trim()) {
                    Fluttertoast.showToast(msg: 'Password doesn\'t match');
                    return;
                  }
                  EasyLoading.show(
                      indicator: CircularProgressIndicator(),
                      dismissOnTap: false);
                  AuthFunctions.register(name.text.trim(), remail.text.trim(),
                      rpass.text.trim(), widget.auth);
                  EasyLoading.dismiss();
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.width(.03)),
                    child: Center(
                        child: Text("Sign Up",
                            style: TextStyle(
                              fontSize: context.width(.055),
                              fontWeight: FontWeight.w700,
                              color: white,
                            )))))
          ],
        ),
      ),
    );
  }

  Widget logIn(
      {required TextEditingController lemail,
      required TextEditingController lpass,
      required FirebaseAuth auth}) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.width(.075)),
        child: Column(
          children: [
            TextField(
              controller: lemail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'Email'),
            ),
            Hspace(context.height(.05)),
            TextField(
              controller: lpass,
              obscureText: !obscure3,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obscure3 = !obscure3;
                        });
                      },
                      icon: Icon(
                          obscure3 ? Icons.visibility_off : Icons.visibility)),
                  hintText: 'Password'),
            ),
            Hspace(context.height(.08)),
            ElevatedButton(
                onPressed: () {
                  if (lemail.text.isEmpty || lpass.text.isEmpty) {
                    return;
                  }
                  FocusScope.of(context).requestFocus(FocusNode());

                  EasyLoading.show(
                      indicator: CircularProgressIndicator(),
                      dismissOnTap: false);
                  AuthFunctions.login(
                      lemail.text.trim(), lpass.text.trim(), widget.auth);

                  EasyLoading.dismiss();
                },
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(context.width(.03)),
                    child: Center(
                        child: Text("Log in",
                            style: TextStyle(
                              fontSize: context.width(.055),
                              fontWeight: FontWeight.w700,
                              color: white,
                            )))))
          ],
        ),
      ),
    );
  }
}
