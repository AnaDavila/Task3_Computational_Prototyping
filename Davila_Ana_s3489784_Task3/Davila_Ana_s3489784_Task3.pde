//Imports beads sound libraries
import beads.*;
//Import array lists for samples
import java.util.Arrays; 
//Import core audio set up for the Beads library
AudioContext ac;
//Imports public class WavePlayer 
WavePlayer sine;
//Imports public class Panner (for audio panning)
Panner p;

float strokeValue;
float speed;
import controlP5.*;


//Classes---------------------------------------------------------------------------------

//Importing classes into main sketch
BinauralBeats binaural;
AudioPlayer sample;

//-------------------------------------------------------------------------------------------------------------------------
//Size range for visuals
float size = 800;
//Boolean in order to pause the array of samples
boolean bPause[] = new boolean[5];
//String to bring location of samples in
String paths[] = new String[5];

//Splash screen boolean 
boolean bStart = false;
//imports font class. Will be used for splash screen
PFont f;


// Array List for sample player and panning array list that goes with them
ArrayList<SamplePlayer> samples = new ArrayList<SamplePlayer>();
ArrayList<Panner> panners = new ArrayList<Panner>();
ControlP5 cp5;
//-------------------------------------------------------------------------------------------------------------------
void setup() {
  //calling specific font and size in
    f = createFont("Arial", 16, true);
  //Calls full screen
   fullScreen();

  
  cp5 = new ControlP5(this);
//slider allowing the stroke weight to be manipulated throughout sketch      
     cp5.addSlider("strokeValue")
     .setRange(1,200)
     .setValue(70)
     .setPosition(10,10)
     .setSize(100,10);
//slider allowing the speed of the animation to be manipulated throughout the sketch  
     cp5.addSlider("speed")
     .setRange(1,5)
     .setValue(5)
     .setPosition(10,30)
     .setSize(100,10);


//Calls Beads audio set up to run throughout the whole sketch
  ac = new AudioContext();
//Paths for each sound sample
  paths[0] = "/Users/anadavilaveytia/Desktop/SOUNDS/FOREST/Forest.wav";
  paths[1] = "/Users/anadavilaveytia/Desktop/SOUNDS/WATER/RAIN/Rain.wav";
  paths[2] = "/Users/anadavilaveytia/Desktop/SOUNDS/INSTRUMENTS/TuningFork.wav";
  paths[3] = "/Users/anadavilaveytia/Desktop/SOUNDS/INSTRUMENTS/SingingBowl.wav";
  paths[4] = "/Users/anadavilaveytia/Desktop/SOUNDS/INSTRUMENTS/Gong.wav";


  binaural = new BinauralBeats();
  sample = new AudioPlayer();
//The sine wave player will run the panning of the samples
  sine = new WavePlayer(ac, 01, Buffer.SINE);
  
  
  //--------booleanplayer--------------------------------------------------
  
  //number indicates which sample is triggered
   for (int i = 0; i < 5; i++) {
    bPause[i] = true;
    samples.add(new SamplePlayer(ac, SampleManager.sample(paths[i])));
    SamplePlayer sample = samples.get(i);
    sample.pause(bPause[i]);
    //sample.start();
    
// initialize the panner. to set a constant pan position,in this case a sine wave will be called in to control the panning
    panners.add(new Panner(ac, sine));
    Panner p = panners.get(i);
    p.addInput(sample);
    Gain g = new Gain(ac, 1, 0.2);
    p.addInput(g);
    ac.out.addInput(p);
  
  }

//Initialises sample player
 ac.start();
ac = new AudioContext(); 

}

//Calls the splash screen when the sketch has been initialized
void draw_splash_screen() {
  background(0);
  textAlign(CENTER);
  
}
//--------------------------------------------------------------------------------------
void draw() {
//splash
//The splash screen wont be removed until the boolean set up for called true
  if (bStart == false) {
    draw_splash_screen();
//Sets up text for splash screen. Instructions for the user to interact with sketch
    textSize(35);
    text("Click for time out", width/2, height/2);
    
    textSize(16);
    text("press 1, 2, 3, 4, 5 for different sounds", width/2, height/1.5);
  
  }
  
  else if (bStart == true) {
  
 //If the boolean is called true  the binaural beats class is initialized
  float volume = binaural.get_master_volume();
  float carrier = binaural.get_carrier_phase();
  float difference = binaural.get_difference_phase();

//maps the Binauralbeats class frequency to the mouse
  binaural.set_frequency(map(mouseX, 1, width, 100.0, 100.0));
//maps the Binauralbeats class difference to the mouse
//Second gui slider affects the speed of the pulses
binaural.set_difference(map(mouseY, 5, height, 0.0, speed));

  //background-------------------------------------------------------------------------
  float diff_phase = map(difference, 0.0, 1.0, 2, 100);
  background(diff_phase);
  noFill();
 //fill(sliderValue);

//Controls size and colour of the different pulses/ellipses
  rectMode(CENTER);
  strokeWeight(90);
  stroke(255, 255, 255, diff_phase);
  ellipse(width/2, height/2, difference*size*5, difference*size*5);

//instance where strokeWeight is affected by strokeValue gui
  rectMode(CENTER);
  strokeWeight(strokeValue);
  stroke(255, 255, 255, diff_phase);
  ellipse(width/2, height/2, difference*size*8, difference*size*8);

  rectMode(CENTER);
  strokeWeight(strokeValue);
  stroke(255, 255, 255, diff_phase);
  ellipse(width/2, height/2, difference*size, difference*size);

  rectMode(CENTER);
  strokeWeight(strokeValue);
  stroke(255, 255, 255, diff_phase);
  //___/2___/2 location
  ellipse(width/2, height/2, difference*size*2, difference*size*2);

  rectMode(CENTER);
  strokeWeight(20);
  stroke(255, 255, 255, diff_phase);
  //___/2___/2 location
  ellipse(width/2, height/2, difference*size*3, difference*size*3);

  rectMode(CENTER);
  strokeWeight(10);
  stroke(255, 255, 255, diff_phase);
  //___/2___/2 location
  ellipse(width/2, height/2, difference*size*6, difference*size*6);
}}
//Player------------------------------------------------------------------------------------------
void loadSample(String path) {

  SamplePlayer player = new SamplePlayer(ac, SampleManager.sample(path));

  Gain g = new Gain(ac, 2, 0.2);
  g.addInput(player);
  ac.out.addInput(g);
  ac.start();
  }
//------------------------------------------------------------------------------------------


//splash screen
void mousePressed() {
  //tells the sketch to start the other functions once the mouse has been pressed for the first time
  bStart = true;
}
//Controls the sample layering. If the key is pressed the first sample will be called
//through the string path. If the key is pressed again then the boolean set up at the start of the sketch  will pause the sample
void keyPressed () {
  if (key == '1') {
    SamplePlayer sample = samples.get(0);
    bPause[0] = !bPause[0];
    sample.pause(bPause[0]);

  }
  if (key == '2') {
     SamplePlayer sample = samples.get(1);
    bPause[1] = !bPause[1];
    sample.pause(bPause[1]);
    //loadSample(paths[1]);
  }
  if (key == '3') {
   
    SamplePlayer sample = samples.get(2);
    bPause[2] = !bPause[2];
    sample.pause(bPause[2]);

  }

  if (key == '4') {
     SamplePlayer sample = samples.get(3);
    bPause[3] = !bPause[3];
    sample.pause(bPause[3]);
    

  }
  if (key == '5') {
     SamplePlayer sample = samples.get(4);
    bPause[4] = !bPause[4];
    sample.pause(bPause[4]);
      }
}