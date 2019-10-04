import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'databaseHelper.dart' as dbHelper;
import 'communicate.dart';

void main() => runApp(MaterialApp(
      home: LoginPage(),
    ));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: <Widget>[
            Login(),
            SignUp(),
            JsonFromJPDisplay(),
          ],
        ),
      ),
    );
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

String email;
String password;
final _emailController = TextEditingController();
final _passwordController = TextEditingController();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 500,
                child: Card(
                  color: Color(0xffb74093),
                  child: Image.network(
                      "https://images.avishkaar.cc/brand/logo-white.png"),
                  elevation: 0,
                ),
              ),
            )
          ],
        ),
        EmailOrPasswordTextField("Email", _emailController, false),
        EmailOrPasswordTextField("Password", _passwordController, true),
        Center(
          child: RaisedButton(
            onPressed: () async {
              LoginData loginData = new LoginData(
                  _emailController.text, _passwordController.text);
              Res res = await postDataToServer(loginData.toMap());
              print(res.userId);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Text("Login"),
          ),
        )
      ],
    );
  }
}

class EmailOrPasswordTextField extends StatelessWidget {
  final String hint;
  final controller;
  final bool obscure;
  EmailOrPasswordTextField(this.hint, this.controller, this.obscure);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.all(20),
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: InputDecoration(
                  //Add th Hint text here.
                  hintText: hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  )),
              onChanged: (data) {},
            ),
          ),
        )
      ],
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final String apiKey =
      "\$2a\$08\$mVOgAKAbdz6cco/bkjIg4.ieLY8Vo6pd7XwErmlTVSIRjtwbDkMX2";
  final String tag = "tweak_app_registration";
  final String source = "software";
  final String category = "student";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EmailOrPasswordTextField("Email", signUpEmailController, false),
        EmailOrPasswordTextField("Password", signUpPasswordController, true),
        Center(
          child: RaisedButton(
            onPressed: () async {
              SignUpData signupData = new SignUpData(signUpEmailController.text,
                  signUpPasswordController.text, apiKey, tag, source, category);
              Res res = await signUpUser(signupData.toMap());
              print(res.userId);
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Text("Sign-Up"),
          ),
        )
      ],
    );
  }
}

class JsonFromJPDisplay extends StatefulWidget {
  @override
  _JsonFromJPDisplayState createState() => _JsonFromJPDisplayState();
}

class _JsonFromJPDisplayState extends State<JsonFromJPDisplay> {
  List<DataFromJsonPlaceholder> dataList;
  bool isLoading = true;

  void dataLoad() async {
    dataList = await getJsonDataFromJsonPlaceHolder();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    dataLoad();
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Container(height: 400, child: getProgressOrData(isLoading)),
        ],
      ),
    );
  }

  Widget getProgressOrData(bool isLoading) {
    if (isLoading) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(child: Center(child: CircularProgressIndicator())),
          ),
        ],
      );
    } else {
      return ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, position) => ListTile(
                title: Text(dataList[position].title),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SecondScreen(dataList[position].body)));
                },
              ));
    }
  }
}

class SecondScreen extends StatefulWidget {
  final String details;

  SecondScreen(this.details);

  @override
  _SecondScreenState createState() => _SecondScreenState(details);
}

class _SecondScreenState extends State<SecondScreen> {
  String details;

  _SecondScreenState(this.details);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Text(details),
              ],
            ),
          )
        ],
      ),
    );
  }
}
