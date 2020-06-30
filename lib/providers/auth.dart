import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  //Returns the token 
  String get token {
    //return token if it's valid & not expired
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  //Returns the userID
  String get userId{
    return _userId;
  }

  //Use to authenticate the username & password requires for login/signup
  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = '';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      //Start autoLogout task in parallel so that when token get's expired user will be logged out implicitly
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  void logout(){
    _token = null;
    _userId = null;
    _expiryDate = null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
  }
  
  //Logout Automatically when token gets expired
  void _autoLogout(){
    if(_authTimer != null){
      _authTimer.cancel();
    }
    //calculate the time after which user token will be invalid & needs to re-login
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    //autoLogout
    //This is async task so it will run in parallel with other tasks, i.e after login
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    //_authTimer = Timer(Duration(seconds: 5), logout);
  }
}
