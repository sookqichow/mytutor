import 'package:flutter/material.dart';
import 'package:mytutor/views/tabsSubject.dart';
import 'package:mytutor/views/tabsTutors.dart';
import '../models/user.dart';

class MainScreen extends StatefulWidget {
  final User user;
  
 const MainScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs = <Widget>[];
   String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabs = [
     TabsSubjects(user:widget.user),
      TabsTutors(),
      // TabsTutors(),
      // TabsTutors(),
      // TabsTutors(),
    ];
  }

  onTapped(int currentIndex) {
    setState(() {
     _selectedIndex= currentIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }return Scaffold(
      
     body: tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.subject),
            label: "Subjects",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school, ),
            label: "Tutors",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.subscriptions, ),
            label: "Subscription",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star, ),
            label:"Favourite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, ),
            label: "Profile",
          )
        ],
         onTap: onTapped,
        currentIndex: _selectedIndex,
      ),
    );
  }
  }