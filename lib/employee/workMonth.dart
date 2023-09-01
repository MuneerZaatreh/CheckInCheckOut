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
import '../widgets/interface/workMonth.dart';
import 'my_pdf_view.dart';

class WorkMonth extends StatefulWidget {
  const WorkMonth({Key? key}) : super(key: key);
  @override
  _WorkMonthState createState() => _WorkMonthState();
}

class _WorkMonthState extends State<WorkMonth> {
  final controoler = TextEditingController();
  List<WorkMonthInterFace> dates = [];

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
    var response = await HttpService().getEmploayPDfs();

    List<WorkMonthInterFace> __dates__ = [];
    if (response != null && response != false) {
      for (var _date_ in response) {
        WorkMonthInterFace date = WorkMonthInterFace(
          link: _date_['link'],
          date: _date_['date'],
        );
        __dates__.add(date);
      }
    }
    if (mounted) {
      setState(() {
        dates = __dates__;
        lodaing = false;
      });
    }
  }

  check() async {
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 2) {
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
                                            'ساعات العمل',
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
                          Expanded(
                              child: ListView.builder(
                            itemCount: dates.length,
                            itemBuilder: (context, index) {
                              final date = dates[index];

                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyViewPdf(link: date.link)));
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
}
