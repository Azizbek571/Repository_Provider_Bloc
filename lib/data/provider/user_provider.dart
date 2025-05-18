import 'package:dio/dio.dart';
import 'package:repository_provider/data/model/user_model.dart';

class UserProvider {
  final Dio _dio=Dio(BaseOptions(baseUrl:"https://api.slingacademy.com/v1/"));

  Future<UserModel>getUsers()async{
    try{
      final response = await _dio.get("sample-data/users");
      return userModelFromJson(response.toString());
    }catch(e){
  return Future.error(e.toString());
    }

  }
}