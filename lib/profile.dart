import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatefulWidget {
  String name;
  dynamic gender;
  int index;
  List<dynamic> allIncompleteHabits = new List();

  Profile(this.name, this.gender, this.allIncompleteHabits);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.red,
        ),
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.red,
                child: Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Center(
                            child: SvgPicture.asset(
                              (widget.gender == 'Male')
                                  ? 'assets/person.svg'
                                  : 'assets/woman.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: Text('${widget.name}')),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Center(
                              child: Text(
                            'Not started habits:',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          )),
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
                margin: EdgeInsets.only(top: 200),
                child: ListView.separated(
                    padding: const EdgeInsets.all(10),
                    itemCount: widget.allIncompleteHabits.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 50,
                        color: Colors.white,
                        child: Center(
                          child: Text('${widget.allIncompleteHabits[index]}'),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider()),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Icon(Icons.email),
                      content: Text('Email us your queries at: \n\nakanshchoudhary79@gmail.com\nmbhatt2615@gmail.com',style: TextStyle(fontSize: 15),),
                      ),
                    );
          },
          child: Icon(Icons.help),
          backgroundColor: Colors.red,
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
