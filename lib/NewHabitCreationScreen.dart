import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_21_2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateHabit extends StatelessWidget {
  String habitName;
  String taskDescription;
  CreateHabit(this.habitName);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child:Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder:(context)=>HomeScreen()));},child: Icon(Icons.arrow_back,color: Colors.white,),),
        title: Text(habitName),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SvgPicture.asset(
                  'assets/sketch.svg',
                  fit: BoxFit.contain,
                ),
              )),
          Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(
                  21,
                      (index) => GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  print(index+1);
                                  FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc('CustomHabits')
                                      .collection(habitName).doc('details')
                                      .update({'Task ${index+1}':taskDescription})
                                      .then((value) {
                                    Navigator.pop(context);
                                  });
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                            backgroundColor: Colors.white,
                            content: TextField(
                              onChanged: (String n) {
                                taskDescription = n;
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                  hintText: 'Enter Task',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.black),
                                  ),
                                  hintStyle:
                                  TextStyle(color: Colors.black)),
                              keyboardType: TextInputType.multiline,
                              maxLines: 10,
                              minLines: 1,
                            ),
                          ));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Card(
                        color: Colors.white,
                        child: Center(
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    ) ,onWillPop: (){
      return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    },);

  }
}