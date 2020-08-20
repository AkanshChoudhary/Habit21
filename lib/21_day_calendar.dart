import 'package:habit_21_1/dayTask.dart';
import 'package:flutter/material.dart';
import 'habit_name.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Calendar extends StatelessWidget {
  int index;

  Calendar(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(titles.elementAt(index)),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Center(
                child: SvgPicture.asset('assets/${images.elementAt(index)}',
                    fit: BoxFit.contain)),
          ),
          Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                children: List.generate(
                  21,
                  (index) => GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => DayTask(index+1))
                      );
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
}
