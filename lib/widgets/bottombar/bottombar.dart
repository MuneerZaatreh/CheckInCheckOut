// ignore_for_file: must_be_immutable

import 'package:checkincheckout/dashbord.dart';
import 'package:checkincheckout/workDays.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Transitions/transition3.dart';
import '../../login.dart';
import '../../service/http_service.dart';

class BottomNavBar extends StatefulWidget {
  int currentTab;
  int level;
  BottomNavBar({Key? key, required this.currentTab, required this.level})
      : super(key: key);
  @override
  BottomNavBarState createState() => BottomNavBarState(currentTab, level);
}

class BottomNavBarState extends State<BottomNavBar> {
  int currentTab;
  int level;
  BottomNavBarState(this.currentTab, this.level);
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 25,
      color: Color.fromARGB(255, 23, 19, 4),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            MaterialButton(
              minWidth: 30,
              onPressed: () {
                if (level == 1 && currentTab != 1) {
                  Navigator.of(context)
                      .push(ScaleRoute(page: const WorkDays()));
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 60),
                child: Icon(
                  Icons.file_copy,
                  color: currentTab == 1
                      ? Color.fromARGB(255, 207, 177, 43)
                      : Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            MaterialButton(
              child: Icon(
                Icons.home,
                size: 35,
                color: currentTab == 2
                    ? Color.fromARGB(255, 207, 177, 43)
                    : Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                // if (currentTab != 2) {
                Navigator.of(context).push(ScaleRoute(page: const Dashbord()));
                // }
              },
            ),
            MaterialButton(
              minWidth: 60,
              onPressed: () async {
                var res = await HttpService().logOut();
                if (res == true) {
                  Navigator.of(context).push(ScaleRoute(page: const Login()));
                } else {
                  return showTopSnackBar(
                    context,
                    const CustomSnackBar.error(
                      message: "يوجد خطأ ارجو المحاولة من جديد",
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: Icon(
                  Icons.logout_outlined,
                  size: 35,
                  color: currentTab == 3
                      ? Color.fromARGB(255, 207, 177, 43)
                      : Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
