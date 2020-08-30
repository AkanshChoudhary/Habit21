import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_21_2/main.dart';

class CreateHabit extends StatelessWidget {
  String habitName;
  String taskDescription;

  CreateHabit(this.habitName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
                            actions: [ FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.blue),
                                )),
                              FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.blue),
                                  )),

                            ],
                                backgroundColor: Colors.white,
                                content: TextField(
                                  onChanged: (String n) {
                                    taskDescription = n;
                                  },
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: 'Enter new task name',
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                      hintStyle: TextStyle(color: Colors.black)),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 15,
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
    );
  }
}
