unsigned long startTime = 0; // Variável para armazenar o tempo de início da contagem
unsigned long elapsedTime = 0; // Variável para armazenar o tempo decorrido
unsigned long pieceStartTime = 0; // Variável para armazenar o tempo de início da peça
const unsigned long GOOD_PIECE_TIME = 2000; // Tempo em milissegundos para considerar uma peça boa
const unsigned long DETECTION_DELAY = 500;  // Atraso em milissegundos após a detecção da peça

bool pieceDetected = false; // Variável para indicar se uma peça foi detectada

void setup() {
  pinMode(4, OUTPUT); // LED
  pinMode(22, OUTPUT); // RELÉ
  pinMode(23, INPUT); // SENSOR
  pinMode(5, INPUT_PULLUP); // BOTÃO
  Serial.begin(9600);

  startTime = millis(); // Inicializa o tempo de início da contagem
}

void loop() {

  if (digitalRead(23) == 1) {  // Se o sensor identificar alguma coisa
    digitalWrite(22, 0);  // Ele aciona o relé, que nesse caso é ativado com 0
    if (!pieceDetected) {
      pieceStartTime = millis(); // Armazena o tempo de início da peça, apenas na detecção inicial da peça
      pieceDetected = true; // Indica que uma peça foi detectada
    }
  } else { // Caso não identifique nada
    digitalWrite(22, 1); // Ele simplesmente deixa o relé parado
    pieceDetected = false; // Indica que nenhuma peça foi detectada
  }

  unsigned long currentTime = millis();  // Obtém o tempo atual
  elapsedTime = currentTime - startTime;  // Calcula o tempo decorrido

  Serial.print("Tempo decorrido: ");
  Serial.print(elapsedTime);
  Serial.println(" milissegundos");

  if (pieceDetected) {
    digitalWrite(4, 1); // Liga o LED para que o operador identifique
    delay(DETECTION_DELAY); // Atraso após a detecção da peça

    if (digitalRead(22) == 0) { // Caso o relé acione
      unsigned long pieceElapsedTime = currentTime - pieceStartTime; // Calcula o tempo decorrido da peça
      if (pieceElapsedTime <= GOOD_PIECE_TIME) { // Verifica se o tempo decorrido da peça é maior ou igual ao tempo para peça boa
        // Peça boa
        Serial.println("Peça Boa");
      } else {
        // Peça ruim
        Serial.println("Peça Ruim");
      }
      delay(3000);  // Espera 3s
      pieceDetected = false;  // Reinicia a detecção de peça
    }
    digitalWrite(4, 0);  // Apaga o LED
  } else {
    digitalWrite(4, 0);  // LED desligado
  }

  if (digitalRead(5) == 1) {  // Verifica se o botão foi pressionado
    startTime = currentTime;  // Reinicia o tempo de início da contagem
  }

  delay(100);  // Pequena pausa entre as iterações do loop
}
