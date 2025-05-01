//
//  AudioPlayer.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import AVFoundation

class AudioPlayer {
    private var player: AVAudioPlayer?

    func play(url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("خطأ في تشغيل الصوت: \(error.localizedDescription)")
        }
    }
}
