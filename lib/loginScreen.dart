import 'package:habit_21_1/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginScreen extends StatelessWidget {
  String name;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Image.asset('assets/logo.png',fit: BoxFit.contain),
          ),
          Expanded(
              flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextField(
                          onChanged: (String s) {
                            name=s;
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              hintText: 'Name',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      SizedBox(height: 10),
                        RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          color: Colors.white,
                            child: Center(child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Get Started!',style: TextStyle(color: Colors.black)),
                            )),
                            onPressed: () async {
                              UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
                              print(userCredential);
                            },
                        )
                      ],
                    ),
                  ),
                ),

          ),
        ],
      ),
    );
  }
}
