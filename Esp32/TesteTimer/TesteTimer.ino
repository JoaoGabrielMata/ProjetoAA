void setup() {
  pinMode(4,OUTPUT);
  pinMode(22,OUTPUT);
  pinMode(23,INPUT);
  Serial.begin(9600);
}

void loop() {
  //pino 22 = relé
  //pino 23 = sensor
  //pino 4 = led
  
//// Teste da peça com o relé ////
  if(digitalRead(23)==1){ //Se o sensor identificar alguma coisa
    digitalWrite(22,0); //Ele aciona o relé, que nesse caso é ativado com 0
  }
  else{ //Caso não identifique nada
    digitalWrite(22,1); //Ele simplesmente deixa o relé parado
  }
//////////////////////////////////

//Teste 
if(digitalRead(22)==0){
  digitalWrite(4,1);
  delay(3000);
  digitalWrite(4,0);
}
else{
  digitalWrite(4,0);
}
}
