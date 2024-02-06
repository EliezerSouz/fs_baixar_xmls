import 'dart:async';

import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection(
    String _host, int _port, String _user, String _db, String _password) async {
  final settings = ConnectionSettings(
    host: _host,
    port: _port,
    user: _user,
    db: _db,
    password: _password,
  );
  print('Conexão com o servidor na porta $_port ... ');
  return await MySqlConnection.connect(settings);
}
