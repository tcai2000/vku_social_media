import 'package:app/models/user.dart';
import 'package:app/resources/auth_methods.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refreshUser() async{
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  } 
}