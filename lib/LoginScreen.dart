import 'package:habit_21_2/Data.dart' ;
import 'package:habit_21_2/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatelessWidget {
  String name;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> habitNames=['Happiness','Exercise','No Junk Food','Study','Sleep','Positive Mindset'];

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
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      color: Colors.white,
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Get Started!',
                            style: TextStyle(color: Colors.black)),
                      )),
                      onPressed: ()  {
                        FirebaseAuth.instance.signInAnonymously().then((value) {
                          Map<String,dynamic> idMap={'Name': name};
                          FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc('Id').set(idMap)
                              .then((value) {
                                FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc('IncompleteHabits').set({'Habits':habitNames})
                                .then((value) {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));print(FirebaseAuth.instance.currentUser.uid);
                                });
                              } );
                        }
                        );
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
