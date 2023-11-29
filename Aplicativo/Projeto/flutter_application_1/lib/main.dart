// ignore_for_file: must_be_immutable, use_build_context_synchronously, prefer_is_empty, unused_element, unused_local_variable, duplicate_ignore, prefer_const_constructors

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

  @override
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    _realizarTeste(context, op, quantidade, data);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Código QR não possui informações suficientes
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

Future<void> _realizarTeste(BuildContext context, String op, String quantidade, String data) async {
  int quantidadePecas = int.tryParse(quantidade) ?? 0;

  for (int i = 0; i < quantidadePecas; i++) {
    // Mostrar o diálogo antes de iniciar cada teste
    bool proceedWithTest = await _showTestDialog(context, i + 1, quantidadePecas);

    if (!proceedWithTest) {
      // Se o usuário escolher interromper o teste, sair do loop
      break;
    }

    TestePage testePage = TestePage(); // Crie uma nova instância a cada iteração

    // Aguardar um tempo antes de iniciar o teste da peça
    await Future.delayed(Duration(seconds: 1));

    // Acionar o relé
    await testePage.sendCommand(context, true);

    // Aguardar um tempo antes de verificar o sensor após o acionamento do relé
    await Future.delayed(Duration(seconds: 1));

    // Verificar o sensor após o acionamento do relé
    // ignore: unused_local_variable
    final sensorData = await testePage.fetchSensorData(context);

    // Desacionar o relé
    await testePage.sendCommand(context, false);

    // Aguardar um tempo antes de continuar com a próxima peça
    await Future.delayed(Duration(seconds: 1));

    // Acionar o relé novamente
    await testePage.sendCommand(context, true);

    // Aguardar um tempo antes de verificar o sensor após o segundo acionamento do relé
    await Future.delayed(Duration(seconds: 1));

    // Desacionar o relé novamente
    await testePage.sendCommand(context, false);

    // Mostrar diálogo ao concluir o teste da peça
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       title: const Text('Teste Concluído'),
    //       content: Text('Teste da peça ${i + 1} concluído com sucesso.'),
    //       actions: [
    //         ElevatedButton(
    //           child: const Text('OK'),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         ),
    //       ],
    //     );
    //   },
    // );

    // Aguardar um tempo antes de continuar com a próxima peça
    await Future.delayed(Duration(seconds: 1));
  }

  // Após concluir todos os testes, mostrar o diálogo de conclusão
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

Future<bool> _showTestDialog(BuildContext context, int currentPiece, int totalPieces) async {
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
              Navigator.of(context).pop(true); // Indica que o teste deve prosseguir
            },
          ),
          ElevatedButton(
            child: const Text('Não'),
            onPressed: () {
              Navigator.of(context).pop(false); // Indica que o teste deve ser interrompido
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

  Future<void> _showPieceTestedDialog(BuildContext context, int currentPiece, int totalPieces, String sensorData) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Teste da Peça $currentPiece Concluído'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Peça $currentPiece de $totalPieces foi testada.'),
              Text('Dados do Sensor: $sensorData'),
            ],
          ),
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

class ConferirPage extends StatelessWidget {
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

class TestePage extends StatelessWidget {
  TestePage({Key? key}) : super(key: key);

  String sensorData = "Dados do Sensor: N/A";

  Future<void> sendCommand(BuildContext context, bool estado) async {
  final url = 'http://192.168.105.81/rele?estado=$estado'; // Corrigido o erro de digitação
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _showAlertDialog(context, 'Comando Enviado', 'Comando enviado com sucesso para o ESP32.');
    } else {
      _showAlertDialog(context, 'Erro ao Enviar Comando', 'Erro ${response.statusCode}: ${response.body}');
    }
  } catch (error) {
    _showAlertDialog(context, 'Erro na Solicitação HTTP', 'Ocorreu um erro na solicitação HTTP: $error');
  }
}

  Future<void> fetchSensorData(BuildContext context) async {
  const url = 'http://192.168.105.81/sensor';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final sensorData = "Dados do Sensor: ${response.body}";
      _showSensorDataDialog(context, sensorData);
    } else {
      _showAlertDialog(context, 'Erro ao Solicitar Dados do Sensor',
          'Ocorreu um erro ao solicitar os dados do sensor.');
    }
  } catch (error) {
    _showAlertDialog(context, 'Erro na Solicitação HTTP',
        'Ocorreu um erro na solicitação HTTP: $error');
  }
}

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
