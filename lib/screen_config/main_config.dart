import 'package:Baixar_Xml/modulos/carregar_servidor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Baixar_Xml/modulos/carregarDados.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController dataInicialControler = TextEditingController();
  final TextEditingController dataFinalControler = TextEditingController();
  final TextEditingController empresaControler = TextEditingController();

  String selectedCompany = '';
  String selectServer = 'Central Server';
  var clientesCentralServer = [
    "",
    "4S Auto Peças",
    "Adnaldo",
    "Alcana Veste",
    "Apac",
    "Apac Feminina",
    "AP Machado",
    "Arauto",
    "Auto Vale Peças",
    "Corel - LGM",
    "Corel Portas",
    "Distribuidora Prime",
    "Fortkol",
    "JF Parabrisas",
    "Mariano Auto Peças",
    "Mello Auto Peças",
    "Mesquita Auto Peças",
    "Moto Show Boutique",
    "Nathan",
    "O Especialista",
    "Paluma Distribuidora",
    "Santos",
    "Scanorte Sul",
    "Stock",
    "Vasquinho Filial",
    "Vasquinho Radiadores"
  ];
  var clientesDdns = [
    "",
    "AP Alfenas",
    "Artronic",
    "Cardoso Auto Peças",
    "Lider",
    "Brito",
    "Canezin",
    "Eccus",
    "JJ Alfenas",
    "JJ Machado",
    "Joaquim Siqueira",
    "Mianti",
    "Moto Show",
    "O Especialista",
    "Peretto",
    "Perimetral",
    "Pé Direito",
    "Rey Auto Peças",
    "Vidraçaria",
    "Wandinho Tratores"
  ];

  bool nfeSelecionado = false;
  bool nfceSelecionado = false;
  bool carregando = false;

  Future<void> _selecionarDataInicial(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );
    if (dataSelecionada != null && dataSelecionada != DateTime.now()) {
      setState(() {
        dataInicialControler.text =
            DateFormat('yyyy-MM-dd').format(dataSelecionada);
      });
    }
  }

  Future<void> _selecionarDataFinal(BuildContext context) async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2200),
    );

    if (dataSelecionada != null && dataSelecionada != DateTime.now()) {
      setState(() {
        dataFinalControler.text =
            DateFormat('yyyy-MM-dd').format(dataSelecionada);
      });
    }
  }

  late Future<void> _downloadXmls = Future.value();
  String radioValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Download de Xmls',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(35),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade400,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(14),
            children: [
              const Text(
                'Período',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _selecionarDataInicial(context),
                        child: IgnorePointer(
                          child: TextField(
                            controller: dataInicialControler,
                            decoration: const InputDecoration(
                                labelText: 'Data Inicial'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selecionarDataFinal(context),
                        child: IgnorePointer(
                          child: TextField(
                            controller: dataFinalControler,
                            decoration:
                                const InputDecoration(labelText: 'Data Final'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14.0),
              _buildComboBoxServidor(
                'Servidor',
                ['Central Server', 'DDNS', 'Local'],
                selectServer,
                (value) {
                  setState(() {
                    selectServer = value ?? 'Central Server';
                    selectedCompany = '';
                  });
                },
              ),
              const SizedBox(height: 14.0),
              _buildComboBox(
                'Empresa',
                [],
                selectedCompany,
                (value) {
                  setState(() {
                    selectedCompany = value ?? '';
                  });
                },
              ),
              const SizedBox(height: 14.0),
              const Text(
                'Modelo Nota',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckBox('NFe', nfeSelecionado, (value) {
                      setState(() {
                        nfeSelecionado = value ?? false;
                      });
                    }),
                    _buildCheckBox('NFCe', nfceSelecionado, (value) {
                      setState(() {
                        nfceSelecionado = value ?? false;
                      });
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () async {
                  verificarPeriodo();
                },
                child: const Text('Baixar XMLs'),
              ),
              const SizedBox(height: 35.0),
              FutureBuilder<void>(
                future: _downloadXmls,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      child: CircularProgressIndicator(
                        color: Colors.blueGrey.shade800,
                        backgroundColor: Colors.white,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao baixar XMLs: ${snapshot.error}'),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade800,
    );
  }

  Widget _buildCheckBox(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildComboBox(String title, List<String> options,
      String selectedOption, ValueChanged<String?> onChanged) {
    List<String> clientes = [];

    // Verificar a opção selecionada no servidor e atribuir a lista de clientes correspondente
    if (selectServer == 'Central Server') {
      clientes = clientesCentralServer;
    } else if (selectServer == 'DDNS') {
      clientes = clientesDdns;
    }

    clientes = clientes.toSet().toList();

    // Verificar se o servidor é Local Host
    if (selectServer == 'Local') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  onChanged: (value) {
                    onChanged(value);
                    empresaControler.text = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Nome do Banco de Dados',
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value: selectedOption,
              onChanged: onChanged,
              isExpanded: true,
              items: clientes.map<DropdownMenuItem<String>>((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option),
                );
              }).toList(),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildComboBoxServidor(String title, List<String> options,
      String selectedOption, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: DropdownButton<String>(
            value: selectedOption,
            onChanged: onChanged,
            isExpanded: true,
            items: options.map<DropdownMenuItem<String>>((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<void> _baixarXmls() async {
    setState(() {
      carregando = true;
    });
    var nfe = '';
    var nfce = '';
    if (nfeSelecionado) {
      nfe = '55';
    }
    if (nfceSelecionado) {
      nfce = '65';
    }
    try {
      var dadosServidor = carregarServidor(selectedCompany);

      if (selectServer == 'Local') {
        String nomeBanco = empresaControler.text.trim();
        print("Valor da empresaControler: ${empresaControler.text}");

        if (nomeBanco.isNotEmpty) {
          await carregarDadosXml(
              'localhost',
              'root',
              '$nomeBanco',
              'farsoft01',
              dataInicialControler.text,
              dataFinalControler.text,
              3306,
              nfe,
              nfce,
              context,
              selectedCompany);
        }
        setState(() {
          carregando = false;
        });
      } else {
        await carregarDadosXml(
            dadosServidor[0],
            dadosServidor[1],
            dadosServidor[2],
            dadosServidor[3],
            dataInicialControler.text,
            dataFinalControler.text,
            3306,
            nfe,
            nfce,
            context,
            selectedCompany);
        setState(() {
          carregando = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void verificarPeriodo() {
    if (dataFinalControler.text == '' || dataInicialControler.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
              child: Text(
                  'Obrigatório informar Data Inicial e Data Final para consulta.')),
          duration: Duration(seconds: 5),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final DateTime dataInicial = DateTime.parse(dataInicialControler.text);
      final DateTime dataFinal = DateTime.parse(dataFinalControler.text);

      // Calcular a diferença entre as datas em meses
      final int diferencaEmMeses =
          dataFinal.difference(dataInicial).inDays ~/ 30;
      final int diferencaDias = dataFinal.difference(dataInicial).inDays;
      if (diferencaEmMeses > 6) {
        // Mostrar uma mensagem na tela
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Período máximo de consulta é de 6 meses!!!'),
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      } else if (diferencaDias < 0) {
        // Mostrar uma mensagem na tela
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('Data Inicial deve ser inferior a Data Final'),
            ),
            duration: Duration(seconds: 5),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _downloadXmls = _baixarXmls();
          });
        });
      }
    }
  }
}
