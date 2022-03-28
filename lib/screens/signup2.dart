import 'package:bulk_messenger/mysql_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants.dart';
import 'package:crypt/crypt.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp2 extends StatefulWidget {
  SignUp2({Key? key, @required this.id}) : super(key: key);
  int? id;

  @override
  _SignUp2State createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  bool isVisible = false;
  String mail = '';

  final TextEditingController? textController_1 = TextEditingController();
  final TextEditingController? textController_2 = TextEditingController();
  final TextEditingController? textController_3 = TextEditingController();
  final TextEditingController? textController_4 = TextEditingController();

  bool isEmpty_1 = false;
  bool isEmpty_2 = false;
  bool isEmpty_3 = false;
  bool isEmpty_4 = false;

  @override
  void initState() {
    getMail();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getMail() async {
    var con = Connection();
    await con.initConnection().then((conn) async {
      await conn.query('select customer_email from Customers where id = ?',
          [widget.id.toString()]).then((data) {
        for (var row in data) {
          setState(() {
            mail = row[0];
          });
        }
      }).catchError((e) {
        Fluttertoast.showToast(msg: "querry Error");
        mail = "Error Occured";
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: 'Network Error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Register",
                            style: kHeadline,
                          ),
                          const Text(
                            "Create new account to get started.",
                            style: kBodyText2,
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text(
                            'You are Registering with ',
                            style: kBodyText,
                          ),
                          Text(mail, style: kBodyText3),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  if (text.isEmpty || text.length < 2) {
                                    isEmpty_1 = true;
                                  } else {
                                    isEmpty_1 = false;
                                  }
                                });
                              },
                              controller: textController_1,
                              style: kBodyText.copyWith(color: Colors.white),
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorText: isEmpty_1
                                    ? "Name shouldn't be empty"
                                    : null,
                                contentPadding: const EdgeInsets.all(20),
                                hintText: "Name",
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
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  String pattern =
                                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                  RegExp regex = RegExp(pattern);

                                  if (!regex.hasMatch(text)) {
                                    isEmpty_2 = true;
                                  } else {
                                    isEmpty_2 = false;
                                  }
                                });
                              },
                              controller: textController_2,
                              style: kBodyText.copyWith(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorText:
                                    isEmpty_2 ? "Enter a valid Email" : null,
                                contentPadding: const EdgeInsets.all(20),
                                hintText: "E - mail",
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
                            child: TextField(
                              onChanged: (text) {
                                setState(() {
                                  if (text.isEmpty) {
                                    isEmpty_3 = true;
                                  } else if (text.length > 10 ||
                                      text.length < 10) {
                                    isEmpty_3 = true;
                                  } else {
                                    try {
                                      int.parse(text);
                                      isEmpty_3 = false;
                                    } catch (e) {
                                      isEmpty_3 = true;
                                    }
                                  }
                                });
                              },
                              controller: textController_3,
                              style: kBodyText.copyWith(color: Colors.white),
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                errorText:
                                    isEmpty_3 ? "Invalid mobile number" : null,
                                contentPadding: const EdgeInsets.all(20),
                                hintText: "Mobile",
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
                                  if (text.isEmpty ||
                                      text.length < 8 ||
                                      text.length > 15) {
                                    isEmpty_4 = true;
                                  } else {
                                    if (text.contains(' ')) {
                                      isEmpty_4 = true;
                                    } else {
                                      isEmpty_4 = false;
                                    }
                                  }
                                });
                              },
                              controller: textController_4,
                              obscureText: !isVisible,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                errorText: isEmpty_4
                                    ? "Password should atleast 8 characters long with\n no spaces"
                                    : null,
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isVisible
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: kBodyText,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text(
                            "Sign In",
                            style: kBodyText.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      borderRadius: kRadius,
                      onTap: () async {
                        if ((!isEmpty_1 &&
                                !isEmpty_2 &&
                                !isEmpty_3 &&
                                !isEmpty_4) &&
                            (textController_1!.text.isNotEmpty &&
                                textController_2!.text.isNotEmpty &&
                                textController_3!.text.isNotEmpty &&
                                textController_4!.text.isNotEmpty)) {
                          Connection connection = Connection();

                          await connection.initConnection().then((conn) async {
                            int? id;

                            try {
                              var data = await conn.query(
                                  'select id from User_login where user_email = ?',
                                  [textController_2!.text]);

                              for (var item in data) {
                                id = item[0];
                              }

                              if (textController_2!.text == mail) {
                                setState(() {
                                  isEmpty_2 = true;
                                  return;
                                });
                                return;
                              } else if (id != null) {
                                setState(() {
                                  isEmpty_2 = true;
                                });
                                return;
                              } else {
                                data = await conn.query(
                                    'select id from User_login where user_mobile = ?',
                                    [textController_3!.text]);

                                for (var item in data) {
                                  id = item[0];
                                }
                                if (id != null) {
                                  setState(() {
                                    isEmpty_3 = true;
                                  });
                                  return;
                                } else {
                                  conn.query(
                                      'insert into User_login (id, registered_email, user_email, user_name, password, user_mobile, status ) values (?, ?, ?, ?, ?, ?, ?) ',
                                      [
                                        widget.id,
                                        mail,
                                        textController_2!.text,
                                        textController_1!.text.trim(),
                                        Crypt.sha256(textController_4!.text,
                                                salt: kSalt)
                                            .toString(),
                                        textController_3!.text,
                                        'active'
                                      ]).then((value) async {
                                    try {
                                      SharedPreferences loginData =
                                          await SharedPreferences.getInstance();
                                      await loginData.setInt('id', id!);
                                      await loginData.setBool('logged', true);
                                    } catch (e) {
                                      Fluttertoast.showToast(
                                          msg: 'Shared Preferences Error');
                                    }
                                    Navigator.of(context)
                                        .pushNamed('/dashboard');
                                  }).catchError((e) {
                                    Fluttertoast.showToast(
                                        msg: "something went wrong");
                                    setState(() {});
                                  });
                                }
                              }
                            } catch (e) {
                              Fluttertoast.showToast(msg: "Querry Error");
                              setState(() {});
                              return;
                            }
                          }).catchError((e) {
                            Fluttertoast.showToast(msg: "Network Error");
                            return;
                          });

                          // Navigator.push(context, MaterialPageRoute(builder: (builder) => DashBoard(conn: conn)));
                        } else {
                          setState(() {});
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                            color: Colors.white, borderRadius: kRadius),
                        child: const Center(
                          child: Text(
                            'Register',
                            style: kButtonText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
