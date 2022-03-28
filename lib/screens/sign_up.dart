import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants.dart';
import '../mysql_database.dart';

class SignUp extends StatefulWidget {
  SignUp({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool passwordVisible = false;
  String? hintText;
  bool isEmpty_1 = false;

  TextInputType? inputType;

  TextEditingController textController =
      TextEditingController(text: "sapmb.gov@gmail.com");

  @override
  void initState() {
    super.initState();
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Enter Your Email to check Eligibility',
                                style: kBodyText,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                                  controller: textController,
                                  style:
                                      kBodyText.copyWith(color: Colors.white),
                                  keyboardType: inputType,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                    errorText:
                                        isEmpty_1 ? "Enter a valid mail" : null,
                                    contentPadding: const EdgeInsets.all(20),
                                    hintText: hintText,
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
                            ],
                          ),
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
                            Navigator.of(context).pop();
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
                        // ignore: prefer_typing_uninitialized_variables

                        if (textController.text.isNotEmpty && !isEmpty_1) {
                          Connection connection = Connection();
                          await connection.initConnection().then((conn) async {
                            await conn.query(
                                'select id from Customers where customer_email = ?',
                                [textController.text]).then((data) {
                              int? id;
                              for (var item in data) {
                                id = item[0];
                              }
                              if (id != null) {
                                connection.closeConnection(conn);
                                Navigator.of(context)
                                    .pushNamed('/signup2', arguments: id);
                              } else {
                                setState(() {
                                  isEmpty_1 = true;
                                });
                              }
                            }).catchError((e) {
                              Fluttertoast.showToast(
                                  msg: "Something went wrong");
                            });

                            // await conn.query('select id from User_login where registered_email = ?', [textController.text]).then((data) {
                            //   int? id;
                            //   for (var item in data) {
                            //     id = item[0];
                            //   }
                            //   if (id != null) {

                            //   } else {

                            //   }

                            // }).catchError((e){});
                          }).catchError((e) {
                            Fluttertoast.showToast(msg: "Network Error");
                          });
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
                            'Continue',
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
