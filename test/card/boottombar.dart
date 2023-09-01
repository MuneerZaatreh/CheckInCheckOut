// ignore_for_file: file_names, must_be_immutable, unnecessary_this, no_logic_in_create_state
import 'package:checkincheckout/Transitions/transition2.dart';
import 'package:checkincheckout/dashbord.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  int currentTab;
  BottomNavBar({Key? key, required this.currentTab}) : super(key: key);
  @override
  BottomNavBarState createState() => BottomNavBarState(this.currentTab);
}

class BottomNavBarState extends State<BottomNavBar> {
  int currentTab;
  BottomNavBarState(this.currentTab);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    Navigator.of(context).push(AnimatedRoute(const Dashbord()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.dashboard,
                        color: currentTab == 0 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'الرئيسية',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: currentTab == 0 ? Colors.blue : Colors.grey),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    Navigator.of(context).push(AnimatedRoute(const Dashbord()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people,
                        color: currentTab == 1 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'زباين',
                        style: TextStyle(
                            fontFamily: 'Tajawal',
                            color: currentTab == 1 ? Colors.blue : Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
            //Right Tab bar icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    Navigator.of(context).push(AnimatedRoute(const  Dashbord()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_alt,
                        color: currentTab == 2 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'الحلقين',
                        style: TextStyle(
                            color: currentTab == 2 ? Colors.blue : Colors.grey),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  minWidth: 40,
                  onPressed: () {
                    Navigator.of(context).push(AnimatedRoute(const Dashbord()));
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.file_copy,
                        color: currentTab == 3 ? Colors.blue : Colors.grey,
                      ),
                      Text(
                        'الطلبات',
                        style: TextStyle(
                            color: currentTab == 3 ? Colors.blue : Colors.grey),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
