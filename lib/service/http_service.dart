// ignore_for_file: non_constant_identifier_names, unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';
import 'package:checkincheckout/widgets/ChangePassword.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import './storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

class HttpService {
  //////////////////////// global variables ////////////////////////////
  final String default_url = 'https://dreamhome2.online/qcbx9cvb2x7n1zv2';
  ///////////////////////////////////////////////////////////////////////

  ////////////////////////// requests ////////////////////////////////////
  /////////////////////// user //////////////////////////
  login(password, userName) async {
    Map<String, dynamic> device_info = await deviceInfo();
    var headers = {'Content-Type': 'application/json'};
    var url =
        Uri.parse("$default_url/w35x241xz1a513cxdas154xc/weqwvcxasad48zv");
    var body = jsonEncode({
      "password": password,
      'userName': userName,
      'device_info': device_info
    });
    var response = await http.post(url, body: body, headers: headers);
    var responseBody = jsonDecode(response.body);
    var result = responseBody['result'];
    var error = responseBody['errors'];
    var name = responseBody['name'];
    var token = responseBody['token'];
    if (response != null &&
        response.statusCode == 200 &&
        result == true &&
        error == null) {
      SecureStirage().writeSecureData('token', token);
      SecureStirage().writeSecureData('name', responseBody['name']);
      return {'result': true, 'name': name};
    } else {
      return {'result': false, 'error': error};
    }
  }

