#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>

const char* ssid = "Teste_ProjetoAA";
const char* password = "Sense2023";
 
WiFiServer server(80);

void setup() {
 Serial.begin(115200);

  WiFi.begin(ssid, password);
  Serial.print("Hello Word");
  IPAddress myIP = WiFi.softAPIP();
  Serial.println(myIP);

  server.begin();
  Serial.println("Servidor Iniciado!!");
}
void loop(){
  Serial.println("Hello Word");
}