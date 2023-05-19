import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Projeto AA',
      theme: ThemeData(
        primarySwatch: Colors.black,
      ),
      home: MyHomePage(title: 'teste Projeto AA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _message = '';

  void _showMessage() {
    setState(() {
      _message = 'Funciona';
    });
  }

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Pressione o botão abaixo para exibir uma mensagem:',
            ),
            Text(
              _message,
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMessage,
        tooltip: 'Pressione',
        child: Icon(Icons.message),
      ),
    );
    floatingActionButton: floatingActionButton(
      onPressed: 
    )
  }
}
 //void _troca(){
    //navigator(;
      //troca tela do aplicativo(Tela 2),
    //)
  //}