  logOut() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/w35x241xz1a513cxdas154xc/c43wcg53523bxbx1464364bcxfsywb");
    var body = jsonEncode({});
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    var responseBody = jsonDecode(response.body);
    print(responseBody);
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      await SecureStirage().deleteSecureData('token');
      return true;
    } else {
      return false;
    }
  }

  checkInCheckOut() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/o21i5153hxbboi43654xb12354bsauiasezx5412c3212");
    var body = jsonEncode({});
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    var responseBody = jsonDecode(response.body);

    var result = responseBody['result'];
    var resError = responseBody['errors'];
    print(resError);
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return resError;
    }
  }

  checkTimer() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/h36464d135asjc7dh52d3128adfd1515");
    var body = jsonEncode({});
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    var responseBody = jsonDecode(response.body);

    var result = responseBody['result'];
    var resError = responseBody['errors'];
    var seconds = responseBody['seconds'];
    if (result == true && resError == null && response.statusCode == 200) {
      return seconds;
    } else {
      return false;
    }
  }

  getEmployees() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/ie35ur3467236iwt568478sddfda2312");
    var headers = {'x-auth-token': _token_};
    var response = await http.get(url, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  getDates() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/da3bccv1bmbmvbhbsoic0qn41v39gmvdf07");
    var headers = {'x-auth-token': _token_};
    var response = await http.get(url, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  getEmploayPDfs() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/acvn3r3sdsuagvxc8dusambmv715");
    var headers = {'x-auth-token': _token_};
    var response = await http.get(url, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  getEmployeeInfo(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/a31x2cxnvv12xbdmbvgcnn33nxzc");
    var body = jsonEncode({
      "aa4rbwqjhvbizjxbvz": id,
    });
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  getDateInfo(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/d43zv35464b657vsd6n7hcx3124215869");
    var body = jsonEncode({
      "Ndg3sfs15dadga1dfsh4151": id,
    });
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  editDate(
    id,
    check_in_one,
    check_out_one,
    check_in_two,
    check_out_two,
    check_in_three,
    check_out_three,
  ) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/p41j523kc4kln35nb5z3x5jvnjsj6bfaw6siburwiqi");
    var body = jsonEncode({
      "a9edh41241xc": id,
      "check_in_one": check_in_one,
      "check_out_one": check_out_one,
      "check_in_two": check_in_two,
      "check_out_two": check_out_two,
      "check_in_three": check_in_three,
      "check_out_three": check_out_three,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);

    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    print(responseBody);
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  changePassword(
    password,
    id,
  ) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/cxnvn56264ncvnbngh7ysdrg315136");
    var body = jsonEncode({
      "nt53oi1kjbidxgv8ad9tgfas8": id,
      "password": password,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    print(response);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    print(responseBody);
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  deleteDate(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/a124214bvhhd3654hfhdjd67g54jjkghiz75khg47vu8g23414lj12hl4");
    var body = jsonEncode({
      "zcc7v8c5c156": id,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));

    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getEmployeeInfoForEdit(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/az4bcvbszd214asxvcfbcxsva25v7a3w1135xvvzzv");
    var body = jsonEncode({
      "t14zxv24hgasda64srwq": id,
    });
    var headers = {'x-auth-token': _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    print(responseBody);
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  deleteEmployee(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/bxvzv51n2xb12b1c42cbbcbc1bx514tnmvc31253xb");
    var body = jsonEncode({
      "va312s541251t5x123212": id,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    print(responseBody);

    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  changeStatusEmployee(id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/qs1fw12ex9cg80gj68i6rw5q213bxz");
    var body = jsonEncode({
      "qw515121sdefvg5136b47hn5zdivfb": id,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var response = await http.post(url, body: body, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));

    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  getEmployeesName() async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/t2d3c21vt560hgj8678ksfd0dsdn0bj");
    var headers = {'x-auth-token': _token_};
    var response = await http.get(url, headers: headers);
    Map<String, dynamic> responseBody =
        Map<String, dynamic>.from(jsonDecode(response.body));
    var result = responseBody['result'];
    var resError = responseBody['errors'];
    if (result == true && resError == null && response.statusCode == 200) {
      return responseBody['data'];
    } else {
      return false;
    }
  }

  deviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo device_info = await deviceInfoPlugin.androidInfo;
        return {
          "id": device_info.id,
          "androidId": device_info.androidId,
          "type": device_info.type,
          "model": device_info.model,
          "host": device_info.host,
          "display": device_info.display,
          "device": device_info.device,
          'platform': "android"
        };
      } else if (Platform.isIOS) {
        IosDeviceInfo device_info = await deviceInfoPlugin.iosInfo;
        return {
          "systemVersion": device_info.systemVersion,
          "systemName": device_info.systemName,
          "model": device_info.model,
          "localizedModel": device_info.localizedModel,
          "identifierForVendor": device_info.identifierForVendor,
          "utsname": device_info.utsname,
          'platform': "ios"
        };
      }
    } on PlatformException {
      print("erorrrr");
    }
  }

  new_employee(
    _name_,
    userName,
    phone,
    password,
    start_work_hour,
    end_work_hour,
    work_days,
    day_minimum_hours,
    day_maximum_hours,
    month_minimum_hours,
    month_maximum_hours,
    maximum_extra_hours,
    view_pdf_number,
    hours_125,
    _hours_150_,
  ) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/c3z25cxzxvcz32v26nfdzvfh54bhjnas");
    var body = jsonEncode({
      "name": _name_,
      "userName": userName,
      "phone": phone,
      "password": password,
      "start_work_hour": start_work_hour,
      "end_work_hour": end_work_hour,
      "work_days": work_days,
      "day_minimum_hours": day_minimum_hours,
      "day_maximum_hours": day_maximum_hours,
      "month_minimum_hours": month_minimum_hours,
      "month_maximum_hours": month_maximum_hours,
      "maximum_extra_hours": maximum_extra_hours,
      "view_pdf_number": view_pdf_number,
      "hours_125": hours_125,
      "_hours_150_": _hours_150_,
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    try {
      var response = await http.post(url, body: body, headers: headers);
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      return responseBody;
    } catch (e) {
      return {'result': false, 'errors': "يوجد خطاء ارجو الموحولةى من جديد"};
    }
  }

  edit_employee(
      _name_,
      userName,
      phone,
      start_work_hour,
      end_work_hour,
      work_days,
      day_minimum_hours,
      day_maximum_hours,
      month_minimum_hours,
      month_maximum_hours,
      maximum_extra_hours,
      view_pdf_number,
      hours_125,
      _hours_150_,
      id) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/q342wcvxc563v1x132412bn4scdvzxcfyg42jkzx");
    var body = jsonEncode({
      "name": _name_,
      "userName": userName,
      "phone": phone,
      "start_work_hour": start_work_hour,
      "end_work_hour": end_work_hour,
      "work_days": work_days,
      "day_minimum_hours": int.parse(day_minimum_hours),
      "day_maximum_hours": int.parse(day_maximum_hours),
      "month_minimum_hours": int.parse(month_minimum_hours),
      "month_maximum_hours": int.parse(month_maximum_hours),
      "maximum_extra_hours": int.parse(maximum_extra_hours),
      "view_pdf_number": view_pdf_number,
      "hours_125": hours_125,
      "_hours_150_": _hours_150_,
      "a56zcx1488ew": id
    });
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    try {
      var response = await http.post(url, body: body, headers: headers);
      var responseBody = jsonDecode(response.body);
      print(responseBody);
      return responseBody;
    } catch (e) {
      return {'result': false, 'errors': "يوجد خطاء ارجو الموحولةى من جديد"};
    }
  }

  openExtraHour(id, extarHours) async {
    String _token_ = await SecureStirage().readSecureData('token');
    var url = Uri.parse(
        "$default_url/vcx412vi8u15yrrvfg1qw/y1ncv2ncv5n1bmv2shb575mvv65mag543zbhj56323fdvzxk23125");
    var headers = {"x-auth-token": _token_, 'Content-Type': 'application/json'};
    var body = jsonEncode({
      "zgsdh8752159": id,
      "extra_hours": extarHours,
    });
    try {
      var response = await http.post(url, body: body, headers: headers);
      var responseBody = jsonDecode(response.body);
      return responseBody;
    } catch (e) {
      return {'result': false, 'errors': "يوجد خطاء ارجو الموحولةى من جديد"};
    }
  }

  checkUser() async {
    var _token_ = await SecureStirage().readSecureData('token');
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_token_ != null && _token_ != '') {
        var url = Uri.parse(
            "$default_url/vcx412vi8u15yrrvfg1qw/a3v2s51f4dc533uhsq3e412w");
        var headers = {'x-auth-token': _token_ as String};
        var response = await http.post(url, body: {}, headers: headers);
        var responseBody = jsonDecode(response.body);

        var result = responseBody['result'];
        if (result == true && response.statusCode == 200) {
          var block = responseBody['block'];
          if (block == false) {
            return responseBody;
          } else {
            return {'error': 'acc_block'};
          }
        } else {
          return {'error': 'user_level_error'};
        }
      } else {
        return {'error': "no_token"};
      }
    } else {
      return {'error': "no_internet"};
    }
  }

  checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  /////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////
}
