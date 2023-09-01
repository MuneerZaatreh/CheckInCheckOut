// ignore_for_file: file_names, unused_local_variable, non_constant_identifier_names, no_logic_in_create_state, must_be_immutable
import 'package:checkincheckout/employee/profile.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:time_range_picker/time_range_picker.dart';
import '../Transitions/transition1.dart';
import '../Transitions/transtest.dart';
import '../login.dart';
import '../no_internet.dart';
import '../service/http_service.dart';
import '../service/storage.dart';
import '../widgets/bottombar/bottombar.dart';
import 'checkbox_stae.dart';

class EditEmployee extends StatefulWidget {
  String id;
  EditEmployee({Key? key, required this.id}) : super(key: key);
  @override
  _EditEmployeeState createState() => _EditEmployeeState(id);
}

class _EditEmployeeState extends State<EditEmployee> {
  String id;
  _EditEmployeeState(this.id);
  TimeOfDay _startWorkTime = TimeOfDay.now();
  TimeOfDay _endWorkTime = TimeOfDay.now();

  List<CheckBoxState> workDays = [
    CheckBoxState(titel: 'الأحد', value: false),
    CheckBoxState(
      titel: 'الاثنين',
      value: false,
    ),
    CheckBoxState(
      titel: 'الثلاثاء',
      value: false,
    ),
    CheckBoxState(
      titel: 'الأربعاء',
      value: false,
    ),
    CheckBoxState(
      titel: 'الخميس',
      value: false,
    ),
    CheckBoxState(
      titel: 'الجمعة',
      value: false,
    ),
    CheckBoxState(
      titel: 'السبت',
      value: false,
    ),
  ];
  List<CheckBoxState> yes_no = [
    CheckBoxState(
      titel: 'نعم',
      value: true,
    ),
    CheckBoxState(
      titel: 'لا',
      value: false,
    ),
  ];
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  String name = '';
  String userName = '';
  bool lodaing = true;
  String phone = '';
  String day_minimum_hours = '';
  String day_maximum_hours = '';
  String month_minimum_hours = '';
  String month_maximum_hours = '';
  String maximum_extra_hours = '';
  String view_pdf_number = '';
  String hours_125 = '';
  String hours_150 = '';
  String phone_error_form_server = '';
  String userName_error_form_server = '';

