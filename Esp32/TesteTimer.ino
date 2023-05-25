float segundos;
float milli;
void setup() {
  milli = millis();
  segundos = milli/1000;
  pinMode(4,INPUT);
  pinMode(22,OUTPUT);
  pinMode(23,INPUT);
  Serial.begin(9600);
}

void loop() {
  //if(digitalRead(23) == 0){
    //milli = 0;
    // if(segundos < 2){
      //if(digitalRead(4 == 1)){
        //joga no banco de dados que a peça está boa;
      //}
      //else{
        //joga no banco de dados que a peça apresenta defeitos;
      //}
   // }
  //}

  
  if(digitalRead(4)==1){
    digitalWrite(22,1);
    Serial.println(digitalRead(4));
  } 
  else if(digitalRead(4)==0){
    digitalWrite(22,0);
  }
}
