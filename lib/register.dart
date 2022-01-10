import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project/main.dart';
import 'package:final_project/profile.dart';

void main() => runApp(const RegisterPage());

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Register();
  }
}

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  static const _duration = Duration(milliseconds: 300);
  static const _curve = Curves.fastOutSlowIn;

  final _email = TextEditingController();
  final _pwd = TextEditingController();
  final _repwd = TextEditingController();
  final _name = TextEditingController();
  final _id = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _otp = TextEditingController();

  var _pwdObscure = true;
  var _repwdObscure = true;

  final _accountFormKey = GlobalKey<FormState>();
  final _infoFormKey = GlobalKey<FormState>();
  final _phoneFormKey = GlobalKey<FormState>();
  late final PageController _controller;

  bool _checkEmail(email) =>
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);

  @override
  void initState() {
    super.initState();

    _email.addListener(() => setState(() {}));
    _pwd.addListener(() {
      setState(() {
        if (_pwd.text.isEmpty) {
          _pwdObscure = true;
        }
      });
    });
    _repwd.addListener(() {
      setState(() {
        if (_repwd.text.isEmpty) {
          _repwdObscure = true;
        }
      });
    });
    _name.addListener(() => setState(() {}));
    _id.addListener(() => setState(() {}));
    _address.addListener(() => setState(() {}));
    _phone.addListener(() => setState(() {}));

    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _email.dispose();
    _pwd.dispose();
    _repwd.dispose();
    _id.dispose();
    _address.dispose();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: '註冊',
        iconButton: IconButton(
          onPressed: () {
            if (_controller.page?.round() == _controller.initialPage) {
              Navigator.pop(context);
            } else {
              _controller.previousPage(duration: _duration, curve: _curve);
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: PageView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        children: [
          Column(children: [
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _accountFormKey,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                              controller: _email,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: '電子信箱',
                                prefixIcon: const Icon(Icons.email),
                                suffixIcon: _email.text.isEmpty
                                    ? null
                                    : IconButton(
                                        onPressed: _email.clear,
                                        icon: const Icon(Icons.clear),
                                      ),
                              ),
                              validator: (value) {
                                return value!.trim().isEmpty
                                    ? '信箱不能為空'
                                    : (_checkEmail(value.trim()) ? null : '請輸入正確的信箱');
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
                              controller: _pwd,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: '密碼',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: _pwd.text.isEmpty
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
                                _pwd.selection = TextSelection(baseOffset: 0, extentOffset: _pwd.value.text.length);
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
                              controller: _repwd,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                labelText: '重複輸入密碼',
                                prefixIcon: const Icon(Icons.lock_open_outlined),
                                suffixIcon: _repwd.text.isEmpty
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
                                return _pwd.text == value!.trim() ? null : '請輸入相同的密碼';
                              },
                              onTap: () {
                                _repwd.selection = TextSelection(baseOffset: 0, extentOffset: _repwd.value.text.length);
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
                              if (_accountFormKey.currentState!.validate()) {
                                _controller.nextPage(duration: _duration, curve: _curve);
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
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
            ),
          ]),
          Column(
            children: [
              Form(
                key: _infoFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                controller: _name,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: '姓名',
                                  prefixIcon: const Icon(Icons.drive_file_rename_outline),
                                  suffixIcon: _name.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: _name.clear,
                                          icon: const Icon(Icons.clear),
                                        ),
                                ),
                                validator: (value) {
                                  return value!.trim().isEmpty ? '姓名不能為空' : null;
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
                                controller: _id,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: '身份證字號',
                                  prefixIcon: const Icon(Icons.person),
                                  suffixIcon: _id.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: _id.clear,
                                          icon: const Icon(Icons.clear),
                                        ),
                                ),
                                maxLength: 10,
                                validator: (value) {
                                  return value!.trim().length == 10 ? null : '請輸入正確的身份證字號';
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
                                controller: _address,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: '地址',
                                  prefixIcon: const Icon(Icons.location_on),
                                  suffixIcon: _address.text.isEmpty
                                      ? null
                                      : IconButton(
                                          onPressed: _address.clear,
                                          icon: const Icon(Icons.clear),
                                        ),
                                ),
                                validator: (value) {
                                  return null;
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
                                if (_infoFormKey.currentState!.validate()) {
                                  _controller.nextPage(duration: _duration, curve: _curve);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
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
              ),
            ],
          ),
          Column(
            children: [
              Form(
                key: _phoneFormKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                controller: _phone,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: '電話號碼',
                                  prefixIcon: const Icon(Icons.phone),
                                  suffixIcon: _phone.text.trim().length != 10
                                      ? null
                                      : IconButton(
                                          onPressed: () {},
                                          icon: const Icon(Icons.send),
                                        ),
                                ),
                                maxLength: 10,
                                validator: (value) {
                                  return value!.trim().length == 10 ? null : '請輸入正確的電話號碼';
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
                                controller: _otp,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  labelText: '驗證碼',
                                  prefixIcon: const Icon(Icons.check),
                                ),
                                maxLength: 4,
                                validator: (value) {
                                  return value!.trim().length == 4 ? null : '請輸入正確的驗證碼';
                                },
                                onTap: () {
                                  _otp.selection = TextSelection(baseOffset: 0, extentOffset: _otp.value.text.length);
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
                              onPressed: () async {
                                if (_phoneFormKey.currentState!.validate()) {
                                  var email = _email.text.trim();
                                  var password = _pwd.text.trim();
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(email: email, password: password);
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                                  User? user = FirebaseAuth.instance.currentUser;
                                  FirebaseFirestore.instance.collection('data').doc(user?.uid).set({
                                    'name': _name.text.trim(),
                                    'id': _id.text.trim(),
                                    'address': _address.text.trim(),
                                    'email': _email.text.trim(),
                                    'phone': _phone.text.trim(),
                                    'permission': '0',
                                  });
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '送出',
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
