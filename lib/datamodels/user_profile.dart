import 'package:flutter/cupertino.dart';

class UserProfile extends ChangeNotifier
{
  Map<String, dynamic> _idToken;
  Map<dynamic,dynamic> _profile;
  UserProfile(this._idToken,this._profile);
  Map<String, dynamic> get getIdToken{
    return _idToken;
  }
  Map<dynamic, dynamic> get getProfile{
    return _profile;
  }
  set setIdToken(var idToken){
    _idToken=idToken;
    notifyListeners();
  }
  set setProfile(var profile) {
    _profile = profile;
    notifyListeners();
  }
}