import 'package:habit_21_1/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Data.dart';

class LoginScreen extends StatefulWidget {
  bool loading = false;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String name;
  String dropdownvalue = 'Gender';
  List<DropdownMenuItem<String>> menu = [
    DropdownMenuItem(
      value: 'Gender',
      child: Text(
        'Gender',
        style: TextStyle(color: Colors.white),
      ),
    ),
    DropdownMenuItem(
      value: 'Female',
      child: Text(
        'Female',
        style: TextStyle(color: Colors.white),
      ),
    ),
    DropdownMenuItem(
      value: 'Male',
      child: Text(
        'Male',
        style: TextStyle(color: Colors.white),
      ),
    )
  ];
  List<dynamic> habitNames = [
    'Happiness',
    'Exercise',
    'No Junk Food',
    'Study',
    'Sleep',
    'Positive Mindset'
  ];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image.asset('assets/logo.png', fit: BoxFit.contain),
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
                        name = s;
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
                    DropdownButton(
                      dropdownColor: Colors.black,
                      value: dropdownvalue,
                      icon: Icon(Icons.arrow_downward, color: Colors.white),
                      iconSize: 20,
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownvalue = newValue;
                        });
                      },
                      items: menu,
                    ),
                    SizedBox(height: 5),
                    Opacity(
                      opacity: (widget.loading) ? 0 : 1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Colors.white,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text('Get Started!',
                              style: TextStyle(color: Colors.black)),
                        )),
                        onPressed: () async {
                          setState(() {
                            widget.loading = true;
                          });
                          FirebaseAuth.instance
                              .signInAnonymously()
                              .then((value) {
                            Map<String, dynamic> idMap = {'Gender': dropdownvalue,
                               'Name': name};
                            FirebaseFirestore.instance
                                .collection(
                                    'user+${FirebaseAuth.instance.currentUser.uid}')
                                .doc('Id')
                                .set(idMap)
                                .then((value) {
                              FirebaseFirestore.instance
                                  .collection(
                                      'user+${FirebaseAuth.instance.currentUser.uid}')
                                  .doc('IncompleteHabits')
                                  .set({'Habits': habitNames}).then((value) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              });
                            });
                          });
                        },
                      ),
                    ),
                    Opacity(
                      opacity: (widget.loading) ? 1 : 0,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    ),
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
