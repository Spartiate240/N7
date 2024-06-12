package main;

import java.net.URL;

import javax.sound.sampled.AudioInputStream;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;

public class Son {
	Clip clip;
	URL sonURL[] = new URL[30];

	public Son() {
		sonURL[0] = getClass().getResource("/sons/projettobmusic.wav");
		sonURL[1] = getClass().getResource("/sons/coin.wav");
		sonURL[2] = getClass().getResource("/sons/powerup.wav");
		sonURL[3] = getClass().getResource("/sons/unlock.wav");
		sonURL[4] = getClass().getResource("/sons/fanfare.wav");
	}

	public void setFichier(int i) {

		try {
			AudioInputStream ais = AudioSystem.getAudioInputStream(sonURL[i]);
			clip = AudioSystem.getClip();
			clip.open(ais);
		} catch (Exception e) {

		}
	}

	public void play() {
		clip.start();
	}

	public void loop() {
		clip.loop(Clip.LOOP_CONTINUOUSLY);
	}

	public void stop() {
		clip.stop();
	}

}
