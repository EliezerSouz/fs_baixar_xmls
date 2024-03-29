// ignore_for_file: file_names

class StringMonofasicos {
  String queryMonofasico =
      """select nc.ide_notafiscal, p.id as "Codigo", nc.ide_demi as 'Data', p.referencia as "Referencia", ni.prod_xprod as "Descricao", ni.prod_ucom as "UN", ni.prod_ncm as "NCM", coalesce(sum(ni.prod_qcom), 0) as "QTD", coalesce(sum(ni.prod_vprod - ni.prod_vdesc)) as "Total" from nota_cabecalho nc join nota_itens ni on ni.nota_cabecalho_id = nc.id join produto p on p.id = ni.produto_id where nc.nota_naturezaoperacao_id in (?) and nc.fs_fase = 02 and ni.empresa_id = 1 and nc.ide_demi >= ? and nc.ide_demi <= ? and ni.prod_ncm in ('40161010','40169990','70071100','70072100','70091000','73201000','83012000','83023000','84073390','84073490','84148021','84148022','84212300','84213100','84314100','84314200','84339090','84818099','84832000','85123000','85129000','85365090','85443000','90292010','90299010','90318040','91040000','94012000','68132000','68138110','68138190','68138910','68138990','84082090','84082010','84082020','84082030','84082090','84099111','84099112','84099112','84099113','84099114','84099115','84099116','84099117','84099118','84099120','84099130','84099140','84099190','84099912','84099914','84099915','84099917','84099921','84099929','84099930','84099941','84099949','84099951','84099959','84099961','84099969','84099971','84099979','84099991','84099999','84133010','84133020','84133030','84133090','84152010','84152090','84831011','84831019','84831020','84831030','84831040','84831050','84831090','84833010','84833021','84833029','84833090','84834010','84834090','84835010','84835090','85052010','85052090','85111000','85112010','85112090','85113010','85113020','85114000','85115010','85115090','85118010','85118020','85118030','85118090','85119000','85122011','85122019','85122021','85122022','85122023','85122029','85124010','85124020','85272100','85272900','85391010','85391090','87060010','87060020','87060090','87071000','87079010','87079090','87081000','87082100','87082911','87082912','87082913','87082914','87082919','87082991','87082992','87082993','87082994','87082995','87082999','87083011','87083019','87083090','87084011','87084019','87084080','87084090','87085011','87085012','87085019','87085080','87085091','87085099','87087010','87087090','87088000','87089100','87089200','87089300','87089411','87089412','87089413','87089481','87089482','87089483','87089490','87089510','87089521','87089522','87089529','87089910','87089990','90328921','90328922','90328923','90328924','90328925','90328929','76129012','84306990','73090010','73090010','73090090','84291110','84291190','84291910','84291990','84292010','84292090','84293000','84294000','84295111','84295119','84295121','84295129','84295191','84295192','84295199','84295211','84295212','84295219','84295220','84295290','84295900','84321000','84322100','84322900','84323110','84323190','84323910','84323990','84324000','84324100','84324200','84328000','84329000','84331100','84331900','84332010','84332090','84333000','84334000','84335100','84335200','84335300','84335911','84335919','84335990','84336010','84336021','84336029','84336090','84339010','84339090','84341000','84342010','84342090','84349000','84351000','84359000','84361000','84362100','84362900','84368000','84369100','84369900','84371000','84378010','84378090','84379000','87011000','87012000','87013000','87013000','87019100','87019200','87019300','87019410','87019490','87019510','87019590','87021000','87022000','87023000','87024010','87024090','87029000','87031000','87032100','87032210','87032290','87032310','87032390','87032410','87032490','87033110','87033190','87033210','87033290','87033310','87033390','87034000','87035000','87036000','87041010','87041090','87042110','87042120','87042130','87042190','87042210','87042220','87042230','87042290','87042310','87042320','87042330','87042340','87043190','87043110','87043120','87043130','87043190','87043210','87043220','87043230','87043290','87049000','87051010','87051090','87052000','87053000','87054000','87059010','87059090','87060010','87060020','87060090','40111000','40112010','40112090','40113000','40114000','40115000','40117010','40117090','40118010','40118020','40118090','40119010','40119090','40131010','40131090','40132000','40139000','84089090','84122110','84122190','84123110','84136019','84148019','84149039','84329000','84811000','84812090','84818092','85011019','84311010','84311090','84312011','84312019','84312090','84311090','84313190','84313900','84314100','84314200','84314310','84314390','84314910','84314921','84314922','84314923','84314929','84836011','84836019','33074900') group by 1,2 order by ni.prod_xprod""";

