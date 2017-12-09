
import ddf.minim.*;
import ddf.minim.analysis.*;

ddf.minim.Minim minim;
ddf.minim.AudioInput in;
FFT fft;

FileNamer fileNamer;

void setup() {
  size(1280, 720, P2D);

  minim = new Minim(this);
  in = minim.getLineIn();
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.logAverages(10, 1);
  println(fft.avgSize());

  fileNamer = new FileNamer("output/export", "png");

  reset();
}

void reset() {
}

void draw() {
  background(0);
  fft.forward(in.mix);
  drawFft(fft);
}

void drawFft(FFT fft) {
  float bandWidth = (float)width / fft.avgSize();
  for (int i = 0; i < fft.avgSize(); i++) {
    // draw the line for frequency band i, scaling it up so we can see it a bit better
    float h = fft.getAvg(i) * 8;
    rect(i * bandWidth, height - h, bandWidth, h);
  }
}

void keyReleased() {
  switch (key) {
    case 'e':
      reset();
      break;
    case 'r':
      saveRender();
      break;
  }
}

void saveRender() {
  saveFrame(fileNamer.next());
}
