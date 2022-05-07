import 'package:app/models/user.dart';
import 'package:app/resources/auth_methods.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get getUser => _user!;

  Future<void> refreshUser() async{
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  } 
}