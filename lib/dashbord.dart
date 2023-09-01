import 'package:checkincheckout/checkInCheckOut.dart';
import 'package:checkincheckout/employee/employees.dart';
import 'package:checkincheckout/extrahours.dart';
import 'package:checkincheckout/service/http_service.dart';
import 'package:checkincheckout/service/storage.dart';
import 'package:checkincheckout/workDays.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'Transitions/transition1.dart';
import 'Transitions/transtest.dart';
import 'employee/new.dart';
import 'employee/workMonth.dart';
import 'login.dart';
import 'no_internet.dart';

class Dashbord extends StatefulWidget {
  const Dashbord({Key? key}) : super(key: key);

  @override
  State<Dashbord> createState() => _DashbordState();
}

class _DashbordState extends State<Dashbord> {
  int level = 2;
  bool lodaing = true;
  check() async {
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (mounted) {
        setState(() {
          level = response['level'];
        });
      }
    } else if (response != null && response['error'] == 'user_level_error') {
      await SecureStirage().deleteSecureData('token');
      return Navigator.of(context).push(Bouncy(page: const Login()));
    } else if (response != null && response['error'] == 'no_token') {
      return Navigator.of(context).push(Bouncy(page: const Login()));
    } else if (response != null && response['error'] == 'no_internet') {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
    if (mounted) {
      setState(() {
        lodaing = false;
      });
    }
  }

  @override
  void initState() {
    check();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: lodaing == true
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
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/gvoldenblack.jpg"),
                      fit: BoxFit.cover),
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.04,
                        right: MediaQuery.of(context).size.width * 0.20,
                        top: 60,
                      ),
                      child: Image.asset(
                        "images/newlogo1.png",
                        width: 250.0,
                        height: 250.0,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    Center(
                      child: level == 2
                          ? Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: Wrap(
                                spacing:
                                    MediaQuery.of(context).size.width * 0.05,
                                runSpacing:
                                    MediaQuery.of(context).size.height * 0.05,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: CheckInCheckOut()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.watch_later_outlined,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            "تسجيل دخول او خروج",
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: WorkMonth()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.file_copy,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            "ساعات العمل",
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02,
                              ),
                              child: Wrap(
                                spacing:
                                    MediaQuery.of(context).size.width * 0.05,
                                runSpacing:
                                    MediaQuery.of(context).size.height * 0.05,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: Employees()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.people,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            'الموظفين',
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: ExtraHour()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.people,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            "اضافة ساعات",
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: NewEmployee()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.person_add_alt,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            "اضافة عامل جديد",
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        fixedSize:
                                            MaterialStateProperty.all(Size(
                                          MediaQuery.of(context).size.width *
                                              0.45,
                                          MediaQuery.of(context).size.height *
                                              0.16,
                                        )),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    230, 255, 235, 59)),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            EnterExitRoute(
                                                exitPage: Dashbord(),
                                                enterPage: WorkDays()));
                                      },
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.watch_later_outlined,
                                              color: Colors.black),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          const Text(
                                            'أيام عمل الموظفين',
                                            style: TextStyle(
                                                fontFamily: 'tajawal',
                                                color: Colors.black),
                                            textDirection: TextDirection.rtl,
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
