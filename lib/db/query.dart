// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:Baixar_Xml/db/conexao_monofasico/stringsMonofasicos.dart';
import 'package:Baixar_Xml/modulos/carregarDados.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mysql1/mysql1.dart';
import 'package:Baixar_Xml/db/conection.dart';
import 'package:flutter_excel/excel.dart';

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
    String nomeCliente) async {
  final conn = await getConnection(host, port, user, db, password);

  try {
    sendMessage(
        scaffoldMessenger,
        "Conectado ao banco de dados $nomeCliente... Aguarde... Executando consulta...",
        2,
        Colors.blue.shade800);
    print("Conectado ao banco de dados $db. Executando consulta...");
    List<Map<String, dynamic>> dataList = [];
    int i = 0, total = 0;

    if (nfe != "") {
      var results = await conn.query(
        """select nx.xml_final, n.fs_fase, nx.emissor from nota_cabecalho n 
        join nota_xml nx on nx.nota_cabecalho_id = n.id 
        where nx.xml_final is not null 
          AND n.ide_demi BETWEEN ? AND ? 
          AND emissor IN ('P') 
          AND modelo IN (55) 
        ORDER BY data_nota;""",
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
        """select nx.xml_final, n.fs_fase, nx.emissor from nota_cabecalho n 
        join nota_xml nx on nx.nota_cabecalho_id = n.id 
        where nx.xml_final is not null 
          AND n.ide_demi BETWEEN ? AND ? 
          AND emissor IN ('P') 
          AND modelo IN (65) 
        ORDER BY data_nota;""",
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
      results = await conn.query(
        """select n.nota, n.xml, n.modelo from nota_inutilizacao n 
              where n.xml is not null 
                AND n.data BETWEEN ? AND ? 
                AND modelo IN (65) 
              ORDER BY n.nota;""",
        [dataInicial, dataFinal],
      );

      for (var row in results) {
        var xmlBlob = row.fields['xml'] as Blob;
        var xmlString = utf8.decode(Uint8List.fromList(xmlBlob.toBytes()));

        dataList.add({
          'xml_final': xmlString,
          'fs_fase': "999",
          'emissor': "P",
        });
        i++;
      }

      total += i;
      sendMessage(scaffoldMessenger, "Total NFCe: $i", 1, Colors.blue.shade800);
      print("Total NFCe: $i. Cliente $db.");
    }

    await Future.delayed(const Duration(seconds: 3));

    sendMessage(
        scaffoldMessenger,
        "Cópia finalizada: $total xmls... De: ${formatDate(dataInicial)} até ${formatDate(dataFinal)}",
        4,
        Colors.blue.shade800);
    print("Total: $total notas eletrônicas. Cliente $db");

    return dataList;
  } on TimeoutException catch (e) {
    sendMessage(scaffoldMessenger, "A consulta excedeu o tempo limite: $e", 5,
        Colors.red.shade800);
    print("A consulta excedeu o tempo limite: $e");
    return [];
  } on SocketException catch (e) {
    sendMessage(
        scaffoldMessenger, "Erro de soquete: $e", 5, Colors.red.shade800);
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

void sendMessage(ScaffoldMessengerState scaffoldMessenger, String message,
    int duracao, Color cor) {
  scaffoldMessenger.showSnackBar(
    SnackBar(
      content: Center(child: Text(message)),
      duration: Duration(seconds: duracao),
      backgroundColor: cor,
    ),
  );
}

Future<List<Map<String, dynamic>>> getDadosMonofasicos(
    String host,
    int port,
    String user,
    String db,
    String password,
    String dataInicial,
    String dataFinal,
    ScaffoldMessengerState scaffoldMessenger,
    String nomeCliente) async {
  final conn = await getConnection(host, port, user, db, password);

  try {
    sendMessage(
        scaffoldMessenger,
        "Conectado ao banco de dados $nomeCliente... Aguarde... Executando consulta...",
        2,
        Colors.blue.shade800);
    print("Conectado ao banco de dados $db. Executando consulta...");

    List<Map<String, dynamic>> dataList = [];
    StringMonofasicos stringMonofasicos = StringMonofasicos();
    String query;
    if (nomeCliente == 'Mianti Filial') {
      query = stringMonofasicos.getString(db, idEmpresa: '2');
    } else {
      query = stringMonofasicos.getString(db);
    }

    print(query);
    if (query == "") {
      sendMessage(
          scaffoldMessenger, 'Cliente não gera monofasico', 3, Colors.blueGrey);
      return dataList;
    } else {
      var results = await conn.query(query, [dataInicial, dataFinal]);

      print(results);
      var excel = Excel.createExcel();
      excel.tables.keys.toList().forEach((key) {
        if (key != 'Sheet1') {
          excel.tables.remove(key);
        }
      });

      var sheet = excel['Sheet1'];

      sheet.appendRow([
        'Nota Fiscal',
        'Codigo',
        'Data',
        'Referencia',
        'Descricao',
        'UN',
        'NCM',
        'QTD',
        'Total'
      ]);
      double total = 0;
      var currencyFormatter =
          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      var dateFormatter = DateFormat('dd/MM/yyyy');
      for (var row in results) {
        sheet.appendRow([
          row['ide_notafiscal'],
          row['Codigo'].toString(),
          dateFormatter.format(row['Data']),
          row['Referencia'].toString(),
          row['Descricao'].toString(),
          row['UN'].toString(),
          row['NCM'].toString(),
          row['QTD'].toString(),
          currencyFormatter.format(row['Total'])
        ]);

        total += row['Total'];
      }
      sheet.appendRow(
          ['', '', '', '', '', '', '', '', currencyFormatter.format(total)]);
      ajustarLarguraColunas(excel);

      String? diretorioEscolhido = await selecionarDiretorioDestino();

      if (diretorioEscolhido != null) {
        var excelBytes = excel.encode();
        if (excelBytes != null) {
          File('$diretorioEscolhido/Monofasicos.xlsx')
              .writeAsBytesSync(excelBytes);
        }
        await Future.delayed(const Duration(seconds: 3));
        sendMessage(
            scaffoldMessenger,
            'Monofásico gerado em $diretorioEscolhido',
            3,
            Colors.blue.shade800);
      }

      return dataList;
    }
  } on TimeoutException catch (e) {
    sendMessage(scaffoldMessenger, "A consulta excedeu o tempo limite: $e", 5,
        Colors.red.shade800);
    print("A consulta excedeu o tempo limite: $e");
    return [];
  } on SocketException catch (e) {
    sendMessage(
        scaffoldMessenger, "Erro de soquete: $e", 5, Colors.red.shade800);
    print("Erro de soquete: $e");
    return [];
  } finally {
    await conn.close();
  }
}

void ajustarLarguraColunas(Excel excel) {
  var sheet = excel['Sheet1'];

  var totalColunas = sheet.maxCols;

  for (var i = 0; i < totalColunas; i++) {
    var maxWidth = 0;

    for (var row in sheet.rows) {
      if (row.length > i) {
        var cellContent = row[i]?.value?.toString() ?? '';
        if (cellContent.length > maxWidth) {
          maxWidth = cellContent.length;
        }
      }
    }
    sheet.setColWidth(i, (maxWidth + 2));
  }
}

Future<String?> lerArquivo(String caminho) async {
  try {
    var arquivo = File(caminho);
    var bytes = await arquivo.readAsBytes();
    var conteudo = utf8.decode(bytes);
    return conteudo;
  } catch (e) {
    print("Erro ao ler o arquivo: $e");
    return null;
  }
}
