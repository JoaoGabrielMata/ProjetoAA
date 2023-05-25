#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiAP.h>

const char* ssid = "Teste_ProjetoAA";
const char* password = "Sense2023";
WiFiServer server(80);
void setup() {
pinMode(23, OUTPUT);
Serial.begin(9600);
WiFi.begin(ssid, password);
IPAddress myIP = WiFi.softAPIP();
Serial.println(myIP);
server.begin();
Serial.println("Servidor Iniciado!!");
}
 
void loop() {
  
 digitalWrite(23,1);
 delay(5000);
 digitalWrite(23,0);
 delay(5000);
}
