//Sistema de contagem
unsigned long tempoInicial = 0; 

void setup() {
  tempoInicial = millis();
  pinMode(4,INPUT);
  pinMode(22,OUTPUT);
  pinMode(23,INPUT);
  Serial.begin(9600);
}

void loop() {
  //Verificando se o sistema funciona ou não

  Serial.println(millis());

  //Fazendo o teste da peça
  
  if(digitalRead(23)==1){
    digitalWrite(22,0);
  }
  else{
    digitalWrite(22,1);
  }

}