  late int level = 1;
  submit() async {
    await checkInternet();
    setState(() {
      lodaing = true;
    });
    phone_error_form_server = '';
    userName_error_form_server = '';
    if (formstate.currentState!.validate() &&
        workDays.where((i) => i.value == true).isNotEmpty) {
      formstate.currentState!.save();
      int _hours_150_ = 0;
      for (int x = 0; x < yes_no.length; x++) {
        if (yes_no[x].value == true) {
          if (yes_no[x].titel == 'نعم') {
            _hours_150_ = 1;
          } else {
            _hours_150_ = 0;
          }
        }
      }
      var workDaysMap = workDays.where((i) => i.value == true).map((i) {
        if (i.titel == 'الأحد') {
          return 'Sunday';
        } else if (i.titel == 'الاثنين') {
          return 'Monday';
        } else if (i.titel == 'الثلاثاء') {
          return 'Tuesday';
        } else if (i.titel == 'الأربعاء') {
          return 'Wednesday';
        } else if (i.titel == 'الخميس') {
          return 'Thursday';
        } else if (i.titel == 'الجمعة') {
          return 'Friday';
        } else if (i.titel == 'السبت') {
          return 'Saturday';
        }
      }).toList();

      if (id.isEmpty) {
        return;
      }
      var response = await HttpService().edit_employee(
          name,
          userName,
          phone,
          _startWorkTime.format(context),
          _endWorkTime.format(context),
          workDaysMap,
          day_minimum_hours,
          day_maximum_hours,
          month_minimum_hours,
          month_maximum_hours,
          maximum_extra_hours,
          view_pdf_number,
          hours_125,
          _hours_150_,
          id);

      if (response != null &&
          response.isNotEmpty &&
          response['result'] == true) {
        setState(() {
          lodaing = false;
        });
        showTopSnackBar(
          context,
          const CustomSnackBar.success(
            message: 'تم تعديل على الحساب بنجاح',
          ),
        );
        return Navigator.of(context).push(EnterExitRoute(
            enterPage: EmployeeProfile(
              id: id,
            ),
            exitPage: EditEmployee(id: id)));
      } else {
        setState(() {
          lodaing = false;
        });
        if (response == null) {
          return showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: "يوجد خطأ ارجو المحاولة من جديد",
            ),
          );
        } else if (response['phone'] != null) {
          phone_error_form_server = response['phone'];
          showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: 'هذه الرقم مسجل مسبقا',
            ),
          );
        } else if (response['userName'] != null) {
          userName_error_form_server = response['userName'];
          showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: ' الاسم المستخدم  مسجل مسبقا',
            ),
          );
        } else {
          return showTopSnackBar(
            context,
            const CustomSnackBar.error(
              message: 'error',
            ),
          );
        }
        formstate.currentState?.validate();
      }
    } else {
      setState(() {
        lodaing = false;
      });
      if (workDays.where((i) => i.value == true).isEmpty) {
        return showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "تحتاج إلى اختيار يوم عمل على الأقل",
          ),
        );
      } else {
        return showTopSnackBar(
          context,
          const CustomSnackBar.error(
            message: "يوجد خطأ ارجو المحاولة من جديد",
          ),
        );
      }
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
        await getEmployessInfo();
        return setState(() {
          level = response['level'];
        });
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

  getEmployessInfo() async {
    setState(() {
      lodaing = true;
    });
    var response = await HttpService().getEmployeeInfoForEdit(id);
    if (response != null && response != false) {
      List old_days_work = response['work_days'];
      List<CheckBoxState> new_day_work = [];
      List<CheckBoxState> new_yes_no = [];
      if (old_days_work.contains('Sunday')) {
        new_day_work.add(CheckBoxState(titel: 'الأحد', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الأحد', value: false));
      }
      if (old_days_work.contains('Monday')) {
        new_day_work.add(CheckBoxState(
          titel: 'الاثنين',
        ));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الاثنين', value: false));
      }
      if (old_days_work.contains('Tuesday')) {
        new_day_work.add(CheckBoxState(titel: 'الثلاثاء', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الثلاثاء', value: false));
      }
      if (old_days_work.contains('Wednesday')) {
        new_day_work.add(CheckBoxState(titel: 'الأربعاء', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الأربعاء', value: false));
      }
      if (old_days_work.contains('Thursday')) {
        new_day_work.add(CheckBoxState(titel: 'الخميس', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الخميس', value: false));
      }
      if (old_days_work.contains('Friday')) {
        new_day_work.add(CheckBoxState(titel: 'الجمعة', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'الجمعة', value: false));
      }
      if (old_days_work.contains('Saturday')) {
        new_day_work.add(CheckBoxState(titel: 'السبت', value: true));
      } else {
        new_day_work.add(CheckBoxState(titel: 'السبت', value: false));
      }
      if (response['hours_150'] == 1) {
        new_yes_no.add(CheckBoxState(titel: 'نعم', value: true));
        new_yes_no.add(CheckBoxState(titel: 'لا', value: false));
      } else {
        new_yes_no.add(CheckBoxState(titel: 'نعم', value: false));
        new_yes_no.add(CheckBoxState(titel: 'لا', value: true));
      }
      setState(() {
        name = response['name'];
        phone = response['phone'];
        userName = response['userName'];
        day_minimum_hours = response['day_minimum_hours'].toString();
        day_maximum_hours = response['day_maximum_hours'].toString();
        month_minimum_hours = response['month_minimum_hours'].toString();
        month_maximum_hours = response['month_maximum_hours'].toString();
        maximum_extra_hours = response['maximum_extra_hours'].toString();
        view_pdf_number = response['view_pdf_number'].toString();
        hours_125 = response['hours_125'].toString();
        hours_150 = response['hours_150'].toString();
        _startWorkTime = TimeOfDay(
            hour: int.parse(response['start_work_hour'].split(":")[0]),
            minute: int.parse(
                response['start_work_hour'].split(":")[1].split(' ')[0]));
        _endWorkTime = TimeOfDay(
            hour: int.parse(response['end_work_hour'].split(":")[0]),
            minute: int.parse(
                response['end_work_hour'].split(":")[1].split(' ')[0]));

        workDays = new_day_work;
        yes_no = new_yes_no;
      });
    }
    setState(() {
      lodaing = false;
    });
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
                  level: level,
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
                                            'التعديل على العامل',
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
                                padding:
                                    const EdgeInsets.only(left: 13, right: 13),
                                child: Form(
                                    key: formstate,
                                    child: Column(children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      Center(
                                          child: Column(children: [
                                        Directionality(
                                            textDirection: TextDirection.rtl,
                                            child: TextFormField(
                                                initialValue: name,
                                                keyboardType:
                                                    TextInputType.text,
                                                textDirection:
                                                    TextDirection.rtl,
                                                onSaved: (value) {
                                                  name = value!;
                                                },
                                                validator: (text) {
                                                  if (text!.isEmpty ||
                                                      text.length < 4 ||
                                                      text.length > 250) {
                                                    return 'يجب ان يكون اسم اكثر من حرفين و اقل من 250 حرف';
                                                  }
                                                  return null;
                                                },
                                                style: const TextStyle(
                                                    fontFamily: 'Tajawal',
                                                    color: Colors.white),
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
                                                        labelStyle: TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color: Colors.white,
                                                        ),
                                                        labelText: 'اسم',
                                                        border:
                                                            OutlineInputBorder()))),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        Center(
                                            child: Column(children: [
                                          Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  initialValue: phone,
                                                  onSaved: (value) {
                                                    phone = value!;
                                                  },
                                                  validator: (text) {
                                                    String pattern =
                                                        r'(^0[2-9]\d{7,8}$)';
                                                    RegExp regExp =
                                                        RegExp(pattern);

                                                    if (text!.isEmpty ||
                                                        !regExp
                                                            .hasMatch(text)) {
                                                      return 'يجب إدخال رقم هاتف صحيح';
                                                    }
                                                    if (phone_error_form_server
                                                        .isNotEmpty) {
                                                      return phone_error_form_server;
                                                    }
                                                    return null;
                                                  },
                                                  style: const TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.white),
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
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            color: Colors.white,
                                                          ),
                                                          labelText:
                                                              'رقم الهاتف',
                                                          border:
                                                              OutlineInputBorder()))),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.03,
                                          ),
                                          Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  initialValue: userName,
                                                  onSaved: (value) {
                                                    userName = value!;
                                                  },
                                                  validator: (text) {
                                                    if (userName_error_form_server
                                                        .isNotEmpty) {
                                                      return userName_error_form_server;
                                                    } else if (text!.isEmpty ||
                                                        text.length < 4 ||
                                                        text.length > 250) {
                                                      return 'يجب ان يكون اسم اكثر من حرفين و اقل من 250 حرف';
                                                    }
                                                    return null;
                                                  },
                                                  style: const TextStyle(
                                                      fontFamily: 'Tajawal',
                                                      color: Colors.white),
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
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
                                                            color: Colors.white,
                                                          ),
                                                          labelText:
                                                              'اسم المستخدم لتسجيل الدخول',
                                                          border:
                                                              OutlineInputBorder()))),
                                          Center(
                                              child: Column(children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.03,
                                            ),
                                            Center(
                                                child: Column(children: [
                                              Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      initialValue:
                                                          day_minimum_hours,
                                                      onSaved: (value) {
                                                        day_minimum_hours =
                                                            value!;
                                                      },
                                                      validator: (text) {
                                                        String pattern =
                                                            r'(\b(0?[1-9]|1[0-9]|2[0-4])\b)';
                                                        RegExp regExp =
                                                            RegExp(pattern);

                                                        if (text!.isEmpty) {
                                                          return 'لا يمكن تركه فارغ';
                                                        } else if (!regExp
                                                            .hasMatch(text)) {
                                                          return 'يجب ان يكون الرقم بين 1 الى 24';
                                                        }
                                                        return null;
                                                      },
                                                      style: const TextStyle(
                                                          fontFamily: 'Tajawal',
                                                          color: Colors.white),
                                                      decoration:
                                                          const InputDecoration(
                                                              enabledBorder:
                                                                  const OutlineInputBorder(
                                                                borderSide: const BorderSide(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 2.0),
                                                              ),
                                                              labelStyle:
                                                                  TextStyle(
                                                                fontFamily:
                                                                    'Tajawal',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              labelText:
                                                                  'اقل عدد ساعات العمل بي اليوم',
                                                              border:
                                                                  OutlineInputBorder()))),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03,
                                              ),
                                              Center(
                                                  child: Column(children: [
                                                Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        initialValue:
                                                            day_maximum_hours,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        onSaved: (value) {
                                                          day_maximum_hours =
                                                              value!;
                                                        },
                                                        validator: (text) {
                                                          String pattern =
                                                              r'(\b(0?[1-9]|1[0-9]|2[0-4])\b)';
                                                          RegExp regExp =
                                                              RegExp(pattern);

                                                          if (text!.isEmpty) {
                                                            return 'لا يمكن تركه فارغ';
                                                          } else if (!regExp
                                                              .hasMatch(text)) {
                                                            return 'يجب ان يكون الرقم بين 1 الى 24';
                                                          }
                                                          return null;
                                                        },
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                'Tajawal',
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
                                                                    '  اقصى  عدد ساعات العمل بي اليوم',
                                                                border:
                                                                    OutlineInputBorder()))),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                Center(
                                                    child: Column(children: [
                                                  Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          initialValue:
                                                              month_maximum_hours,
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          onSaved: (value) {
                                                            month_maximum_hours =
                                                                value!;
                                                          },
                                                          validator: (text) {
                                                            String pattern =
                                                                r'(^[1-9][0-9]*$)';
                                                            RegExp regExp =
                                                                RegExp(pattern);

                                                            if (text!.isEmpty) {
                                                              return 'لا يمكن تركه فارغ';
                                                            } else if (!regExp
                                                                .hasMatch(
                                                                    text)) {
                                                              return 'يجب ان يكون الرقم اكبر من 0';
                                                            }
                                                            return null;
                                                          },
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'Tajawal',
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
                                                                      '  اقل عدد ساعات العمل بي الشهر ',
                                                                  border:
                                                                      OutlineInputBorder()))),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                  ),
                                                  Center(
                                                      child: Column(children: [
                                                    Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: TextFormField(
                                                            initialValue:
                                                                month_minimum_hours,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            onSaved: (value) {
                                                              month_minimum_hours =
                                                                  value!;
                                                            },
                                                            validator: (text) {
                                                              String pattern =
                                                                  r'(^[1-9][0-9]*$)';
                                                              RegExp regExp =
                                                                  RegExp(
                                                                      pattern);

                                                              if (text!
                                                                  .isEmpty) {
                                                                return 'لا يمكن تركه فارغ';
                                                              } else if (!regExp
                                                                  .hasMatch(
                                                                      text)) {
                                                                return 'يجب ان يكون الرقم اكبر من 0';
                                                              }
                                                              return null;
                                                            },
                                                            style: const TextStyle(
                                                                fontFamily:
                                                                    'Tajawal',
                                                                color: Colors
                                                                    .white),
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
                                                                        '   اقصى عدد ساعات العمل  بي الشهر',
                                                                    border:
                                                                        OutlineInputBorder()))),
                                                    SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                    ),
                                                    Center(
                                                      child: Column(children: [
                                                        Directionality(
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            child:
                                                                TextFormField(
                                                                    initialValue:
                                                                        maximum_extra_hours,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    onSaved:
                                                                        (value) {
                                                                      maximum_extra_hours =
                                                                          value!;
                                                                    },
                                                                    validator:
                                                                        (text) {
                                                                      String
                                                                          pattern =
                                                                          r'(^[1-9][0-9]*$)';
                                                                      RegExp
                                                                          regExp =
                                                                          RegExp(
                                                                              pattern);

                                                                      if (text!
                                                                          .isEmpty) {
                                                                        return 'لا يمكن تركه فارغ';
                                                                      } else if (!regExp
                                                                          .hasMatch(
                                                                              text)) {
                                                                        return 'يجب ان يكون رقم';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    style: const TextStyle(
                                                                        fontFamily:
                                                                            'Tajawal',
                                                                        color: Colors
                                                                            .white),
                                                                    decoration: const InputDecoration(
                                                                        enabledBorder: const OutlineInputBorder(
                                                                          borderSide: const BorderSide(
                                                                              color: Colors.white,
                                                                              width: 2.0),
                                                                        ),
                                                                        labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'Tajawal',
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        labelText: 'اقصى عدد ساعات العمل الاضافية ',
                                                                        border: OutlineInputBorder()))),
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.03,
                                                        ),
                                                        Center(
                                                          child: Column(
                                                              children: [
                                                                Directionality(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    child: TextFormField(
                                                                        textInputAction: TextInputAction.next,
                                                                        keyboardType: TextInputType.number,
                                                                        textDirection: TextDirection.rtl,
                                                                        onSaved: (value) {
                                                                          view_pdf_number =
                                                                              value!;
                                                                        },
                                                                        initialValue: view_pdf_number,
                                                                        validator: (text) {
                                                                          String
                                                                              pattern =
                                                                              r'(^[0-9][0-9]?$|^100$)';
                                                                          RegExp
                                                                              regExp =
                                                                              RegExp(pattern);

                                                                          if (text!
                                                                              .isEmpty) {
                                                                            return 'لا يمكن تركه فارغ';
                                                                          } else if (!regExp
                                                                              .hasMatch(text)) {
                                                                            return 'يجب ان يكون الرقم بين 0 الى 100';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white),
                                                                        decoration: const InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                                            ),
                                                                            labelStyle: TextStyle(
                                                                              fontFamily: 'Tajawal',
                                                                              color: Colors.white,
                                                                            ),
                                                                            labelText: 'عدد الشهور التي يمكن رؤيته',
                                                                            border: OutlineInputBorder()))),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03,
                                                                ),
                                                                Directionality(
                                                                    textDirection:
                                                                        TextDirection
                                                                            .rtl,
                                                                    child: TextFormField(
                                                                        textInputAction: TextInputAction.next,
                                                                        keyboardType: TextInputType.number,
                                                                        textDirection: TextDirection.rtl,
                                                                        onSaved: (value) {
                                                                          hours_125 =
                                                                              value!;
                                                                        },
                                                                        initialValue: hours_125,
                                                                        validator: (text) {
                                                                          String
                                                                              pattern =
                                                                              r'(^[0-9][0-9]?$|^24$)';
                                                                          RegExp
                                                                              regExp =
                                                                              RegExp(pattern);

                                                                          if (text!
                                                                              .isEmpty) {
                                                                            return 'لا يمكن تركه فارغ';
                                                                          } else if (!regExp
                                                                              .hasMatch(text)) {
                                                                            return 'يجب ان يكون الرقم بين 0 الى 24';
                                                                          }
                                                                          return null;
                                                                        },
                                                                        style: const TextStyle(fontFamily: 'Tajawal', color: Colors.white),
                                                                        decoration: const InputDecoration(
                                                                            enabledBorder: const OutlineInputBorder(
                                                                              borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                                                            ),
                                                                            labelStyle: TextStyle(
                                                                              fontFamily: 'Tajawal',
                                                                              color: Colors.white,
                                                                            ),
                                                                            labelText: 'عدد ساعات %125',
                                                                            border: OutlineInputBorder()))),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.all(
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.02),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: Text(
                                                                        'مسموح الموظف %150',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontFamily: 'Tajawal')),
                                                                  ),
                                                                ),
                                                                Directionality(
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                  child: Column(
                                                                    children: [
                                                                      ...yes_no
                                                                          .map(
                                                                              buildSingleCheckBox_yes_no)
                                                                          .toList()
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03,
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          10,
                                                                          0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary:
                                                                                Colors.lightBlue.withOpacity(1)),
                                                                        onPressed:
                                                                            () async {
                                                                          await showTimeRangePicker(
                                                                              context: context,
                                                                              start: _startWorkTime,
                                                                              end: _endWorkTime,
                                                                              strokeWidth: 4,
                                                                              ticks: 4,
                                                                              ticksOffset: -7,
                                                                              ticksLength: 15,
                                                                              ticksColor: Colors.grey,
                                                                              labels: [
                                                                                "12 مساء",
                                                                                "6 صباحا",
                                                                                "12 صباحا",
                                                                                "6 مساء",
                                                                              ].asMap().entries.map((e) {
                                                                                return ClockLabel.fromIndex(idx: e.key, length: 4, text: e.value);
                                                                              }).toList(),
                                                                              labelOffset: 35,
                                                                              rotateLabels: false,
                                                                              padding: 60,
                                                                              onStartChange: (start) {
                                                                                setState(() {
                                                                                  _startWorkTime = start;
                                                                                });
                                                                              },
                                                                              onEndChange: (end) {
                                                                                setState(() {
                                                                                  _endWorkTime = end;
                                                                                });
                                                                              });
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          '${_endWorkTime.format(context)} - ${_startWorkTime.format(context)}   ',
                                                                          style:
                                                                              const TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                      const Text(
                                                                          'ساعات العمل',
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontFamily: 'Tajawal'))
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.05,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.all(
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.02),
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: Text(
                                                                        'أيام العمل ',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontFamily: 'Tajawal')),
                                                                  ),
                                                                ),
                                                                Directionality(
                                                                  textDirection:
                                                                      TextDirection
                                                                          .rtl,
                                                                  child: Column(
                                                                    children: [
                                                                      ...workDays
                                                                          .map(
                                                                              buildSingleCheckBox)
                                                                          .toList()
                                                                    ],
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.03,
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets.all(
                                                                      MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.02),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          submit();
                                                                        },
                                                                        style: ElevatedButton.styleFrom(
                                                                            primary: Colors
                                                                                .green,
                                                                            minimumSize: const Size(150.0,
                                                                                37.0),
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                                                                        child: const Text(
                                                                            "تعديل"),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]),
                                                        )
                                                      ]),
                                                    ),
                                                  ]))
                                                ]))
                                              ]))
                                            ]))
                                          ]))
                                        ]))
                                      ]))
                                    ])),
                              )
                            ],
                          ))
                        ],
                      )),
                )));
  }

  Widget buildSingleCheckBox(CheckBoxState checkbox) => CheckboxListTile(
      value: checkbox.value,
      title: Text(
        checkbox.titel,
        style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) => setState(() {
            checkbox.value = value!;
          }));
  Widget buildSingleCheckBox_yes_no(CheckBoxState checkbox) => CheckboxListTile(
      value: checkbox.value,
      title: Text(
        checkbox.titel,
        style: TextStyle(color: Colors.white, fontFamily: 'Tajawal'),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (value) => setState(() {
            for (int x = 0; x < yes_no.length; x++) {
              if (checkbox.titel != yes_no[x]) {
                yes_no[x].value = false;
              }
            }
            checkbox.value = value!;
          }));
}
