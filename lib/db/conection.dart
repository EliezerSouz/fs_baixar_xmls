import 'dart:async';

import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> getConnection(
    String host, int port, String useriD, String db, String password) async {
  final settings = ConnectionSettings(
    host: host,
    port: port,
    user: useriD,
    db: db,
    password: password,
  );
  print('Conexão com o servidor na porta $port ... ');
  return await MySqlConnection.connect(settings);
}
