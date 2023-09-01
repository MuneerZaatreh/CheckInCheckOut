// ignore_for_file: no_logic_in_create_state, non_constant_identifier_names

import 'package:checkincheckout/service/http_service.dart';
import 'package:checkincheckout/service/storage.dart';
import 'package:checkincheckout/widgets/alert_dialog.dart';
import 'package:checkincheckout/workDays.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'Transitions/transition1.dart';
import 'Transitions/transtest.dart';
import 'dashbord.dart';
import 'login.dart';
import 'no_internet.dart';
import 'widgets/bottombar/bottombar.dart';

// ignore: must_be_immutable
class EditDate extends StatefulWidget {
  String id;
  EditDate({Key? key, required this.id}) : super(key: key);

  @override
  State<EditDate> createState() => _EditDateState(id);
}

class _EditDateState extends State<EditDate> {
  TimeOfDay check_in_one = const TimeOfDay(hour: 15, minute: 30);
  TimeOfDay check_out_one = const TimeOfDay(hour: 15, minute: 30);
  TimeOfDay check_in_two = const TimeOfDay(hour: 15, minute: 40);
  TimeOfDay check_out_two = const TimeOfDay(hour: 15, minute: 30);
  TimeOfDay check_in_three = const TimeOfDay(hour: 15, minute: 30);
  TimeOfDay check_out_three = const TimeOfDay(hour: 15, minute: 30);
  bool lodaing = true;
  String id;
  String date = '';

  _EditDateState(this.id);

