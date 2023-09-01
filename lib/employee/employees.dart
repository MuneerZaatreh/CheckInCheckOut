// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names

import 'package:checkincheckout/dashbord.dart';
import 'package:checkincheckout/employee/profile.dart';
import 'package:checkincheckout/widgets/interface/employee.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Transitions/transition1.dart';
import '../Transitions/transitionback.dart';
import '../Transitions/transtest.dart';
import '../login.dart';
import '../no_internet.dart';
import '../service/http_service.dart';
import '../service/storage.dart';
import '../widgets/bottombar/bottombar.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);
  @override
  _EmployeesState createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  final controoler = TextEditingController();
  List<EmployeeInterFace> employees = [];
  List<EmployeeInterFace> employees_for_search = [];

  bool lodaing = true;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  checkInternet() async {
    var response = await HttpService().checkInternet();
    if (response != null && response == false) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  Future getData() async {
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getEmployees();

    List<EmployeeInterFace> __employees__ = [];
    if (response != null && response != false) {
      for (var _employee_ in response) {
        EmployeeInterFace employee = EmployeeInterFace(
            name: _employee_['name'],
            phone: _employee_['phone'],
            id: _employee_['_id'],
            status: _employee_['isActive']);
        __employees__.add(employee);
      }
    }
    if (mounted) {
      setState(() {
        employees = __employees__;
        employees_for_search = __employees__;
        lodaing = false;
      });
    }
  }

  check() async {
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 1) {
        await getData();
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
                  currentTab: 2,
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
                                                  Navigator.of(context).push(
                                                      EnterExitRouteBack(
                                                          enterPage: Dashbord(),
                                                          exitPage:
                                                              Employees()));
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
                                            'الموظفين',
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
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Container(
                            margin: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.03),
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  onChanged: searchEmployee,
                                  controller: controoler,
                                  decoration: InputDecoration(
                                      hintTextDirection: TextDirection.rtl,
                                      prefixIcon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                      ),
                                      hintText: 'بحث....',
                                      hintStyle:
                                          const TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                      prefixIconColor: Colors.white,
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                              color: Colors.blue))),
                                  style: const TextStyle(color: Colors.white),
                                )),
                          ),
                          Expanded(
                              child: ListView.builder(
                            itemCount: employees_for_search.length,
                            itemBuilder: (context, index) {
                              final employee = employees_for_search[index];

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(EnterExitRoute(
                                        enterPage: EmployeeProfile(
                                          id: employee.id,
                                        ),
                                        exitPage: const Employees()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.phone,
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(employee.phone),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: Row(
                                                children: [
                                                  Text(employee.name),
                                                  const Icon(
                                                    Icons.person,
                                                    color: Colors.black,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            employee.status == 1
                                                ? Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                        color: Colors.green),
                                                  )
                                                : Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                    decoration: const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10.0),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10.0)),
                                                        color: Colors.red),
                                                  ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                            },
                          ))
                        ],
                      )),
                ),
              ));
  }

  void searchEmployee(String query) {
    final suggestions = employees.where((employee) {
      final name = employee.name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();
    setState(() {
      employees_for_search = suggestions;
    });
  }
}
