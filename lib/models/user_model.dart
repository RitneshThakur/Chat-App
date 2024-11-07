import 'package:firebase_auth/firebase_auth.dart';

class UserModel{
  String? uId;
  String? fullName;
  String? emailId;
  String? profilePicture;
  UserModel({this.uId,this.fullName,this.emailId,this.profilePicture});
  UserModel.fromMap(Map<String,dynamic> map) {
    uId=map['uId'];
    fullName=map['fullName'];
    emailId=map['emailId'];
    profilePicture=map['profilePicture'];
  }
  Map<String,dynamic> toMap(){
    return{
      'uId':uId,
      'fullName':fullName,
      'emailId':emailId,
      'profilePicture':profilePicture,
    };
}
}