float segundos;
float milli;
void setup() {
  milli = millis();
  segundos = milli/1000;
  pinMode(4,INPUT);
  pinMode(22,OUTPUT);
  pinMode(23,OUTPUT);
  Serial.begin(9600);
}

void loop() {
  //if(digitalRead(4) == 0){
    //milli = 0;
   // if(segundos < 2){
      //digitalRead(23);
      //if(digitalRead(23 == 0)){
        //joga no banco de dados que a peça está boa;
      //}
      //else{
        //joga no banco de dados que a peça apresenta defeitos;
      //}
   // }
  //}
  digitalRead(23);
  if(digitalRead(23) == 0){
    digitalRead(15);
    Serial.println(digitalRead(15));
    digitalWrite(22,1);
  }
  else{
    Serial.println(digitalRead(23));
  }
}
