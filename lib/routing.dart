import 'package:bulk_messenger/group.dart';
import 'package:bulk_messenger/screens/login.dart';
import 'screens/sign_up.dart';
import 'screens/signup2.dart';
import 'screens/dashboard.dart';
import 'screens/sms.dart';
import 'screens/contacts.dart';
import 'screens/contact_editor.dart';
import 'screens/contact_picker.dart';
import 'screens/my_contacts.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Login());
      case "/signup1":
        return MaterialPageRoute(builder: (_) => SignUp());
      case "/signup2":
        if (args is int?) {
          return MaterialPageRoute(
              builder: (_) => SignUp2(
                    id: args,
                  ));
        }
        return _errorRoute();
      case "/dashboard":
        return MaterialPageRoute(builder: (_) => DashBoard());
      case "/sms":
        return MaterialPageRoute(builder: (_) => SendMessage());
      case "/contacts":
        return MaterialPageRoute(builder: (_) => Contacts());
      case "/editor":
        if (args is Group) {
          return MaterialPageRoute(
              builder: (_) => Selector(
                    currentGroup: args,
                  ));
        } else {
          return _errorRoute();
        }
      case "/picker":
        if (args is Group) {
          return MaterialPageRoute(
            builder: (_) => ContactPicker(
              page: args,
            ),
          );
        } else {
          return _errorRoute();
        }
      case "/my_contacts":
        return MaterialPageRoute(
          builder: (_) => MyContactSelector(),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
