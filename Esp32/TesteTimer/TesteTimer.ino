#include <WiFi.h>
#include <WebServer.h>

const char* ssid = "Teste_ProjetoAA";
const char* password = "Sense2023";

unsigned long startTime = 0;
unsigned long elapsedTime = 0;
bool pieceDetected = false;
bool relayState = false;

WebServer server(80);

void handleRootRequest() {
  if (pieceDetected) {
    if (elapsedTime <= 2) {
      digitalWrite(4, HIGH);
      delay(3000);
      digitalWrite(4, LOW);
    }
    else {
      digitalWrite(22, LOW);
      delay(3000);
      digitalWrite(22, HIGH);
    }
  }
  server.send(200, "text/plain", "Hello from ESP32!");
}

void handleRelayControl() {
  if (server.hasArg("state")) {
    String state = server.arg("state");
    if (state == "1") {
      digitalWrite(22, LOW);
      relayState = true;
    }
    else if (state == "0") {
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
  Serial.begin(115200);  // Inicializa o monitor serial
  pinMode(4, OUTPUT);
  pinMode(22, OUTPUT);
  pinMode(23, INPUT);
  pinMode(5, INPUT_PULLUP);

  startTime = millis() / 1000;

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");

  server.on("/", handleRootRequest);
  server.on("/relay", handleRelayControl);

  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();

  if (digitalRead(23) == 1) {
    pieceDetected = true;
  }
  else {
    digitalWrite(22, HIGH);
    pieceDetected = false;
  }

  if (pieceDetected) {
    if (elapsedTime <= 2) {
      digitalWrite(4, HIGH);
      delay(3000);
      digitalWrite(4, LOW);
    }
    else {
      digitalWrite(22, LOW);
      delay(3000);
      digitalWrite(22, HIGH);
    }
  }

  unsigned long currentTime = millis() / 1000;
  elapsedTime = currentTime - startTime;

  if (digitalRead(5) == 1) {
    startTime = currentTime;
  }

  delay(100);
}
