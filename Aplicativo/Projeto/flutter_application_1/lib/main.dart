// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_is_empty, unused_element, unused_local_variable, duplicate_ignore, prefer_const_constructors

//bibliotecas 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto AA',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomePage(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override //Configuração da página inicial. (Botões, posição, etc...)
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Página Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Peças'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CadastroPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Conferir'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConferirPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Testar'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroPage extends StatelessWidget {
  const CadastroPage({Key? key}) : super(key: key);

  Future<void> _scanQRCode(BuildContext context) async {
    final barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      false,
      ScanMode.QR,
    );

    if (barcodeScanResult != '-1') {
      List<String> parts = barcodeScanResult.split('/');
      if (parts.length >= 5) {
        String pathNumber = parts[0];
        String op = parts[1];
        String quantidade = parts[2];
        String data = '${parts[3]}/${parts[4]}';

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('QR Code Lido'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Path-Number: $pathNumber'),
                  Text('OP: $op'),
                  Text('Quantidade: $quantidade'),
                  Text('Data: $data'),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    bool proceedWithTest =
                        await _showTestDialog(context, 1, int.parse(quantidade));
                    if (proceedWithTest) {
                      await _realizarTeste(context, op, quantidade, data);
                    }
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: const Text('Código QR não contém informações suficientes.'),
              actions: [
                ElevatedButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _realizarTeste(
      BuildContext context, String op, String quantidade, String data) async {
    int quantidadePecas = int.tryParse(quantidade) ?? 0;
    TestePage testePage = TestePage();

    for (int i = 0; i < quantidadePecas; i++) {
      bool proceedWithTest = await _showTestDialog(context, i + 1, quantidadePecas);

      if (!proceedWithTest) {
        break;
      }

      await Future.delayed(Duration(seconds: 1));
      await testePage.sendCommand(context, true);
      await Future.delayed(Duration(seconds: 1));
      final sensorData = await testePage.fetchSensorData(context);
      await testePage.sendCommand(context, false);
      await Future.delayed(Duration(seconds: 1));
      await testePage.sendCommand(context, true);
      await Future.delayed(Duration(seconds: 1));
      await testePage.sendCommand(context, false);

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Teste Concluído'),
            content: Text('Teste da peça ${i + 1} concluído com sucesso.'),
            actions: [
              ElevatedButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      await Future.delayed(Duration(seconds: 1));
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Testes Concluídos'),
          content: const Text('Todos os testes foram concluídos com sucesso.'),
          actions: [
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showTestDialog(
      BuildContext context, int currentPiece, int totalPieces) async {
    bool proceedWithTest = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Testando Peça $currentPiece de $totalPieces'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Iniciando o teste da peça $currentPiece...'),
              Text('Deseja prosseguir com o teste?'),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            ElevatedButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      proceedWithTest = value ?? false;
    });

    return proceedWithTest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Teste de Peças'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _scanQRCode(context),
              child: const Text('Ler QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}

class ConferirPage extends StatelessWidget { //Página para busca de informações. (lógica ainda não implementada)
  final TextEditingController opController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  ConferirPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Conferir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: opController,
              decoration: const InputDecoration(
                labelText: 'Op',
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: dataController,
              decoration: const InputDecoration(
                labelText: 'Data',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Pesquisar'),
              onPressed: () {
                // Adicionar a lógica para buscar as informações.
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class TestePage extends StatelessWidget { //Página para teste geral da Giga 
  TestePage({Key? key}) : super(key: key);

  String sensorData = "Dados do Sensor: N/A"; //definindo o padrão da mensagem em relação ao valor do sensor 

  Future<void> sendCommand(BuildContext context, bool estado) async {
  final url = 'http://192.168.105.81/rele?estado=$estado'; // Rota de onde a requisição HTTP deve ser enviada no servidor do ESP
    final response = await http.get(Uri.parse(url));
  }

  Future<void> fetchSensorData(BuildContext context) async {
    const url = 'http://192.168.105.81/sensor'; //Rota de comunicação com o servidor 
    final response = await http.get(Uri.parse(url));
    final sensorData = "Dados do Sensor: ${response.body}";
    _showSensorDataDialog(context, sensorData);
  }

//daqui pra baixo apenas configurações de botão e coisas do gênero para a página de testes
void _showSensorDataDialog(BuildContext context, String sensorData) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Dados do Sensor'),
        content: Text(sensorData),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void _showAlertDialog(BuildContext context, String title, String content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Testar'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Acionar'),
              onPressed: () {
                sendCommand(context, true);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Desativar'),
              onPressed: () {
                sendCommand(context, false);
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Solicitar Dados do Sensor'),
              onPressed: () {
                fetchSensorData(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
