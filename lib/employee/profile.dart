// ignore_for_file: no_logic_in_create_state, must_be_immutable, unrelated_type_equality_checks
import 'package:checkincheckout/employee/employees.dart';
import 'package:checkincheckout/widgets/ChangePassword.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../Transitions/transitionback.dart';
import '../Transitions/transtest.dart';
import '../login.dart';
import '../no_internet.dart';
import '../service/http_service.dart';
import '../service/storage.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/bottombar/bottombar.dart';
import './edit.dart';

class EmployeeProfile extends StatefulWidget {
  String id;
  EmployeeProfile({Key? key, required this.id}) : super(key: key);

  @override
  State<EmployeeProfile> createState() => _EmployeeProfileState(id);
}

class _EmployeeProfileState extends State<EmployeeProfile> {
  String id;
  bool lodaing = true;
  Employee employee = const Employee(
      date: "", name: "", numberOfWorkDays: 0, phone: "", status: "");
  _EmployeeProfileState(this.id);

  get elevation => null;

  get child => null;
  getEmployessInfo() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getEmployeeInfo(id);
    if (response != null && response != false) {
      setState(() {
        employee = Employee(
            date: response['date'],
            name: response['name'],
            numberOfWorkDays: response['numberOfWorkDays'],
            status: response['status'],
            phone: response['phone']);
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
        await getEmployessInfo();
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
    if (lodaing == true) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: Container(
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
                ))),
      );
    } else {
      return Scaffold(
          bottomNavigationBar: BottomNavBar(
            currentTab: 2,
            level: 1,
          ),
          body: SafeArea(
            child: Center(
              child: Container(
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
                                              Navigator.of(context)
                                                  .push(EnterExitRouteBack(
                                                      enterPage: Employees(),
                                                      exitPage: EmployeeProfile(
                                                        id: id,
                                                      )));
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
                                child: const Padding(
                                    padding: EdgeInsets.all(35),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        'الملف الشخصي',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 26,
                                            fontFamily: 'Tajawal'),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 10, 40, 0),
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
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'الاسم',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                employee.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                '------------------------------------------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20, top: 40),
                              child: Text(
                                '   رقم الهاتف  ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                employee.phone,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                ' ------------------------------------------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Text(
                                'حالة الحساب',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                employee.status,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: employee.status == 'غير نشط'
                                      ? const Color.fromARGB(255, 219, 0, 0)
                                      : Colors.green,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                ' ------------------------------------------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20, top: 40),
                              child: Text(
                                'تاريخ بدأ العمل في الشركة',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                employee.date,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                ' ------------------------------------------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 20, top: 40),
                              child: Text(
                                'عدد ايام العمل الى الان',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.03,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 7),
                              child: Text(
                                '${employee.numberOfWorkDays}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(
                                '------------------------------------------',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  RawMaterialButton(
                                    onPressed: () async {
                                      final action =
                                          await AlertDialogs.yesCancelDialog(
                                              context,
                                              employee.status == 'نشط'
                                                  ? 'تجميد الحساب'
                                                  : 'الغاء تجميد الحساب',
                                              'هل انت متاكد؟');
                                      if (action == DialogsAction.yes) {
                                        setState(() {
                                          lodaing = true;
                                        });
                                        var response = await HttpService()
                                            .changeStatusEmployee(id);
                                        if (response != null &&
                                            response == true) {
                                          getEmployessInfo();
                                          return showTopSnackBar(
                                            context,
                                            const CustomSnackBar.success(
                                              message: "تم تغيير حالة الحساب",
                                            ),
                                          );
                                        } else {
                                          setState(() {
                                            lodaing = false;
                                          });
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
                                    elevation: 2.0,
                                    fillColor: employee.status == 'نشط'
                                        ? Colors.red
                                        : Colors.green,
                                    child: Icon(
                                      employee.status == 'نشط'
                                          ? Icons.close
                                          : Icons.done,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      print(id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditEmployee(id: id)));
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.green,
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () async {
                                      final action =
                                          await AlertDialogs.yesCancelDialog(
                                              context,
                                              'حذف مستخدم',
                                              'هل انت متاكد؟');
                                      if (action == DialogsAction.yes) {
                                        setState(() {
                                          lodaing = true;
                                        });
                                        var response = await HttpService()
                                            .deleteEmployee(id);
                                        if (response != null &&
                                            response == true) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Employees()));
                                        } else {
                                          setState(() {
                                            lodaing = false;
                                          });
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
                                    elevation: 2.0,
                                    fillColor:
                                        const Color.fromARGB(255, 255, 0, 0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                  ),
                                  RawMaterialButton(
                                    onPressed: () {
                                      print(id);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ChangePassword(id: id)));
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.yellow,
                                    child: const Icon(
                                      Icons.lock,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      size: 20.0,
                                    ),
                                    padding: const EdgeInsets.all(15.0),
                                    shape: const CircleBorder(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ));
    }
  }
}

@immutable
class Employee {
  final String name;
  final String phone;
  final String date;
  final String status;
  final int numberOfWorkDays;
  const Employee({
    required this.name,
    required this.phone,
    required this.date,
    required this.status,
    required this.numberOfWorkDays,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      name: json['name'] as String,
      phone: json['phone'] as String,
      date: json['date'] as String,
      status: json['status'] as String,
      numberOfWorkDays: json['numberOfWorkDays'] as int,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          phone == other.phone &&
          date == other.date &&
          status == other.status &&
          numberOfWorkDays == other.numberOfWorkDays;

  @override
  int get hashCode =>
      phone.hashCode ^
      name.hashCode ^
      date.hashCode ^
      status.hashCode ^
      numberOfWorkDays.hashCode;
}
