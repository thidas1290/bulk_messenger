import 'package:bulk_messenger/mysql_database.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypt/crypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Connection? connection;

  bool isPasswordVisible = false;

  final TextEditingController? textController_1 = TextEditingController();
  final TextEditingController? textController_2 = TextEditingController();

  bool isEmpty_1 = false;
  bool isEmpty_2 = false;
  bool enabled = true;

  Future<bool?> _checkIfLogged() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    final state = instance.getBool('logged');

    if (state == true) {
      Navigator.of(context).pushNamed('/dashboard');
      return state;
    } else {
      return state;
    }
  }

  @override
  void initState() {
    enabled = true;
    _checkIfLogged();
    super.initState();
    Navigator.of(context).pushNamed('/dashboard');
  }

  void checkFromDatabase() async {
    if ((!isEmpty_1 && !isEmpty_2) &&
        (textController_1!.text.isNotEmpty &&
            textController_2!.text.isNotEmpty)) {
      setState(() {
        enabled = false;
      });
      connection = Connection();

      connection!.initConnection().then((conn) async {
        conn.query('select id, password from User_login where user_email = ?',
            [textController_1!.text]).then((data) async {
          int? id;
          String? password;

          for (var item in data) {
            id = item[0];
            password = item[1];
          }
          if (id != null) {
            if (Crypt.sha256(
                  textController_2!.text,
                  salt: kSalt,
                ).toString() ==
                password) {
              connection!.closeConnection(conn);
              try {
                SharedPreferences loginData =
                    await SharedPreferences.getInstance();
                await loginData.setInt('id', id);
                await loginData.setBool('logged', true);
              } catch (e) {
                Fluttertoast.showToast(msg: 'Shared Preferences Error');
              }
              setState(() {
                enabled = true;
              });
              Navigator.of(context)
                  .pushNamed(
                '/dashboard',
              )
                  .then((value) {
                final e = _checkIfLogged();
                setState(() {});
              });
            } else {
              Fluttertoast.showToast(msg: "Invalid Credentials");
              setState(() {
                enabled = true;
                isEmpty_2 = true;
              });
            }
          } else {
            setState(() {
              isEmpty_1 = true;
              enabled = true;
            });
          }
        }).catchError((e) {
          Fluttertoast.showToast(msg: "Querry Error");
        });
      }).catchError((e) {
        Fluttertoast.showToast(msg: "Network Error", fontSize: 16.0);
      });
    }
  }

  @override
  void dispose() {
    textController_1?.dispose();
    textController_2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
            child: CustomScrollView(
          reverse: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Welcome back.",
                            style: kHeadline,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "You've been missed!",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = RegExp(pattern);

                                  if (!regex.hasMatch(text)) {
                                    isEmpty_1 = true;
                                  } else {
                                    isEmpty_1 = false;
                                  }
                                });
                              },
                              controller: textController_1,
                              style: kBodyText.copyWith(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorText:
                                    isEmpty_1 ? "Enter a valid Email" : null,
                                contentPadding: const EdgeInsets.all(20),
                                hintText: "e - mail",
                                hintStyle: kBodyText,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kFocusBorderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              style: kBodyText.copyWith(
                                color: Colors.white,
                              ),
                              onChanged: (text) {
                                setState(() {
                                  if (text.isEmpty) {
                                    isEmpty_2 = true;
                                  } else {
                                    if (text.contains(' ')) {
                                      isEmpty_2 = true;
                                    } else {
                                      isEmpty_2 = false;
                                    }
                                  }
                                });
                              },
                              controller: textController_2,
                              obscureText: !isPasswordVisible,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                errorText:
                                    isEmpty_2 ? 'invalid password' : null,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(20),
                                hintText: 'Password',
                                hintStyle: kBodyText,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: kFocusBorderColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Dont't have an account? ",
                          style: kBodyText,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed('/signup1');
                          },
                          child: Text(
                            'Register',
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      borderRadius: kRadius,
                      onTap: enabled
                          ? () {
                              checkFromDatabase();
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            color: Colors.white, borderRadius: kRadius),
                        child: const Center(
                          child: Text(
                            'Sign In',
                            style: kButtonText,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
