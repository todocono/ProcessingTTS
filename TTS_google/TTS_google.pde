// This code works on Processing 4 and the new API v2 from Google
// 
// Code based on the work of https://amnonp5.wordpress.com/2011/11/26/text-to-speech/
// Adapted by Rudi for Interaction Lab at NYU Shanghai -  12/Dec/2022


import java.net.*;
import java.io.*;
import ddf.minim.*;

Minim minim;
AudioPlayer player;

String s = "Type here";

void setup() {
  size(1280, 720);
  minim = new Minim(this);
  textAlign(CENTER, CENTER);
  textSize(50);
  stroke(255);
}

void draw() {
  background(0);
  text(s, 0, 0, width, height);
  if (player != null) {
    translate(0, 250);
    for (int i = 0; i < player.left.size()-1; i++) {
      line(i, 50 + player.left.get(i)*50, i+1, 50 + player.left.get(i+1)*50);
      line(i, 150 + player.right.get(i)*50, i+1, 150 + player.right.get(i+1)*50);
    }
  }
}

void keyPressed() {
  if (keyCode == BACKSPACE) {
    if (s.length() > 0) {
      s = s.substring(0, s.length()-1);
    }
  } else if (keyCode == DELETE) {
    s = "";
  } else if (keyCode == ENTER) {
    googleTTS(s, "en");
    if (player != null) {
      player.close();
    } // comment this line to layer sounds
   // player = minim.loadFile(s + ".mp3", 2048);
    player = minim.loadFile(1 + ".mp3", 2048);
    player.play();
    s = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && s.length() < 100) {
    s += key;
  }
}

void googleTTS(String txt, String language) {
  //String u = "http://translate.google.com/translate_tts?tl=";
  //u = u + language + "&q=" + txt;
  //u = u.replace(" ", "%20");
  String u = "https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&";
  u = u + language + "&q=" + txt;
  u = u.replace(" ", "+");
    
  //https://translate.google.com/translate_tts?ie=UTF-8&client=tw-ob&tl=en&q=Hello+World
  try {
    URL url = new URL(u);
    try {
      URLConnection connection = url.openConnection();
      connection.setRequestProperty("User-Agent", "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; .NET CLR 1.0.3705; .NET CLR 1.1.4322; .NET CLR 1.2.30703)");
      connection.connect();
      InputStream is = connection.getInputStream();
     // File f = new File(sketchPath() + "/" + txt + ".mp3");
      File f = new File(sketchPath() + "/" + 1 + ".mp3");
      OutputStream out = new FileOutputStream(f);
      byte buf[] = new byte[1024];
      int len;
      while ((len = is.read(buf)) > 0) {
        out.write(buf, 0, len);
      }
      out.close();
      is.close();
     // println("File created: " + txt + ".mp3");
    }
    catch (IOException e) {
      e.printStackTrace();
    }
  }
  catch (MalformedURLException e) {
    e.printStackTrace();
  }
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
