unsigned long startTime = 0;  // Variável para armazenar o tempo de início da contagem
unsigned long elapsedTime = 0;  // Variável para armazenar o tempo decorrido

bool pieceDetected = false;  // Variável para indicar se uma peça foi detectada

void setup() {
  pinMode(4, OUTPUT);   // LED
  pinMode(22, OUTPUT);  // RELÉ
  pinMode(23, INPUT);   // SENSOR
  pinMode(5, INPUT_PULLUP);  // BOTÃO
  Serial.begin(9600);

  startTime = millis() / 1000;  // Inicializa o tempo de início da contagem em segundos
}

void loop() {

 //Detecta peças
  if (digitalRead(23) == 1) {  // Se o sensor identificar alguma coisa
    pieceDetected = true;  // Indica que uma peça foi detectada
  } else {  // Caso não identifique nada
    digitalWrite(22, 1);  // Desliga o relé (alto)
    pieceDetected = false;  // Indica que nenhuma peça foi detectada
  }

 //Lógica Relé e Led
 if (pieceDetected) {
   if(elapsedTime <= 2){
     digitalWrite(4,1);
     delay(3000);
     digitalWrite(4,0);
   }
   else{
     
     digitalWrite(22,0);
     delay(3000);
     digitalWrite(22,1);
   }
 }

 //Sistema de contagem do tempo
  unsigned long currentTime = millis() / 1000;  // Obtém o tempo atual em segundos
  elapsedTime = currentTime - startTime;  // Calcula o tempo decorrido

  Serial.print("Tempo decorrido: ");
  Serial.print(elapsedTime);
  Serial.println(" segundos");

 //Reinicia Tempos
  if (digitalRead(5) == 1) {  // Verifica se o botão foi pressionado
    startTime = currentTime;  // Reinicia o tempo de início da contagem
  }

  delay(100);  // Pequena pausa entre as iterações do loop
}
