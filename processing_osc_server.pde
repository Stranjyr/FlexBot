import processing.serial.*;
import oscP5.*;

float EEG0 = 0;
float EEG1 = 0;
float EEG2 = 0;
float EEG3 = 0;
float ACC2 = 0;

float avgEEG = 0;
String drive = "2"; 
int time = 0;
int sendBit = 1; 
int turnBit = 0;
int xPos = 1;


boolean debug = false;

//OSC PARAMETERS & PORTS
int recvPort = 5000;
OscP5 oscP5;

//Serial port
Serial myPort;

void setup() {
  size(400, 300);
  frameRate(60);

  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  background(0);
  
   String portName = Serial.list()[3]; 
   print(portName);
   myPort = new Serial(this, portName, 19200);
}

void draw() {
  background(0); 
}

void oscEvent(OscMessage msg) {
  /* print the address path and the type string of the received OscMessage */
  if (debug) {
    print("---OSC Message Received---");
    println(msg);
  }
  if (msg.checkAddrPattern("/muse/eeg")==true) {  
    

        EEG0 =  msg.get(0).floatValue();

        EEG1 =  msg.get(1).floatValue();
      

        EEG2 =  msg.get(2).floatValue();
      

        EEG3 =  msg.get(3).floatValue();
      
      
      //time = millis();
      avgEEG = ( EEG0 + EEG1 + EEG2 + EEG3) / 4;
      
      if (avgEEG >= 1000) {
        print("Over the Average\n");
        if (millis() - time > 500) {
           time = millis();
           if (sendBit == 1) sendBit = 0;
           else sendBit = 1;       
        }
      
      
    } 
  }
  
  if (msg.checkAddrPattern("/muse/acc")==true) { 
    for (int j = 0; j < 3; j++) {
      //print("ACC on channel ", j, ": ", msg.get(j).floatValue(), "\n");
      
      if (j == 2) {  
        ACC2 = msg.get(j).floatValue();
      }
    }
      //print(ACC2, "\n");
      if (ACC2 <= -500 ) { // turn left
        
        turnBit = 1;
        //myPort.write(turnBit);
      }
      else if ( ACC2 >= 500 ) { // turn right
        
        turnBit = 2;
        //myPort.write(turnBit);
      }
      else { // neither left nor right aka straight
        turnBit = 0;
        //myPort.write(turnBit);
    
    /*  
    ACC2 = map(ACC2, 0, 1023, 0, height); //adjusts plot range
    // draw the line:
    stroke(127, 34, 255);
    line(xPos, height, xPos, height - ACC2);

    // at the edge of the screen, go back to the beginning:
    if (xPos >= width) {
    xPos = 0;
    background(0);
    } 
    else {// increment the horizontal position:
    xPos++;
    }  
    */
            
    }
    println(turnBit);
    myPort.write(255);
    myPort.write(sendBit);
    myPort.write(turnBit);
    
  }
}