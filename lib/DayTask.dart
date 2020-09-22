import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DayTask extends StatefulWidget {
  int index;
  String habitName;
  List<dynamic> completedDays;

   DayTask(this.index,this.habitName,this.completedDays);

  @override
  _DayTaskState createState() => _DayTaskState();
}

class _DayTaskState extends State<DayTask> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Day ${widget.index}'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Center(
              child: Text('Task Description',
              style: TextStyle(color: Colors.white)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40,15,40,15),
                    child: Opacity(
                      opacity: (widget.completedDays.contains(widget.index))?0:1,
                      child: RaisedButton(
                        child: Text('Task completed!',style: TextStyle(color: Colors.white),),
                          color: Colors.red,
                          onPressed: (){
                          FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc(widget.habitName).update({'CompletedDays': FieldValue.arrayUnion([widget.index as dynamic])}).then((value) {
                            setState(() {
                              widget.completedDays.add(widget.index);
                            });
                          });
                          },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Opacity(
                      opacity: (widget.completedDays.contains(widget.index))?1:0,
                      child: Icon(
                        Icons.check,size: 30,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
