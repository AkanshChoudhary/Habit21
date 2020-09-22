import 'package:habit_21_1/DayTask.dart';
import 'package:flutter/material.dart';
import 'Data.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Calendar extends StatefulWidget {
  int index;

  Calendar(this.index);

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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(titles.elementAt(widget.index)),
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
                      child: SvgPicture.asset(
                          'assets/${images.elementAt(widget.index)}',
                          fit: BoxFit.contain)),
                ),
                Expanded(
                  flex: 1,
                  child: Opacity(
                    opacity: (widget.notStarted) ? 1.0 : 0.0,
                    child: Center(
                        child: RaisedButton(
                      onPressed: () {
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
                      (widget.notStarted)?
                      showDialog(context: context,builder: (_)=> AlertDialog(
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
                          title: Text('Please start the habit to view the task'),
                      )):
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DayTask(
                                  index + 1,
                                  titles.elementAt(widget.index),
                                  widget.completedDays),
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
    );
  }

  @override
  void initState() {
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
  }
}
