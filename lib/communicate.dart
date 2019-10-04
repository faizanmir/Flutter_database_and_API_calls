import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

import 'main.dart';

class LoginData {
  String email;
  String password;
  LoginData(this.email, this.password);

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      new LoginData(json['email'], json['password']);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }
}

class Res {
  String status, message, token;
  int userId;
  Res(this.status, this.message, this.token, this.userId);

  factory Res.fromJson(Map<String, dynamic> map) =>
      new Res(map["status"], map["message"], map["token"], map["user_id"]);
}

class DataFromJsonPlaceholder {
  String title, body;
  int id, userId;

  DataFromJsonPlaceholder(this.userId, this.title, this.body, this.id);

  factory DataFromJsonPlaceholder.fromJSON(Map<String, dynamic> json) =>
      new DataFromJsonPlaceholder(
          json['userId'], json['title'], json["body"], json["id"]);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['userId'] = userId;
    map['title'] = title;
    map['body'] = body;
    map['id'] = id;
    return map;
  }
}

Future<Res> postDataToServer(Map body) async {
  return await http
      .post("https://cloud.avishkaar.cc/api/auth/login", body: body)
      .then((http.Response response) {
    print(response.body);
    print(json.decode(response.body));
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      new Exception("Login Failed");
    }
    return Res.fromJson(json.decode(response.body));
  });
}

class SignUpData {
  String email;
  String password;
  String apiKey =
      "\$2a\$08\$mVOgAKAbdz6cco/bkjIg4.ieLY8Vo6pd7XwErmlTVSIRjtwbDkMX2";
  String tag = "tweak_app_registration";
  String source = "software";
  String category = "student";

  SignUpData(this.email, this.password, this.apiKey, this.tag, this.source,
      this.category);

  factory SignUpData.fromJson(Map<String, dynamic> json) => new SignUpData(
      json["email"],
      json["password"],
      json["api_key"],
      json["tag"],
      json["source"],
      json["category"]);

  Map toMap() {
    var map = new Map<String, dynamic>();
    map['email'] = email;
    map['password'] = password;
    map['api_key'] = apiKey;
    map['tag'] = tag;
    map['source'] = source;
    map['category'] = category;
    return map;
  }
}

Future<Res> signUpUser(Map<String, dynamic> map) async {
  return await http.post("https://cloud.avishkaar.cc/api/auth/register", body: map).then((http.Response response) {
    print(response.body);
    print(json.decode(response.body));
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      new Exception("Login Failed");
    }
    return Res.fromJson(json.decode(response.body));
  });
}

Future<List<DataFromJsonPlaceholder>> getJsonDataFromJsonPlaceHolder() async {
  List<DataFromJsonPlaceholder> datalist;
  await http.get("https://jsonplaceholder.typicode.com/posts").then((onValue) {
    print(onValue.body);
    List<dynamic> list = json.decode(onValue.body);
    datalist = list.map((json) {
      return DataFromJsonPlaceholder.fromJSON(json);
    }).toList();
  });

  return datalist;
}
