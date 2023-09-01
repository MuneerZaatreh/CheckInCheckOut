import 'package:checkincheckout/dashbord.dart';
import 'package:checkincheckout/service/http_service.dart';
import 'package:checkincheckout/service/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'Transitions/transtest.dart';
import 'Transitions/transition1.dart';
import 'login.dart';
import 'no_internet.dart';
import 'widgets/bottombar/bottombar.dart';

class ExtraHour extends StatefulWidget {
  const ExtraHour({Key? key}) : super(key: key);

  @override
  State<ExtraHour> createState() => _ExtraHourState();
}

class _ExtraHourState extends State<ExtraHour> {
  String employee = '';
  final List<Employee> _employeeOptions = <Employee>[];
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  int extarHours = 1;
  bool lodaing = true;
  submit() async {
    if (mounted) {
      setState(() {
        lodaing = true;
      });
    }
    if (formstate.currentState!.validate() && employee != '') {
      formstate.currentState!.save();

      var response = await HttpService().openExtraHour(employee, extarHours);
      print(response);
      if (response != null &&
          response['result'] != null &&
          response['result'] == true) {
        showTopSnackBar(
          context,
          const CustomSnackBar.success(message: 'تمت الاضافة بنجاح'),
        );
        return Navigator.of(context).push(EnterExitRoute(
            enterPage: const Dashbord(), exitPage: const ExtraHour()));
      } else if (response != null && response['errors'] != null) {
        setState(() {
          lodaing = false;
        });
        return showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: response['errors'],
          ),
        );
      } else {
        setState(() {
          lodaing = false;
        });
        return showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: 'يجب تعبئة جميع المعلومات',
          ),
        );
      }
    } else {
      return showTopSnackBar(
        context,
        const CustomSnackBar.error(
          message: 'يجب تعبئة جميع المعلومات',
        ),
      );
    }
  }

  String _displayStringForOption(Employee option) => option.name;
  getEmployessName() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getEmployeesName();
    for (var _employee_ in response) {
      _employeeOptions
          .add(Employee(name: _employee_['name'], id: _employee_['_id']));
    }
    setState(() {
      lodaing = false;
    });
  }

  int tryParse(String input) {
    String source = input.trim();
    return int.tryParse(source) ?? 0;
  }

  checkInternet() async {
    var response = await HttpService().checkInternet();
    if (response != null && response == false) {
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NoInternet()));
    }
  }

  check() async {
    if (mounted) {
      setState(() {
        lodaing = true;
      });
    }
    var response = await HttpService().checkUser();
    if (response != null && response['result'] == true) {
      if (response['level'] == 1) {
        await getEmployessName();
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
            : Scaffold(
                bottomNavigationBar: BottomNavBar(
                  currentTab: 2,
                  level: 1,
                ),
                body: SafeArea(
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
                                            '  ساعات أضافية',
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
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              26, 0, 26, 20),
                                          child: Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    'اختار الموظف',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Tajawal',
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                        enabledBorder:
                                                            const OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 2.0),
                                                        ),
                                                        filled: true,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical: 0,
                                                                    horizontal:
                                                                        4),
                                                        fillColor:
                                                            Colors.white),
                                                child: Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Autocomplete<Employee>(
                                                    displayStringForOption:
                                                        _displayStringForOption,
                                                    optionsBuilder:
                                                        (TextEditingValue
                                                            textEditingValue) {
                                                      if (textEditingValue
                                                              .text ==
                                                          '') {
                                                        return const Iterable<
                                                            Employee>.empty();
                                                      }
                                                      return _employeeOptions
                                                          .where((Employee
                                                              option) {
                                                        return option
                                                            .toString()
                                                            .contains(
                                                                textEditingValue
                                                                    .text
                                                                    .toLowerCase());
                                                      });
                                                    },
                                                    optionsViewBuilder:
                                                        (BuildContext context,
                                                            AutocompleteOnSelected<
                                                                    Employee>
                                                                onSelected,
                                                            Iterable<Employee>
                                                                options) {
                                                      return Align(
                                                        alignment:
                                                            Alignment.topLeft,
                                                        child: Material(
                                                          elevation: 4.0,
                                                          child: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                100,
                                                            child: ListView
                                                                .builder(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shrinkWrap: true,
                                                              itemCount: options
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                var option = options
                                                                    .elementAt(
                                                                        index);
                                                                return InkWell(
                                                                  onTap: () {
                                                                    onSelected(
                                                                        option);
                                                                  },
                                                                  child: Builder(builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    final bool
                                                                        highlight =
                                                                        AutocompleteHighlightedOption.of(context) ==
                                                                            index;
                                                                    if (highlight) {
                                                                      SchedulerBinding
                                                                          .instance
                                                                          ?.addPostFrameCallback((Duration
                                                                              timeStamp) {
                                                                        Scrollable.ensureVisible(
                                                                            context,
                                                                            alignment:
                                                                                0.5);
                                                                      });
                                                                    }
                                                                    return Container(
                                                                      color: highlight
                                                                          ? Theme.of(context)
                                                                              .focusColor
                                                                          : null,
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          16.0),
                                                                      child:
                                                                          Text(
                                                                        RawAutocomplete.defaultStringForOption(
                                                                            option.name),
                                                                        textAlign:
                                                                            TextAlign.end,
                                                                      ),
                                                                    );
                                                                  }),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    onSelected:
                                                        (Employee selection) {
                                                      employee = selection.id;
                                                    },
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        child: Text(
                                          'أضافة ساعات ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Tajawal',
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.78,
                                        child: Form(
                                          key: formstate,
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.white),
                                            keyboardType: TextInputType.number,
                                            textDirection: TextDirection.rtl,
                                            decoration: const InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.white,
                                                      width: 2.0),
                                                ),
                                                contentPadding:
                                                    EdgeInsets.fromLTRB(
                                                        20.0, 10.0, 20.0, 10.0),
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(),
                                                hintText: 'ساعات اضافية',
                                                hintStyle: TextStyle(
                                                    fontFamily: 'tajawal',
                                                    color: Color.fromARGB(
                                                        255, 255, 255, 255)),
                                                hintTextDirection:
                                                    TextDirection.rtl),
                                            onSaved: (value) {
                                              int number = tryParse(value!);
                                              if (number > 0) {
                                                extarHours = number;
                                              }
                                            },
                                            validator: (text) {
                                              String pattern =
                                                  r'(^[1-9][0-9]*$)';
                                              RegExp regExp = RegExp(pattern);
                                              if (text!.isEmpty ||
                                                  !regExp.hasMatch(text)) {
                                                return 'لا يمكن ان يكون 0 او ان يكون فارغ';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.height * 0.02,
                                  ),
                                  child: Center(
                                    child: MaterialButton(
                                      onPressed: () {
                                        submit();
                                      },
                                      color: Color.fromARGB(255, 207, 177, 43),
                                      textColor:
                                          Color.fromARGB(255, 207, 177, 43),
                                      child: const Icon(
                                        Icons.task_alt,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        size: 30,
                                      ),
                                      padding: const EdgeInsets.all(20),
                                      shape: const CircleBorder(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              ));
  }
}

@immutable
class Employee {
  const Employee({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  String toString() {
    return '$name, $id';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is Employee && other.name == name && other.id == id;
  }

  @override
  int get hashCode => hashValues(id, name);
}