  submit() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });

    var response = await HttpService().editDate(
        id,
        check_in_one.to24hours(),
        check_out_one.to24hours(),
        check_in_two.to24hours(),
        check_out_two.to24hours(),
        check_in_three.to24hours(),
        check_out_three.to24hours());
    if (response != null && response == true) {
      setState(() {
        lodaing = false;
      });
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: 'تم التعديل  بنجاح',
        ),
      );
      return Navigator.of(context).push(EnterExitRoute(
          enterPage: const WorkDays(), exitPage: EditDate(id: id)));
    } else {
      setState(() {
        lodaing = false;
      });
      return showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: "يوجد خطأ ارجو المحاولة من جديد",
        ),
      );
    }
  }

  getDateInfo() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getDateInfo(id);

    if (response != null && response != false) {
      setState(() {
        check_in_one = TimeOfDay(
            hour: int.parse(response['check_in_one'].split(":")[0]),
            minute: int.parse(
                response['check_in_one'].split(":")[1].split(' ')[0]));
        check_out_one = TimeOfDay(
            hour: int.parse(response['check_out_one'].split(":")[0]),
            minute: int.parse(
                response['check_out_one'].split(":")[1].split(' ')[0]));
        check_in_two = TimeOfDay(
            hour: int.parse(response['check_in_two'].split(":")[0]),
            minute: int.parse(
                response['check_in_two'].split(":")[1].split(' ')[0]));
        check_out_two = TimeOfDay(
            hour: int.parse(response['check_out_two'].split(":")[0]),
            minute: int.parse(
                response['check_out_two'].split(":")[1].split(' ')[0]));
        check_in_three = TimeOfDay(
            hour: int.parse(response['check_in_three'].split(":")[0]),
            minute: int.parse(
                response['check_in_three'].split(":")[1].split(' ')[0]));
        check_out_three = TimeOfDay(
            hour: int.parse(response['check_out_three'].split(":")[0]),
            minute: int.parse(
                response['check_out_three'].split(":")[1].split(' ')[0]));
        date = response['date'];
      });
    }
    setState(() {
      lodaing = false;
    });
  }

  checkInternet() async {
    var response = await HttpService().checkInternet();
    if (response != null && response == false) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  check() async {
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 1) {
        await getDateInfo();
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
          : Scaffold(
              bottomNavigationBar: BottomNavBar(
                currentTab: 1,
                level: 1,
              ),
              body: SafeArea(
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/gvoldenblack.jpg"),
                          fit: BoxFit.cover),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(50.0),
                                    ),
                                    color: Color.fromARGB(255, 207, 177, 43),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                left: 0,
                                child: Container(
                                  color: Color.fromARGB(255, 207, 177, 43),
                                  child: Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                Icons.arrow_back,
                                                color: Colors.white,
                                                size: 30.0,
                                              )))),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 120,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(60.0),
                                    ),
                                    color: Color.fromARGB(255, 207, 177, 43),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.all(35),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03),
                                          child: Text(
                                            'التعديل على الوقت',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26,
                                                fontFamily: 'Tajawal'),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              Positioned(
                                  top: 100,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(40.0),
                                      ),
                                      color: Color.fromARGB(255, 228, 0, 0),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 50,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  date,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                      fontFamily: 'tajawal',
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "1 تسجيل الخروج",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: check_out_one);
                                            if (newTime == null) return;
                                            setState(() {
                                              check_out_one = newTime;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_out_one.hour}:${check_out_one.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        "1 تسجيل الدخول",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime1 =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: check_in_one);
                                            if (newTime1 == null) return;
                                            setState(() {
                                              check_in_one = newTime1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_in_one.hour}:${check_in_one.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "2 تسجيل الخروج",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: check_out_two);
                                            if (newTime == null) return;
                                            setState(() {
                                              check_out_two = newTime;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_out_two.hour}:${check_out_two.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        "2 تسجيل الدخول",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime2 =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime: check_in_two);
                                            if (newTime2 == null) return;
                                            setState(() {
                                              check_in_two = newTime2;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_in_two.hour}:${check_in_two.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text(
                                        "3 تسجيل الخروج",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime3 =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        check_out_three);
                                            if (newTime3 == null) return;
                                            setState(() {
                                              check_out_three = newTime3;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_out_three.hour}:${check_out_three.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text(
                                        "3 تسجيل الدخول",
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'tajawal',
                                          fontSize: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.lightBlue
                                                  .withOpacity(0.9),
                                              fixedSize: Size(
                                                  (MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3.8),
                                                  35)),
                                          onPressed: () async {
                                            TimeOfDay? newTime4 =
                                                await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        check_in_three);
                                            if (newTime4 == null) return;
                                            setState(() {
                                              check_in_three = newTime4;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(7),
                                            child: Text(
                                              '${check_in_three.hour}:${check_in_three.minute}',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Tajawal'),
                                            ),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.lightBlue.withOpacity(0.9),
                                        fixedSize: Size(
                                            (MediaQuery.of(context).size.width /
                                                2.8),
                                            35)),
                                    onPressed: () {
                                      submit();
                                    },
                                    child: Text(
                                      'تعديل',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Tajawal'),
                                    ),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                                  255, 243, 13, 13)
                                              .withOpacity(0.9),
                                          fixedSize: Size(
                                              (MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.8),
                                              35)),
                                      onPressed: () async {
                                        final action =
                                            await AlertDialogs.yesCancelDialog(
                                                context,
                                                'حذف هذه التاريخ',
                                                'هل انت متاكد؟');
                                        if (action == DialogsAction.yes) {
                                          var response = await HttpService()
                                              .deleteDate(id);
                                          if (response != null &&
                                              response == true) {
                                            showTopSnackBar(
                                              context,
                                              const CustomSnackBar.success(
                                                message: "تم الحذف بنجاح",
                                              ),
                                            );
                                            Navigator.of(context).push(
                                                EnterExitRoute(
                                                    enterPage: const Dashbord(),
                                                    exitPage:
                                                        EditDate(id: id)));
                                          } else {
                                            return showTopSnackBar(
                                              context,
                                              const CustomSnackBar.error(
                                                message:
                                                    "يوجد خطأ ارجو المحاولة من جديد",
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(7),
                                        child: Text(
                                          'حذف',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Tajawal'),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
    );
  }
}

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = this.minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
