import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SPManager {
  final String authToken = "authToken";
   final String supervisorid = "supervisorid";
   final String roleid="roleid";
   final String clientid="clientid";
   final String fcmauthToken="fcmauthToken";
  final String ShiftId= "ShiftId";
  final String rmid="rmid";
 
  // Future<void> clear() async {
  //   final SharedPreferences pref = await SharedPreferences.getInstance();
  //   pref.getKeys();
  //   for (String key in pref.getKeys()) {
  //     if (key == "authToken") {
  //       pref.remove(key);
  //     }
  //   }
  //   //pref.clear();
  // }

  Future<void> setAuthToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.authToken, token);
  }

  //get auth token into shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.authToken) ?? "");
    return val;
  }

 Future<void> setRMID(String rmid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.rmid, rmid);
  }

  //get auth token into shared preferences
  Future<String?> getRMID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.rmid) ?? "");
    return val;
  }

  
  Future<void> setShiftID(String ShiftId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.ShiftId, ShiftId);
  }

  //get auth token into shared preferences
  Future<String?> getShiftID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.ShiftId) ?? "");
    return val;
  }
  Future<void> setsupervisorid(String supervisorid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.supervisorid, supervisorid);
  }

  //get auth token into shared preferences
  Future<String?> getsupervisorid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.supervisorid) ?? "");
    return val;
  }

   Future<void> setclientid(String clientid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.clientid, clientid);
  }

  //get auth token into shared preferences
  Future<String?> getclientid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.clientid) ?? "");
    return val;
  }
//role
 Future<void> setroleid(String roleid) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.roleid, roleid);
  }

  //get auth token into shared preferences
  Future<String?> getroleid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.roleid) ?? "");
    return val;
  }


  
  Future<void> setfcmAuthToken(String fcmauthToken) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.fcmauthToken, fcmauthToken);
  }

  //get auth token into shared preferences
  Future<String?> getfcmAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? val;
    val = (prefs.getString(this.fcmauthToken) ?? "");
    return val;
  }
}
