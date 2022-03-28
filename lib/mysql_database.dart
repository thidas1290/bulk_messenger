import 'package:mysql1/mysql1.dart';

class Connection {
  static const String _host = '98.142.97.194';
  static const int _port = 3306;
  static const String _user = 'hyperfle_smsapi';
  static const String _db = 'hyperfle_sms_gateway';
  static const String _password = 'HyAPi@2021';

  Connection();

  Future<MySqlConnection> initConnection() async {
    final conn = await MySqlConnection.connect(
      ConnectionSettings(
          host: _host, port: _port, user: _user, db: _db, password: _password),
    );

    return conn;
  }

  Future closeConnection(MySqlConnection conn) {
    print('connection closed');
    return conn.close();
  }
}
