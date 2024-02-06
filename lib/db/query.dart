import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:Baixar_Xml/db/conection.dart';

Future<List<Map<String, dynamic>>> getDadosXmls(
    String host,
    int port,
    String user,
    String db,
    String password,
    String dataInicial,
    String dataFinal,
    String nfe,
    String nfce,
    ScaffoldMessengerState scaffoldMessenger,
    String _nomeCliente) async {
  final conn = await getConnection(host, port, user, db, password);

  try {
    sendMessage(
        scaffoldMessenger,
        "Conectado ao banco de dados $_nomeCliente... Aguarde... Executando consulta...",
        2, Colors.blue.shade800);
    print("Conectado ao banco de dados $db. Executando consulta...");
    List<Map<String, dynamic>> dataList = [];
    int i = 0, total = 0;

    if (nfe != "") {
      var results = await conn.query(
        "select nx.xml_final, n.fs_fase, nx.emissor from nota_cabecalho n join nota_xml nx on nx.nota_cabecalho_id = n.id where nx.xml_final is not null AND n.ide_demi BETWEEN ? AND ? AND emissor IN ('P') AND modelo IN (55) ORDER BY data_nota;",
        [dataInicial, dataFinal],
      );

      for (var row in results) {
        var xmlBlob = row.fields['xml_final']
            as Blob; // Substitua pela classe real do Blob
        var xmlString = utf8.decode(Uint8List.fromList(xmlBlob.toBytes()));

        dataList.add({
          'xml_final': xmlString,
          'fs_fase': row.fields['fs_fase'],
          'emissor': row.fields['emissor'],
        });
        i++;
      }
      sendMessage(scaffoldMessenger, "Total NFe: $i", 1, Colors.blue.shade800);
      print("Total NFe: $i.");
      total += i;
      i = 0;
    }

    if (nfce != "") {
      var results = await conn.query(
        "select nx.xml_final, n.fs_fase, nx.emissor from nota_cabecalho n join nota_xml nx on nx.nota_cabecalho_id = n.id where nx.xml_final is not null AND n.ide_demi BETWEEN ? AND ? AND emissor IN ('P') AND modelo IN (65) ORDER BY data_nota;",
        [dataInicial, dataFinal],
      );

      for (var row in results) {
        var xmlBlob = row.fields['xml_final']
            as Blob; // Substitua pela classe real do Blob
        var xmlString = utf8.decode(Uint8List.fromList(xmlBlob.toBytes()));

        dataList.add({
          'xml_final': xmlString,
          'fs_fase': row.fields['fs_fase'],
          'emissor': row.fields['emissor'],
        });
        i++;
      }
      total += i;
      sendMessage(scaffoldMessenger, "Total NFCe: $i", 1, Colors.blue.shade800);
      print("Total NFCe: $i. Cliente $db.");
    }

    await Future.delayed(Duration(seconds: 3));

    sendMessage(
        scaffoldMessenger,
        "Cópia finalizada: $total xmls... De: ${formatDate(dataInicial)} até ${formatDate(dataFinal)}",
        4, Colors.blue.shade800);
    print("Total: $total notas eletrônicas. Cliente $db");

    return dataList;
  } on TimeoutException catch (e) {
    sendMessage(scaffoldMessenger, "A consulta excedeu o tempo limite: $e", 5, Colors.red.shade800);
    print("A consulta excedeu o tempo limite: $e");
    return [];
  } on SocketException catch (e) {
    sendMessage(scaffoldMessenger, "Erro de soquete: $e", 5, Colors.red.shade800);
    print("Erro de soquete: $e");
    return [];
  } finally {
    await conn.close();
  }
}

String formatDate(String date) {
  final parsedDate = DateTime.parse(date);
  final formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
  return formattedDate;
}

void sendMessage(
    ScaffoldMessengerState scaffoldMessenger, String message, int duracao, Color cor) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Container(child: Center(child: Text(message))),
      duration: Duration(seconds: duracao),
      backgroundColor:cor,
    ),
  );
}
