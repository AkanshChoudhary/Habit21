import 'package:habit_21_2/DayTask.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_21_2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar extends StatefulWidget {
  int index;
  String custName;

  Calendar(this.index, this.custName);

  List<dynamic> completedDays = new List();
  dynamic startDate;
  bool notStarted = false;
  var now = DateTime.now();

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: (widget.index != -1)
            ? Text(titles.elementAt(widget.index))
            : Text(widget.custName),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                            (widget.index != -1)
                                ? 'assets/${images.elementAt(widget.index)}'
                                : 'assets/sketch.svg',
                            fit: BoxFit.contain),
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Opacity(
                    opacity: (widget.notStarted) ? 1.0 : 0.0,
                    child: Center(
                        child: RaisedButton(
                          onPressed: () {
                            (widget.index!=-1)?
                            FirebaseFirestore.instance
                                .collection(
                                'user+${FirebaseAuth.instance.currentUser.uid}')
                                .doc('IncompleteHabits')
                                .update({
                              'Habits': FieldValue.arrayRemove(
                                  [titles.elementAt(widget.index) as dynamic])
                            }).then((value) {
                              String date =
                                  '${widget.now.year}-${widget.now.month}-${widget.now.day}';
                              List<int> numbers = [0];
                              Map<String, dynamic> startMap = {
                                'StartDate': date,
                                'CompletedDays': numbers
                              };
                              FirebaseFirestore.instance
                                  .collection(
                                  'user+${FirebaseAuth.instance.currentUser.uid}')
                                  .doc(titles.elementAt(widget.index))
                                  .set(startMap)
                                  .then((value) {
                                setState(() {
                                  widget.notStarted = false;
                                  widget.completedDays.add(0);
                                });
                              });
                            })
                                :FirebaseFirestore.instance
                                .collection(
                                'user+${FirebaseAuth.instance.currentUser.uid}')
                                .doc('IncompleteHabits')
                                .update({
                              'IncompleteCustomHabits': FieldValue.arrayRemove(
                                  [widget.custName as dynamic])
                            }).then((value) {
                              String date =
                                  '${widget.now.year}-${widget.now.month}-${widget.now.day}';
                              List<int> numbers = [0];
                              FirebaseFirestore.instance
                                  .collection('user+${FirebaseAuth.instance.currentUser.uid}')
                                  .doc('CustomHabits')
                                  .collection(widget.custName)
                                  .doc('details')
                                  .update({'CompletedDays':numbers,'StartDate':date})
                                  .then((value) {
                                setState(() {
                                  print('done');
                                  widget.notStarted = false;
                                  widget.completedDays.add(0);
                                });
                              });
                            });
                          },
                          color: Colors.red,
                          child: Text(
                            'Start Habit',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(
                  21,
                      (index) => GestureDetector(
                    onTap: () {
                      (widget.notStarted)
                          ? showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Ok',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                            title: Text(
                                'Please start the habit to view the task'),
                          ))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>(widget.index!=-1)? DayTask(
                                index + 1,
                                titles.elementAt(widget.index),
                                widget.completedDays,false)
                                :DayTask(
                                index + 1,
                                widget.custName,
                                widget.completedDays,true),
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
              ))
        ],
      ),
    ) , onWillPop: (){return Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));});
  }

  @override
  void initState() {
    if (widget.index != -1) {
      FirebaseFirestore.instance
          .collection('user+${FirebaseAuth.instance.currentUser.uid}')
          .doc(titles.elementAt(widget.index))
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('user+${FirebaseAuth.instance.currentUser.uid}')
            .doc('IncompleteHabits')
            .get()
            .then((incompleteData) {
          Map<dynamic, dynamic> habitMap = value.data();
          Map<dynamic, dynamic> incompleteMap = incompleteData.data();
          List<dynamic> incompleteHabitList = incompleteMap['Habits'];
          bool status =
              incompleteHabitList.contains(titles.elementAt(widget.index));
          setState(() {
            widget.notStarted = status;
            if (habitMap != null) {
              widget.completedDays = habitMap['CompletedDays'];
              widget.startDate = habitMap['StartDate'];
            }
            print('done');
          });
        });
      });
    } else {
      FirebaseFirestore.instance
          .collection('user+${FirebaseAuth.instance.currentUser.uid}')
          .doc('IncompleteHabits')
          .get()
          .then((value) {
        FirebaseFirestore.instance
            .collection('user+${FirebaseAuth.instance.currentUser.uid}')
            .doc('CustomsHabits')
            .collection(widget.custName)
            .doc('details')
            .get()
            .then((value2) {
          List<dynamic> incompleteCustHabits =
              value.data()['IncompleteCustomHabits'];
          bool status = incompleteCustHabits.contains(widget.custName);
          setState(() {
            widget.notStarted = status;
            if (value2.data() != null) {
              widget.startDate = ['StartDate'];
              widget.completedDays = ['CompletedDays'];
            }
          });
        });
      });
    }
  }
}
