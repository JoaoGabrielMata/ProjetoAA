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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              child: Text('Acessar Teste e Conferir'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TesteConferirPage()),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Op',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'data',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Salvar'),
              onPressed: () {
                // adicionar a lógica para salvar os dados
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConferirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conferir'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar informações',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Pesquisar'),
              onPressed: () {
                // adicionar a lógica para buscar as informações
              },
            ),
            SizedBox(height: 20),
            // exibir as informações encontradas
          ],
        ),
      ),
    );
  }
}

class TestePage extends StatelessWidget {
  void controlRelay() async {
    var url = Uri.parse('http://endereço_ip_esp32/relay'); // Substitua "endereço_ip_esp32" pelo endereço IP do seu ESP32

    // Envie a solicitação POST para ligar o relé
    var response = await http.post(url, body: {'state': '1'});

    if (response.statusCode == 200) {
      print('Relay ligado com sucesso');
    } else {
      print('Erro ao ligar o relay');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Testar'),
              onPressed: () {
                controlRelay(); // Chama a função para controlar o relé
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TesteConferirPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acessar Teste e Conferir'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Teste'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestePage()),
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
          ],
        ),
      ),
    );
  }
}