  String adnaldo = "77,83";
  String apAlfenas = "4,64";
  String apMachado = "4,18";
  String apSaoGeraldo = "4,61,32";
  String santaRita = "4,32,60,62";
  String autoLatas = "4,65,32";
  String autoVale = "4";
  String canezin = "4,20";
  String cardosoAp = "4,30,31,32,58,59,60";
  String codorna = "4,32,68";
  String giomar = "59,77,69";
  String lider = "64,4,32,36";
  String mecanica = "17,18";
  String mello = "4,32,30,31,63";
  String mesquita = "25,4";
  String mianti = "4,62,32";
  String motoShowBoutique = "4,32,69,85";
  String motoShowPA = "69,32,88,87";
  String oEspecialista = "4,62";
  String peretto = "4,32,59,65";
  String perimetral = "4,30,31,66";
  String pinheiro = "4,32,69,89";
  String postoDeMolas = "30,31,59,4,3";
  String reyAutoPecas = "59,4,97,94";
  String santaMarta = "4,32,60,62";
  String saoThome = "4,66";
  String serjao = "35,69,85";
  String shoppingAutomotivo = "4,59";
  String vasquinho = "59,69,91";
  String vasquinhoFilial = "30,4,32";
  String primeDist = "86,69";

  String getString(String nomeString, {String idEmpresa = '1'}) {
    String listaValores = "";
    switch (nomeString) {
      case 'farsoft_adnaldo':
        listaValores = adnaldo.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_autovalepecas':
        listaValores = autoVale.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_apalfenas':
        listaValores = apAlfenas.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_apmachado':
        listaValores = apMachado.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_apsg':
        listaValores = apSaoGeraldo.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_apst':
        listaValores = santaRita.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_autolatas':
        listaValores = autoLatas.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_canezin':
        listaValores = canezin.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_cardosoap':
        listaValores = cardosoAp.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_codorna':
        listaValores = codorna.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_giomar':
        listaValores = giomar.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_lider':
        listaValores = lider.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_mecanicarodrigues':
        listaValores = mecanica.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_mello':
        listaValores = mello.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_mesquita':
        listaValores = mesquita.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_mianti':
        if(idEmpresa == '2'){
          queryMonofasico = queryMonofasico.replaceFirst('ni.empresa_id = 1', 'ni.empresa_id = 2');
        }
        listaValores = mianti.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
        case 'farsoft_serjao':
        listaValores = serjao.split(',').join(",");
        return queryMonofasico.replaceFirst('?',listaValores);
      case 'farsoft_motoshowboutique':
        listaValores = motoShowBoutique.split(',').join((","));
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_motoshow':
        listaValores = motoShowPA.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_oespecialista':
        listaValores = oEspecialista.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_pertto':
        listaValores = peretto.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_perimetral':
        listaValores = perimetral.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_postodemolas':
        listaValores = postoDeMolas.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_reyautopecas':
        listaValores = reyAutoPecas.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_shoppingautomotivo':
        listaValores = shoppingAutomotivo.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_vasquinhofilial':
        listaValores = vasquinhoFilial.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);
      case 'farsoft_vasquinho':
        listaValores = vasquinho.split(',').join(",");
        return queryMonofasico.replaceFirst('?', listaValores);      
      default:
        return '';
    }
  }
}
