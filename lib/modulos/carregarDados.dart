import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:Baixar_Xml/db/query.dart';
import 'package:Baixar_Xml/modulos/modelo.dart';
import 'package:file_picker/file_picker.dart';

var dadosXml = <Map<String, dynamic>>[];
var dadosMonofasicos = <Map<String, dynamic>>[];

Future<void> carregarDadosXml(
    String host,
    user,
    dbName,
    password,
    dataInicial,
    dataFinal,
    int port,
    String nfe,
    nfce,
    BuildContext context,
    _nomeCliente) async {
  // Substitua os valores abaixo pelos corretos para o seu banco de dados
  dadosXml = await getDadosXmls(host, port, user, dbName, password, dataInicial,
      dataFinal, nfe, nfce, ScaffoldMessenger.of(context), _nomeCliente);

  String filename = '', modNfe = '', vigenciaXml = '', chaveAcesso = '', cnpj;
  String? diretorioEscolhido = await selecionarDiretorioDestino();

  if (diretorioEscolhido != null) {
    for (var xml in dadosXml) {
      XmlDocument xmlDocument = XmlDocument.parse(xml['xml_final']);
      final xmlString = xmlDocument.toXmlString();
      final document = XmlDocument.parse(xmlString);
      var nFeElement = document.rootElement.findElements('NFe').firstOrNull;

      final statusNf = xml['fs_fase'];
      if (nFeElement == null) {
        if (statusNf != '999') {
          nFeElement = document.root.findElements('NFe').firstOrNull;
        } else {
          nFeElement = document.root.findElements('ProcInutNFe').firstOrNull;
        }
      }
      if (nFeElement != null) {
        String caminhoDoArquivo = diretorioEscolhido;
        final nfe = NFe.fromXml(nFeElement);
        modNfe = nfe.mod;

        if (statusNf == '999') {
          chaveAcesso = nfe.chaveAcesso;
          vigenciaXml = '${nfe.razaoSocial.replaceAll('-', '').substring(0, 6)}';
        }
        else{          
        chaveAcesso = nfe.chaveAcesso;
        vigenciaXml = '20${chaveAcesso.substring(2, 6)}';
        }
        cnpj = nfe.CNPJ;
        filename = '${chaveAcesso}.xml';
        caminhoDoArquivo +=
            '/' + _nomeCliente + ' - ' + cnpj + '/' + vigenciaXml;

        if (modNfe == '55') {
          caminhoDoArquivo += '/NFe';
        } else if (modNfe == '65') {
          caminhoDoArquivo += '/NFCe';
        }
        if (statusNf == '19') {
          caminhoDoArquivo += '/Denegadas';
        } else if (statusNf == '07') {
          caminhoDoArquivo += '/Canceladas';
        } else if (statusNf == "999") {
          caminhoDoArquivo += '/Inutilizadas';
        } else {
          caminhoDoArquivo += '/Autorizadas';
        }

        Directory(caminhoDoArquivo).createSync(recursive: true);
        File(caminhoDoArquivo + "/" + filename).writeAsStringSync(xmlString);
      } else {
        print('Elemento Nao localizado ');
      }
    }
  }
}

Future<void> carregarDadosMonofasico(
    String host,
    user,
    dbName,
    password,
    dataInicial,
    dataFinal,
    int port,
    BuildContext context,
    _nomeCliente) async {
  dadosMonofasicos = await getDadosMonofasicos(
      host,
      port,
      user,
      dbName,
      password,
      dataInicial,
      dataFinal,
      ScaffoldMessenger.of(context),
      _nomeCliente);
}

Future<String?> selecionarDiretorioDestino() async {
  String? result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    return result;
  }
  return null;
}
