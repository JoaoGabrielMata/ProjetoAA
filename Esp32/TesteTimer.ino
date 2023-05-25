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
  Serial.println(segundos);
  if (digitalRead(23) == 0){
    segundos = 0;
  }

  if(digitalRead(4)==1){
    if(segundos < 5){
      digitalWrite(22,1);
      delay(3000);
      digitalWrite(22,0);
      delay(2000);
    }
    else{
      digitalWrite(22,0);
    }
  }
  

  
  //if(digitalRead(4)==1){
    //digitalWrite(22,1);
    //Serial.println(digitalRead(4));
 // } 
  //else if(digitalRead(4)==0){
    //digitalWrite(22,0);
  //}
}
