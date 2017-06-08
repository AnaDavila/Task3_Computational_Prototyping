//Class is named
class BinauralBeats {
//Import core audio set up for the Beads library
AudioContext ac;
 //Imports beads public class WavePlayer 
 //Carrier wave oscillatior
 WavePlayer carrierOsc;
 
  WavePlayer differenceOsc;
  WavePlayer diffOsc;

  float freq = 200;
  float diff = 14;
  //-----------------------------------
  //constructor is called
  BinauralBeats() {
    ac = new AudioContext();

    carrierOsc = new WavePlayer(ac, freq, Buffer.SINE);
    differenceOsc = new WavePlayer(ac, freq+diff, Buffer.SINE);
    diffOsc = new WavePlayer(ac, freq, Buffer.SINE);
     
     
     //
    Gain g = new Gain(ac, 1, 0.1);
    g.addInput(carrierOsc);
    g.addInput(differenceOsc);
    g.addInput(diffOsc);
    ac.out.addInput(g);
    ac.start();
  }
  //-----------------------------------
  void set_frequency(float _freq) {
    freq = _freq; 
    carrierOsc.setFrequency(freq);
    differenceOsc.setFrequency(freq+diff);
  }
  void set_difference(float _diff) {
    diff = _diff;
  }
  //-----------------------------------
  //controls master volume
  float get_master_volume() {
    return ac.out.getValue(1, 0);
  }
  float get_carrier_phase() {
    return carrierOsc.getPhase();
  }
  float get_difference_phase() {
    diffOsc.setFrequency(differenceOsc.getFrequency() - carrierOsc.getFrequency());

    return diffOsc.getPhase();
  }}