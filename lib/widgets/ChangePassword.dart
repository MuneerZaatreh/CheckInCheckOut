import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../Transitions/transition1.dart';
import '../Transitions/transtest.dart';
import '../employee/profile.dart';
import '../login.dart';
import '../no_internet.dart';
import '../service/http_service.dart';
import '../service/storage.dart';

class ChangePassword extends StatefulWidget {
  String id;
  ChangePassword({Key? key, required this.id}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState(id);
}

class _ChangePasswordState extends State<ChangePassword> {
  String id;
  _ChangePasswordState(this.id);

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String password = '';
  String passwordconfirm = '';
  bool lodaing = false;
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  submit() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    if (formstate.currentState!.validate()) {
      formstate.currentState!.save();

      var response = await HttpService().changePassword(password, id);

      if (response == true) {
        setState(() {
          lodaing = false;
        });
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: 'تم تغير كلمة السر  بنجاح',
          ),
        );
        return Navigator.of(context).push(EnterExitRoute(
            enterPage: EmployeeProfile(
              id: id,
            ),
            exitPage: ChangePassword(
              id: id,
            )));
      } else {
        setState(() {
          lodaing = false;
        });

        return showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: 'error',
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

  check() async {
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 1) {
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
    var willPopScope = WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
                        height: double.infinity,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("images/gvoldenblack.jpg"),
                              fit: BoxFit.cover),
                        ),
                        child: Column(children: [
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
                                            '  تفير كلمة السر',
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
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: ListView(
                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      Center(
                                          child: Column(
                                        children: [
                                          Image.asset(
                                            "images/lock.png",
                                            width: 180,
                                            height: 190,
                                          )
                                        ],
                                      )),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Column(children: [
                                          Center(
                                              child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                  "كلمة سرك الجديد يجب ان تكون مختلفة",
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255)),
                                                ),
                                              ),
                                            ],
                                          )),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Form(
                                              key: formstate,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Column(children: [
                                                  Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextFormField(
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          obscureText: true,
                                                          controller: _pass,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          onSaved: (value) {
                                                            password = value!;
                                                          },
                                                          validator: (text) {
                                                            if (text!.isEmpty) {
                                                              return 'يجب إدخال كلمه السر';
                                                            }
                                                            if (text.length <
                                                                8) {
                                                              return "كلمة السر اصغر من 8 حروف و ارقام";
                                                            }
                                                            return null;
                                                          },
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              const InputDecoration(
                                                                  enabledBorder:
                                                                      const OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Tajawal',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  labelText:
                                                                      'كلمه السر',
                                                                  border:
                                                                      OutlineInputBorder()))),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                  ),
                                                  Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextFormField(
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          obscureText: true,
                                                          controller:
                                                              _confirmPass,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          onSaved: (value) {
                                                            passwordconfirm =
                                                                value!;
                                                          },
                                                          validator: (text) {
                                                            if (text!.isEmpty ||
                                                                text !=
                                                                    _pass
                                                                        .text) {
                                                              return 'كلمة السر غير متطابقة';
                                                            }
                                                            if (text.length <
                                                                8) {
                                                              return "كلمة السر اصغر من 8 حروف و ارقام";
                                                            }
                                                            return null;
                                                          },
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                          decoration:
                                                              const InputDecoration(
                                                                  enabledBorder:
                                                                      const OutlineInputBorder(
                                                                    borderSide: const BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            2.0),
                                                                  ),
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Tajawal',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  labelText:
                                                                      'تأكيد كلمة السر',
                                                                  border:
                                                                      OutlineInputBorder()))),
                                                ]),
                                              )),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                        primary: Color.fromARGB(
                                                                255,
                                                                207,
                                                                177,
                                                                43)
                                                            .withOpacity(0.9),
                                                        fixedSize: Size(
                                                            (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.8),
                                                            35)),
                                                    onPressed: () {
                                                      submit();
                                                    },
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(7),
                                                      child: Text(
                                                        'حفظ',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Tajawal'),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        ]),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ])))));
    return willPopScope;
  }
}
