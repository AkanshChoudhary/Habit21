import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habit_21_2/main.dart';

class DayTask extends StatefulWidget {
  int index;
  String habitName;
  bool isCustom;
  List<dynamic> completedDays;
  String taskDes=" ";
  DayTask(this.index,this.habitName,this.completedDays,this.isCustom);
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
              child: (widget.taskDes!=" ")?Text(widget.taskDes,
                  style: TextStyle(color: Colors.white)):CircularProgressIndicator(backgroundColor: Colors.black,),
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
                          if(!widget.isCustom){
                            FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc(widget.habitName).update({'CompletedDays': FieldValue.arrayUnion([widget.index as dynamic])}).then((value) {
                              setState(() {
                                widget.completedDays.add(widget.index);
                              });
                            });
                          }else{
                            FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc('CustomHabits').collection(widget.habitName)
                                .doc('details').update({'CompletedDays':FieldValue.arrayUnion([widget.index as dynamic])})
                                .then((value){
                                setState(() {
                                widget.completedDays.add(widget.index);
                              });
                            } );
                          }
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
  @override
  void initState() {
    super.initState();
    if(widget.isCustom==true)
      {
        print(widget.habitName);
        print('Task ${widget.index}');
        FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser.uid}').doc('CustomHabits').collection(widget.habitName)
            .doc('details').get()
            .then((det) {
              print(det.data());
              setState(() {
                widget.taskDes=det.data()['Task ${widget.index}'];
              });
        });
      }
  }
}