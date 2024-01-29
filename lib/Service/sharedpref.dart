import 'package:shared_preferences/shared_preferences.dart';

class sharedPreferenceHelper{
  String userIdKey = "USERIDKEY";
  String userNameKey = "USERNAMEKEY";
  String userEmailKey = "USEREMAILKEY";
  String userPicKey = "USERPICKEY";
  String userDisplayNameKey = "USERDISPLAYNAMEKEY";

  Future<bool> saveUserId(String getUserId)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userIdKey,getUserId);
  }
  Future<bool> saveUserName(String getUserName)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userNameKey,getUserName);
  }
  Future<bool> saveUserEmail(String getUserEmail)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userEmailKey,getUserEmail);
  }
  Future<bool> saveUserPic(String getUserPic)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userPicKey,getUserPic);
  }
  Future<bool> saveUserDisplayName(String getUserDisplayName)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.setString(userDisplayNameKey,getUserDisplayName);
  }
  Future<String?> getUserId()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userIdKey);
  }
  Future<String?> getUserName()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userNameKey);
  }
  Future<String?> getUserEmail()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmailKey);
  }
  Future<String?> getUserPic()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userPicKey);
  }
  Future<String?> getUserDisplayName()async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDisplayNameKey);
  }
}