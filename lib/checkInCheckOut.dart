// ignore_for_file: file_names

import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../widgets/bottombar/bottombar.dart';
import 'Transitions/transtest.dart';
import 'login.dart';
import 'no_internet.dart';
import 'service/http_service.dart';
import 'service/storage.dart';

class CheckInCheckOut extends StatefulWidget {
  const CheckInCheckOut({Key? key}) : super(key: key);

  @override
  State<CheckInCheckOut> createState() => _CheckInCheckOutState();
}

class _CheckInCheckOutState extends State<CheckInCheckOut> {
  Duration duration = const Duration();
  String status = 'check_in';
  int level = 0;
  final String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  final TimeOfDay _time_ = TimeOfDay.now();
  String name = '';
  Timer? timer;
  bool lodaing = true;
  final x = false;
  void stoptimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void addTime() {
    const addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      duration = Duration(seconds: seconds);
    });
  }

  FutureOr update() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    var res = await HttpService().checkInCheckOut();
    setState(() {
      lodaing = false;
    });
    if (res == true) {
      return true;
    } else {
      return res;
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  getUserName() async {
    String userName = await SecureStirage().readSecureData('name');
    setState(() {
      name = userName;
    });
  }

  checkTimer() async {
    var seconds = await HttpService().checkTimer();
    if (seconds != null && seconds is int) {
      setState(() {
        status = "check_out";
        duration = Duration(seconds: seconds);
      });
      startTimer();
    }
    setState(() {
      lodaing = false;
    });
  }

  check() async {
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 2) {
        checkTimer();
        return setState(() {
          level = response['level'];
        });
      } else {
        await SecureStirage().deleteSecureData('token');
        return Navigator.of(context).push(Bouncy(page: const Login()));
      }
    } else if (response != null && response['error'] == 'user_level_error') {
      await HttpService().logOut();
      return Navigator.of(context).push(Bouncy(page: const Login()));
    } else if (response != null && response['error'] == 'acc_block') {
      await HttpService().logOut();
      return Navigator.of(context).push(Bouncy(page: const Login()));
    } else if (response != null && response['error'] == 'no_token') {
      return Navigator.of(context).push(Bouncy(page: const Login()));
    } else if (response != null && response['error'] == 'no_internet') {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  checkInternet() async {
    var response = await HttpService().checkInternet();
    if (response != null && response == false) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  @override
  void initState() {
    check();
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var appbar = AppBar(
      backgroundColor: Color.fromARGB(255, 207, 177, 43),
      automaticallyImplyLeading: false,
      leading: Icon(
        Icons.watch_later_outlined,
        size: MediaQuery.of(context).size.height * 0.04,
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
            "${_time_.hour < 10 ? "0${_time_.hour}" : _time_.hour}:${_time_.minute < 10 ? "0${_time_.minute}" : _time_.minute}"),
      ),
      actions: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.of(context).size.width * 0.040,
            ),
            child: Text(
              name,
              style: const TextStyle(fontFamily: 'Tajawal', fontSize: 17),
            ),
          ),
        )
      ],
    );
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          bottomNavigationBar: BottomNavBar(
            currentTab: 2,
            level: level,
          ),
          appBar: appbar,
          backgroundColor: Colors.white,
          body: lodaing == true
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/gvoldenblack.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: Colors.yellow,
                      size: 45,
                    ),
                  ))
              : SafeArea(
                  child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/gvoldenblack.jpg"),
                        fit: BoxFit.cover),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.001,
                            right: MediaQuery.of(context).size.width * 0.20,
                            top: 30,
                            bottom: 30),
                        child: Image.asset(
                          "images/newlogo1.png",
                          width: 200.0,
                          height: 200.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'الوقت',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Tajawal',
                                            fontSize: 18),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Icon(
                                            Icons.timer,
                                            color: Colors.white,
                                            size: 25,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  BullidTime(),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      status == 'check_out'
                                          ? Colors.red
                                          : Colors.grey),
                                ),
                                onPressed: () async {
                                  if (status == 'check_out') {
                                    var check = await update();
                                    if (check == true) {
                                      stoptimer();
                                      setState(() {
                                        duration = const Duration(seconds: 0);
                                      });
                                      setState(() {
                                        status = 'check_in';
                                      });
                                    } else {
                                      return showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: check,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  "تسجيل الخروج",
                                  style: TextStyle(
                                    fontFamily: 'tajawal',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Container(
                            child: Column(children: [
                              Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'التاريخ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Tajawal',
                                            fontSize: 18),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 10, bottom: 8),
                                          child: Icon(
                                            Icons.date_range,
                                            color: Colors.white,
                                            size: 25,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    date,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'Tajawal',
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      status == 'check_in'
                                          ? Colors.lightGreen
                                          : Colors.grey),
                                ),
                                onPressed: () async {
                                  if (status == 'check_in') {
                                    var check = await update();
                                    if (check == true) {
                                      startTimer();
                                      setState(() {
                                        status = 'check_out';
                                      });
                                    } else {
                                      return showTopSnackBar(
                                        context,
                                        CustomSnackBar.error(
                                          message: check,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontFamily: 'tajawal',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ]),
                          )
                        ],
                      ),
                    ],
                  ),
                ))),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BullidTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(16));

    return Text(
      "$hours:$minutes:$seconds",
      style:
          TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 18),
    );
  }
}
