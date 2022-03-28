import 'package:bulk_messenger/mysql_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/card.dart';

import '../side_bar.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({
    Key? key,
  }) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double balance = 497.45;
  String user = '';
  String email = '';

  @override
  void initState() {
    _getUserInfo(_getData);
    super.initState();
  }

  Future<int?> _getData() {
    return SharedPreferences.getInstance().then((data) {
      return data.getInt('id');
    });
  }

  Future<bool?> _getUserInfo(Future<int?> Function() state) async {
    int? id = await state();

    final con = Connection();

    con.initConnection().then((conn) {
      conn.query('select user_name, user_email from User_login where id = ?',
          [id]).then((data) {
        String name = '';
        String mail = '';
        for (var item in data) {
          // just a single iteration
          name = item[0];
          mail = item[1];
        }
        setState(() {
          user = name;
          email = mail;
        });
        return true;
      }).catchError((e) {
        user = "Error Occured";
        Fluttertoast.showToast(msg: 'Querry Error');
      });
    }).catchError((e) {
      Fluttertoast.showToast(
        msg: 'Network Error',
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    });
    return true;
  }

  void updateBalance() {
    setState(() {
      balance = 90;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        drawer: SideBar(
          name: user,
          email: email,
        ),
        appBar: AppBar(
          title: const Text("DashBoard"),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: WillPopScope(
          onWillPop: () async => false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      padding: const EdgeInsets.all(15),
                      margin: EdgeInsets.only(
                        top: height * 0.06,
                        left: 15,
                        right: 15,
                      ),
                      decoration: BoxDecoration(
                        color: kBackgroundColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                        border: Border.all(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      height: height * 0.2,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Your Available Balance',
                              style: kBodyText2,
                            ),
                            Text(
                              'R.S $balance',
                              style: kBodyText3.copyWith(
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                    color: Color(0xff201b23),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/sms')
                                      .then((value) {
                                    updateBalance();
                                  });
                                },
                                child: const CustomCard(
                                  icon: Icons.send,
                                  text: "Send SMS",
                                  radius: 50,
                                ),
                              ),
                            ),
                            const SizedBox(width: divider),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: const CustomCard(
                                  icon: Icons.history,
                                  text: "History",
                                  radius: 50,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: divider,
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: const CustomCard(
                                  icon: Icons.schedule_send,
                                  text: "Scheduled Send",
                                  radius: 50,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: divider,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed('/contacts')
                                      .then((s) {
                                    updateBalance();
                                  });
                                },
                                child: const CustomCard(
                                  icon: Icons.contacts,
                                  text: "My Contact Groups",
                                  radius: 50,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
