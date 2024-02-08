import 'package:xml/xml.dart';

class NFe {
  late String mod;
  late String CNPJ;
  late String razaoSocial;
  late String chaveAcesso;

  // ... adicione outros campos conforme necessário

  NFe();

  NFe.fromXml(XmlElement element) {
    final infNFeElement = element.findElements('infNFe').firstOrNull;
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
    } else {
      print('infNFe Element Not Found');
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
