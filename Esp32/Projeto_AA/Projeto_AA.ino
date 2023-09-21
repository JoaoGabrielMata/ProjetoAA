#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "Teste_ProjetoAA";
const char* password = "Sense2023";

bool estado = false;

WebServer server(80);

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

void handleAtualizarRele() {
  if (server.hasArg("estado")) {
    String estado = server.arg("estado");
    Serial.print("Estado recebido");
    if (estado == "false") {
      digitalWrite(23, LOW);
      Serial.println("Desligado");
    } else {
      digitalWrite(23, HIGH);
      Serial.println("Ligado");
    }
  }
}

void handleSensorData() {
  // Ler o valor do sensor e enviá-lo como JSON
  int valorSensor = digitalRead(4); // Suponha que o sensor esteja conectado ao pino 4
  String json = "{\"sensor\": " + String(valorSensor) + "}";
  server.send(200, "application/json", json);
}

void setup() {
  Serial.begin(115200);
  pinMode(4, INPUT); // Configurar o pino do sensor como entrada
  pinMode(23, OUTPUT);

  connectToWiFi();

  server.on("/", handleRootRequest);
  server.on("/rele", handleAtualizarRele);
  server.on("/sensor", handleSensorData); // Rota para fornecer dados do sensor
  server.begin();

  Serial.println("Server started");
}

void loop() {
  server.handleClient();
}
