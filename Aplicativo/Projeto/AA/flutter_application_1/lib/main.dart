import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto AA',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;

  CustomAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Página Inicial'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Cadastro'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CadastroPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Conferir'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConferirPage()),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Testar'),
              onPressed: () {
                final url = 'http://192.168.197.45/pino22';

                http.get(Uri.parse(url)).then((response) {
                  if (response.statusCode == 200) {
                    // O comando foi executado com sucesso
                    print('Comando enviado com sucesso para o ESP32');
                  } else {
                    // Ocorreu um erro ao enviar o comando
                    print('Erro ao enviar o comando para o ESP32');
                  }
                }).catchError((error) {
                  // Ocorreu um erro na solicitação HTTP
                  print('Erro na solicitação HTTP: $error');
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CadastroPage extends StatelessWidget {
  final TextEditingController opController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController quantidadeController = TextEditingController();

  void _salvarDados(BuildContext context) {
    // Lógica para salvar os dados

    // Exibindo a mensagem de salvo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dados Salvos'),
          content: Text('Os dados foram salvos com sucesso.'),
          actions: [
            ElevatedButton(
              child: Text('OK'),
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
      appBar: CustomAppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: opController,
              decoration: InputDecoration(
                labelText: 'Op',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: 'Data',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(
                labelText: 'Quantidade',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                _salvarDados(context);
              },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text('Conferir'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: opController,
              decoration: InputDecoration(
                labelText: 'Op',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: dataController,
              decoration: InputDecoration(
                labelText: 'Data',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Pesquisar'),
              onPressed: () {
                // Adicionar a lógica para buscar as informações
              },
            ),
            SizedBox(height: 20),
            // Exibir as informações encontradas
          ],
        ),
      ),
    );
  }
}
