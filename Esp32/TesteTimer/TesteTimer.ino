unsigned long startTime = 0;  // Variável para armazenar o tempo de início da contagem
unsigned long elapsedTime = 0;  // Variável para armazenar o tempo decorrido

void setup() {
  pinMode(4, OUTPUT);   // LED
  pinMode(22, OUTPUT);  // RELÉ
  pinMode(23, INPUT);   // SENSOR
  pinMode(5, INPUT_PULLUP);  // BOTÃO
  Serial.begin(9600);

  startTime = millis();  // Inicializa o tempo de início da contagem
}

void loop() {
  /// Teste de Peça ////
  if (digitalRead(23) == 1) {  // Se o sensor identificar alguma coisa
    digitalWrite(22, 0);  // Ele aciona o relé, que nesse caso é ativado com 0
  } else {  // Caso não identifique nada
    digitalWrite(22, 1);  // Ele simplesmente deixa o relé parado
  }

  /// Identificação Visual ////
  if (digitalRead(22) == 0) {  // Caso o relé acione
    digitalWrite(4, 1);  // Liga o LED para que o operador identifique
    delay(3000);  // Espera 3s
    digitalWrite(4, 0);  // Apaga o LED
  } else {  // Caso relé não acione
    digitalWrite(4, 0);  // LED desligado
  }

  //// Sistema de Contagem ////
  unsigned long currentTime = millis();  // Obtém o tempo atual
  elapsedTime = currentTime - startTime;  // Calcula o tempo decorrido

  Serial.print("Tempo decorrido: ");
  Serial.print(elapsedTime);
  Serial.println(" milissegundos");

  if (digitalRead(5) == 1) {  // Verifica se o botão foi pressionado
    startTime = currentTime;  // Reinicia o tempo de início da contagem
  }


  delay(100);  // Pequena pausa entre as iterações do loop
}
