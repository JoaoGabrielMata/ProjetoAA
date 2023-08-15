// Bibliotecas
#include <WiFi.h>
#include <WebServer.h>

// Cadastro do Wi-Fi
const char* ssid = "Teste_ProjetoAA"; // Nome da Rede
const char* password = "Sense2023";  // Senha da Rede

// Variáveis
bool relayState = false; // Estado atual do relé (false = desligado, true = ligado)
bool estado = false;
float segundos;  // Sistema de contagem do tempo

WebServer server(80); // Inicia o Servidor do ESP

// Função para conectar ao Wi-Fi
void connectToWiFi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
  }
  digitalWrite(23, 1); // LED ligado indica que o ESP se conectou ao Wi-Fi com sucesso
  Serial.println("Connected to WiFi");
}

// Tratamento da página inicial
void handleRootRequest() {
  server.send(200, "text/plain", ""); // Mensagem padrão fornecida pelo ESP (caso de erro)
}

// Acionamento do relé
void handleAtualizarRele() {
  if (server.hasArg("estado")) { // Verifica se a requisição tem o parâmetro "estado"
    String estado = server.arg("estado");
    if (estado == "false") {
      digitalWrite(22, 1);  // Desliga o relé (pino HIGH)
      relayState = true;     // Marca o relé como desligado
    } else if (estado == "true") {
      digitalWrite(22, 0);  // Liga o relé (pino LOW)
      relayState = false;    // Marca o relé como ligado
    }

    server.send(200, "text/plain", "Atualização no estado do relé");
  } else {
    server.send(400, "text/plain", "Requisição inválida");
  }
}

void setup() {
  Serial.begin(115200); // Inicia o monitor serial (para caso de erro)

  pinMode(22, OUTPUT);
  pinMode(4, INPUT);
  pinMode(23, OUTPUT);

  connectToWiFi(); // Conecta o ESP à rede de internet

  // Mostra as mensagens para caso de erro
  server.on("/", handleRootRequest);
  server.on("/", handleAtualizarRele);
  server.begin();

  segundos = millis() / 1000; // Conversão de millisegundos para segundos
  Serial.println("Server started");
}

void loop() {
  server.handleClient(); // Puxa a solicitação HTTP

  // Sistema para reiniciar o tempo e fazer a verificação da maneira adequada
  if (digitalRead(4) == 1) {
    segundos = 0;
  }
}
