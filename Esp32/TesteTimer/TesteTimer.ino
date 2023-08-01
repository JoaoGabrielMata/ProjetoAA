//Bibliotecas
#include <WiFi.h>
#include <WebServer.h>

//Cadastro do Wi-fi
const char* ssid = "Teste_ProjetoAA"; //Nome da Rede
const char* password = "Sense2023"; //Senha da Rede

//Variáveis 
bool relayState = false; //Inicia o projeto com o estado do relé falso
float segundos; //Sistema de contragem do tempo

WebServer server(80);//Inicia o Servidor do ESP

void handleRootRequest() {
  server.send(200, "text/plain", "Navegue até a página '/24'"); //Mensagem padrão fornecida pelo Esp (para caso de erro)
}

//Acionamento do relé
void handleAtualizarRele() {
  if (server.hasArg("estado")) { //Verifica se a requisição deiu certo 
    String estado = server.arg("estado");
    if (estado == "false") {
      digitalWrite(23, 1);
      relayState = true;  //caso tenha ocorrido algum erro, ele deixa o relé desligado
    }
    else if (estado == "true") {
      digitalWrite(23, 0); //Caso tenha dado certo, ele aciona o relé 
      relayState = false; 
    }
    server.send(200, "text/plain", "Atualização no estado do relé");
  }
  else {
    server.send(400, "text/plain", "Requisição inválida");
  }
}

void setup() {
  segundos = millis()/1000;  //Conversão de millisegundos para segundos
  Serial.begin(115200); //inicia o monitor serial (para caso de erro)

//Declara os pinos 
  pinMode(22, OUTPUT); //Relé 
  pinMode(4,INPUT); //Botão
  pinMode(23, OUTPUT); //Led

  WiFi.begin(ssid, password);//Conecta o Esp na rede de internet

  //Indicação se o Esp conseguiu se conectar a rede
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi"); 

  //Mostra as mensagens para caso de erro
  server.on("/", handleRootRequest);
  server.on("/24", handleAtualizarRele);
  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();//Puxa a solicitação HTTP

 //Sistema para reiniciar o tempo
  if(segundos > 5){
    digitalWrite(22,1); //Caso passe de 5 segundos, o led liga para mostrar ao operador que o sistema não vai fazer a verificação correta
    delay(5000);  
    digitalWrite(22,0);
  }

 //Sistema para reinicar o tempo e fazer a verificação da maneira devida
  if(digitalRead(4) == 1){
    segundos = 0;
    digitalWrite(22,0);
  }

}