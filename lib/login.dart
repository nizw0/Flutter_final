import 'package:final_project/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';
import 'package:final_project/authentication.dart';
import 'package:provider/provider.dart';

void main() => runApp(const LoginPage());

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Login();
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  var _pwdObscure = false;
  final GlobalKey _formKey = GlobalKey<FormState>();
  late final FirebaseAuth _firebaseAuth;
  late final Authentication _auth = Authentication(_firebaseAuth);

  @override
  void initState() {
    super.initState();
    _email.addListener(() => setState(() {}));
    _password.addListener(() {
      setState(() {
        if (_password.text.isEmpty) {
          _pwdObscure = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: '登入',
        iconButton: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 80,
                  child: TextFormField(
                    autofocus: true,
                    controller: _email,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: '電子信箱',
                      prefixIcon: const Icon(Icons.account_box),
                      suffixIcon: _email.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: _email.clear,
                              icon: const Icon(Icons.clear),
                            ),
                    ),
                    validator: (value) {
                      return null;
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width - 50,
                  height: 80,
                  child: TextFormField(
                    autofocus: true,
                    controller: _password,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: '密碼',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: _password.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  _pwdObscure = !_pwdObscure;
                                });
                              },
                              icon: Icon(_pwdObscure ? Icons.visibility : Icons.visibility_off),
                            ),
                    ),
                    obscureText: _pwdObscure,
                    validator: (value) {
                      return null;
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
                  onPressed: () {
                    context
                        .read<Authentication>()
                        .signIn(email: _email.text.trim(), password: _password.text.trim())
                        .then((value) => value
                            ? Navigator.pop(context)
                            : ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('登入失敗'))));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '登入',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '註冊',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
