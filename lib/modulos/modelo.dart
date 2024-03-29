// ignore_for_file: non_constant_identifier_names, avoid_print, deprecated_member_use

import 'package:xml/xml.dart';

class NFe {
  late String mod;
  late String CNPJ;
  late String razaoSocial;
  late String chaveAcesso;

  NFe();

  NFe.fromXml(XmlElement element) {
    final infNFeElement = element.findElements('infNFe').firstOrNull;
    final inutNFe = element.findElements('retInutNFe').firstOrNull;

    if (infNFeElement != null) {
      final ideElement = infNFeElement.findElements('ide').firstOrNull;
      final emitElement = infNFeElement.findElements('emit').firstOrNull;

      if (ideElement != null) {
        mod = _getChildText(ideElement, 'mod');
        chaveAcesso = _getChildAttribute(infNFeElement, 'Id').substring(3);
      } else {
        print('ide Element Not Found');
      }
      if (emitElement != null) {
        CNPJ = _getChildText(emitElement, 'CNPJ');
        razaoSocial = _getChildText(emitElement, 'xFant');
      }
    } else if (inutNFe != null) {
      final infInut = inutNFe.findElements('infInut').firstOrNull;
      if (infInut != null) {
        CNPJ = _getChildText(infInut, 'CNPJ');
        chaveAcesso = _getChildAttribute(infInut, 'Id').substring(2);
        mod = _getChildText(infInut, 'mod');
        razaoSocial = _getChildText(infInut,'dhRecbto');
        print(CNPJ);
      } else {
        print("Elemento 'infInut' não encontrado.");
      }
    } else {
      print("Elemento 'inutNFe' não encontrado.");
    }
  }

  String _getChildText(XmlElement element, String tagName) {
    final child = element.findElements(tagName).firstOrNull;
    if (child != null) {
      print('$tagName found: ${child.text}');
      return child.text;
    } else {
      print('$tagName not found');
      return ''; // ou outra estratégia, dependendo do seu caso
    }
  }

  String _getChildAttribute(XmlElement element, String attributeName) {
    final attribute = element.getAttribute(attributeName);
    if (attribute != null) {
      print('$attributeName attribute found: $attribute');
      return attribute;
    } else {
      print('$attributeName attribute not found');
      return ''; // ou outra estratégia, dependendo do seu caso
    }
  }
}
