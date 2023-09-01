// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names
import 'package:checkincheckout/editdate.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Transitions/transition1.dart';
import '../Transitions/transtest.dart';
import '../login.dart';
import '../no_internet.dart';
import '../service/http_service.dart';
import '../service/storage.dart';
import '../widgets/bottombar/bottombar.dart';
import 'widgets/interface/dateInterface.dart';

class WorkDays extends StatefulWidget {
  const WorkDays({Key? key}) : super(key: key);
  @override
  _WorkDaysState createState() => _WorkDaysState();
}

class _WorkDaysState extends State<WorkDays> {
  final controoler = TextEditingController();
  List<DateInterFace> dates = [];
  List<DateInterFace> dates_for_search = [];

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
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getDates();

    List<DateInterFace> __dates__ = [];
    if (response != null && response != false) {
      for (var _date_ in response) {
        DateInterFace date = DateInterFace(
          name: _date_['name'],
          date: _date_['date'],
          id: _date_['_id'],
        );
        __dates__.add(date);
      }
    }
    if (mounted) {
      setState(() {
        dates = __dates__;
        dates_for_search = __dates__;
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
      await SecureStirage().deleteSecureData('token');
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
                                    child: const Padding(
                                        padding: EdgeInsets.all(35),
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            'أيام عمل الموظفين',
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
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  onChanged: searchdate,
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
                            itemCount: dates_for_search.length,
                            itemBuilder: (context, index) {
                              final date = dates_for_search[index];

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(EnterExitRoute(
                                        enterPage: EditDate(
                                          id: date.id,
                                        ),
                                        exitPage: const WorkDays()));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
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
                                                Icons.date_range,
                                                color: Colors.black,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: Text(date.date),
                                              )
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '/',
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10),
                                          child: Row(
                                            children: [
                                              Text(date.name),
                                              const Icon(
                                                Icons.person,
                                                color: Colors.black,
                                              ),
                                            ],
                                          ),
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

  void searchdate(String query) {
    final suggestions = dates.where((date) {
      final name = date.name.toLowerCase();
      final input = query.toLowerCase();
      return name.contains(input);
    }).toList();
    setState(() {
      dates_for_search = suggestions;
    });
  }
}
