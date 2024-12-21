import 'package:flutter/material.dart';
import 'c_userupdate.dart';

class UserProfileProvider extends ChangeNotifier {
  late UserProfile _userProfile;

  UserProfile get userProfile => _userProfile;

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    notifyListeners(); // Notify listeners of changes
  }
}
