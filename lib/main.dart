import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:habit_21_1/DayCalendar.dart';
import 'package:habit_21_1/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:habit_21_1/NewHabitCreationScreen.dart';
import 'package:habit_21_1/profile.dart';
import 'Data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    ));
     }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    User user=FirebaseAuth.instance.currentUser;
    if (user==null){
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }
     else
       {
         Timer(
             Duration(seconds: 3),
                 () => Navigator.pushReplacement(
                 context, MaterialPageRoute(builder: (context) => HomeScreen())));
       }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset(
          'assets/logo.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  String name;
  String userId;
  dynamic gender;
  List<String> custom=new List();
  List<dynamic> allCustomHabits=new List();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  @override
  void initState() {
    FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser
        .uid}').doc('Id').get().then((value) {
      Map <dynamic,dynamic> idMap= value.data();
      setState(() {
        widget.gender=idMap['Gender'];
        widget.name=idMap['Name'];
        if(idMap['Allcustomhabits']!=null)
          {
            widget.allCustomHabits=idMap['Allcustomhabits'];
          }

      });
    });
    // TODO: implement initState
    super.initState();
  }
  void _onItemSelected(int _newIndex) {
    String habitName;
    if(_newIndex==0)
      {
        showDialog(context: context, builder: (_)=>AlertDialog(
          backgroundColor: Colors.white,
          content: TextField(
            onChanged: (String m) {
            habitName = m;
            },
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
                hintText: 'Enter Habit Name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle: TextStyle(color: Colors.black)),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text('Cancel',style: TextStyle(color: Colors.blue),),
            ),
            FlatButton(
              onPressed: (){
                widget.custom.add(habitName);
                setState(() {
                  widget.allCustomHabits.add(habitName);
                });
                Map<dynamic,dynamic> idMap={'Allcustomhabits' : widget.allCustomHabits};
                Map<String, dynamic> customMap = {'IncompleteCustomHabits': widget.custom};
                FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser
                    .uid}').doc('IncompleteHabits').set(customMap).then((value){
                      FirebaseFirestore.instance.collection('user+${FirebaseAuth.instance.currentUser
                          .uid}').doc('Id').set(idMap).then((value) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CreateHabit.newhabit(habitName)));
                      });
                });
              },
              child: Text('Save',style: TextStyle(color: Colors.blue),),
            ),
          ],
        ));
      }
    else if(_newIndex==1){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Profile()));
    }
    setState(() {
      _selectedIndex = _newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.red,
                child: Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                'Hey there ${widget.name}!',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SvgPicture.asset(
                          (widget.gender=='Male')?'assets/person.svg':'assets/woman.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
                height: 300,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Container(
                child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(
                        6+widget.allCustomHabits.length,
                        (index) => GestureDetector(
                              onTap: () {
                                (index<6)?Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Calendar(index))):showDialog(context: context, builder: (_)=>AlertDialog(
                                  backgroundColor: Colors.white,
                                  content: Text('Please select where you want to go',style: TextStyle(color: Colors.black),),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: (){

                                      },
                                      child: Text('View Task',style: TextStyle(color: Colors.blue),),
                                    ),
                                    FlatButton(
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute( builder: (context) => CreateHabit()));
                                      },
                                      child: Text('Edit custom habit',style: TextStyle(color: Colors.blue),),
                                    ),
                                  ],
                                ));

                              },
                              child: Opacity(
                                opacity: 0.9,
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: Card(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: SvgPicture.asset(
                                                  (index<6)?'assets/${images.elementAt(index)}':'assets/sketch.svg',
                                                  fit: BoxFit.contain),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(2),
                                              child: Text(
                                                  (index<6)?titles.elementAt(index):widget.allCustomHabits.elementAt(index-6),
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ))),
                margin: EdgeInsets.only(top: 200),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.red,
          backgroundColor: Color(0xFF3e3636),
          currentIndex: _selectedIndex,
          onTap: _onItemSelected,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Add'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
