import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;  

  Future<void> _authenticate(String email, String password, String urlSegment) async{
    final url = '';
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
}
