import 'package:checkincheckout/Transitions/transition3.dart';
import 'package:checkincheckout/dashbord.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../no_internet.dart';
import 'service/storage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String userName = '';
  String password = '';
  bool lodaing = false;

  submit() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    if (formstate.currentState!.validate()) {
      formstate.currentState!.save();
      var response = await HttpService().login(password, userName);
      if (response != null && response['result'] == true) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: response['name'],
          ),
        );
        return Navigator.of(context).push(ScaleRoute(
          page: const Dashbord(),
        ));
      } else {
        setState(() {
          userName = userName;
          password = password;
          lodaing = false;
        });
        return showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: response['error'] ?? "يوجد خطأ ارجو المحاولة من جديد",
          ),
        );
      }
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

  checkInternet() async {
    var response = await HttpService().checkInternet();
    if (response != null && response == false) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  checkLogin() async {
    var token = await SecureStirage().readSecureData('token');
    if (token != null) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashbord()));
    }
  }

  @override
  void initState() {
    checkLogin();
    checkInternet();
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
              body: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/gvoldenblack.jpg"),
                    fit: BoxFit.cover),
              ),
              child: Center(
                  child: Container(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.01,
                        right: MediaQuery.of(context).size.width * 0.20,
                        top: 60,
                      ),
                      child: Image.asset(
                        "images/newlogo1.png",
                        width: 200.0,
                        height: 200.0,
                      ),
                    ),
                    Center(
                      child: Column(children: const [
                        Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "أهلا و سهلا بك",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontFamily: 'Tajawal'),
                          ),
                        ),
                        Text(
                          "ادخل اسم المستخدم و كلمة السر",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: 'Tajawal'),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Center(
                        child: Form(
                      key: formstate,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.text,
                                    textDirection: TextDirection.rtl,
                                    initialValue: userName,
                                    style: TextStyle(color: Colors.white),
                                    onSaved: (value) {
                                      userName = value!;
                                    },
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'يجب إدخال اسم المستخدم';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        labelText: 'اسم المستخدم',
                                        labelStyle: TextStyle(
                                          fontFamily: 'Tajawal',
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder()))),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.05,
                                left: MediaQuery.of(context).size.width * 0.05),
                            child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                    textInputAction: TextInputAction.next,
                                    obscureText: true,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(color: Colors.white),
                                    onSaved: (value) {
                                      password = value!;
                                    },
                                    validator: (text) {
                                      if (text!.isEmpty) {
                                        return 'يجب إدخال كلمه السر';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white, width: 2.0),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        labelText: 'كلمه السر',
                                        labelStyle: TextStyle(
                                            fontFamily: 'Tajawal',
                                            color: Colors.white),
                                        border: OutlineInputBorder()))),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                submit();
                              },
                              style: ElevatedButton.styleFrom(
                                  fixedSize: Size(160, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4))),
                              child: const Text("تسجيل الدخول"),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                ),
              )),
            )),
    );
  }
}
