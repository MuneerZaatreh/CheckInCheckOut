import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'employee/new.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: "تم الاتصال بالانترنت",
        ),
      );
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const NewEmployee()));
    }
    return showTopSnackBar(
      context,
      const CustomSnackBar.error(
        message: "لا يوجد انترنت",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Image.asset(
                    'images/no_internet.gif',
                    width: 200,
                  ),
                ),
                Center(
                    child: Column(
                  children: const [
                    Text(
                      "لا يوجد انترنت",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          fontFamily: 'Tajawal'),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        "يجب أن تكون متصلاً بالإنترنت لاستخدام هذا التطبيق",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Tajawal'),
                      ),
                    ),
                  ],
                )),
                ElevatedButton(
                  onPressed: () {
                    checkInternet();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(220, 30, 74, 1),
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    minimumSize: const Size(200, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                  ),
                  child: const Text(
                    'حاول مجددا',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Tajawal'),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
