#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "Treinamento_visitante";
const char* password = "sensetreina@23";

bool relayState = false;

WebServer server(80);

void handleRootRequest() {
  server.send(200, "text/plain", "Hello from ESP32!");
}

void handleAtualizarRele() {
  if (server.hasArg("estado")) {
    String estado = server.arg("estado");
    if (estado == "true") {
      digitalWrite(22, LOW);
      relayState = true;
    }
    else if (estado == "false") {
      digitalWrite(22, HIGH);
      relayState = false;
    }
    server.send(200, "text/plain", "Relay state updated");
  }
  else {
    server.send(400, "text/plain", "Invalid request");
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(22, OUTPUT);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  server.on("/", handleRootRequest);
  server.on("/atualizar_rele", handleAtualizarRele);

  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();
}