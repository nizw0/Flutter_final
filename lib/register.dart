import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/main.dart';
import 'package:flow_builder/flow_builder.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        backgroundColor: Colors.white,
        applyElevationOverlayColor: true,
        fontFamily: 'Time News Roman',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 14.0),
        ),
      ),
      home: const Register(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(
        title: Text('註冊'),
      ),
      body: Column(
        children: const [
          RegisterForm(),
        ],
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _emailController = TextEditingController();
  final _pwdController = TextEditingController();
  final _repwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _pwdObscure = true;
  var _repwdObscure = true;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      setState(() {});
    });
    _pwdController.addListener(() {
      setState(() {
        if (_pwdController.text.isEmpty) {
          _pwdObscure = true;
        }
      });
    });
    _repwdController.addListener(() {
      setState(() {
        if (_repwdController.text.isEmpty) {
          _repwdObscure = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _pwdController.dispose();
    _repwdController.dispose();
    super.dispose();
  }

  bool _checkEmail(email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 80,
                child: TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: '電子信箱',
                    prefixIcon: const Icon(Icons.email),
                    suffixIcon: _emailController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: _emailController.clear,
                            icon: const Icon(Icons.clear),
                          ),
                  ),
                  validator: (value) {
                    return value!.trim().isEmpty ? '信箱不能為空' : (_checkEmail(value.trim()) ? null : '請輸入正確的信箱');
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
                  controller: _pwdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: '密碼',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: _pwdController.text.isEmpty
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
                  maxLength: 16,
                  obscureText: _pwdObscure,
                  validator: (value) {
                    return value!.trim().length > 7 ? null : '密碼不得少於8碼';
                  },
                  onTap: () {
                    _pwdController.selection =
                        TextSelection(baseOffset: 0, extentOffset: _pwdController.value.text.length);
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
                  controller: _repwdController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: '重複輸入密碼',
                    prefixIcon: const Icon(Icons.lock_open_outlined),
                    suffixIcon: _repwdController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                _repwdObscure = !_repwdObscure;
                              });
                            },
                            icon: Icon(_repwdObscure ? Icons.visibility : Icons.visibility_off),
                          ),
                  ),
                  maxLength: 16,
                  obscureText: _repwdObscure,
                  validator: (value) {
                    return _pwdController.text == value!.trim() ? null : '請輸入相同的密碼';
                  },
                  onTap: () {
                    _repwdController.selection =
                        TextSelection(baseOffset: 0, extentOffset: _repwdController.value.text.length);
                  },
                )),
            const SizedBox(
              height: 140,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Processing Data')));
                  } else {
                    // _formKey.currentState.save();
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
