import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatelessWidget {
  SideBar({Key? key, this.name, this.email}) : super(key: key);
  String? name;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Builder(builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(0),
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                child: Text(
                  // name![0].toUpperCase(),
                  "daa",
                  style: kBodyText2,
                ),
                backgroundColor: Colors.black,
              ),
              accountName: Text(
                name!,
                style: kBodyText2,
              ),
              accountEmail: Text(
                email!,
                style: kBodyText,
              ),
              decoration: const BoxDecoration(
                color: kBackgroundColor,
              ),
            ),
            ListTile(
              tileColor: Colors.white,
              onTap: () async {
                SharedPreferences data = await SharedPreferences.getInstance();
                await data.setBool('logged', false);
                await data.setInt('id', -1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              leading: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              title: Text("Log Out",
                  style: kBodyText3.copyWith(color: Colors.black)),
            ),
          ],
        );
      }),
    );
  }
}
