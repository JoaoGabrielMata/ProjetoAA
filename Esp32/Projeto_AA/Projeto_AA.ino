#include <WiFi.h>
#include <WebServer.h>

//Configurações da rede WI-Fi onde o projeto está conectado
const char* ssid = "Teste_ProjetoAA"; //Nome da rede
const char* password = "Sense2023"; //Senha

bool estado = false;

WebServer server(80); //Porta onde o servidor vai ser hospedado. (porta 80 é padrão)

void connectToWiFi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
  }
  Serial.println("Connected to WiFi");
}

void handleRootRequest() {
  server.send(200, "text/plain", "");
}

void handleAtualizarRele() { //Lógica por trás do acionamento do relé
  if (server.hasArg("estado")) {
    String estado = server.arg("estado"); //O estado do relé é fornecido pelo aplicativo por meio de uma requisição HTTP
    Serial.print("Estado recebido");
    if (estado == "false") {
      digitalWrite(23, 0); //Linha onde mostra que o relé foi desligado
      Serial.println(" Desligado");
      //testes
      digitalWrite(5,1);
      delay(1000);
      digitalWrite(5,0);
    } else {
      digitalWrite(23, 1); //Linha onde mostra que o relé foi acionado
      Serial.println(" Ligado");
      //testes
      digitalWrite(5,1);
      delay(1000);
      digitalWrite(5,0);
    }
  }
}

void handleSensorData() {
  // Ler o valor do sensor e enviá-lo como JSON
  int valorSensor = digitalRead(4); //Leitura do valor do sensor 
  String json = "{\"sensor\": " + String(valorSensor) + "}"; //Transformando o valor em uma string JSON
  server.send(200, "application/json", json); //Enviando o valor para o servidor 
}

void setup() {
  Serial.begin(115200);
  pinMode(4, INPUT); // Pino Sensor 
  pinMode(5,OUTPUT); // Pino Led /utilizado para testes no projeto
  pinMode(23, OUTPUT); // Pino Relé 

  connectToWiFi();

  //Rotas para comunicação com o aplicativo 
  server.on("/", handleRootRequest);
  server.on("/rele", handleAtualizarRele);
  server.on("/sensor", handleSensorData);

  //Iniciando o servidor
  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();

  if(digitalRead(4) == 1){
    digitalWrite(5,1);
  }
  else{
    digitalWrite(5,0);
  }
}
