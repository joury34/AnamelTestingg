//
//  AudioRecorder.swift
//  PECSApp
//
//  Created by Fatimah Alqarni on 30/04/2025.
//


import AVFoundation

class AudioRecorder: ObservableObject {
    var recorder: AVAudioRecorder?
    @Published var recordingURL: URL?

    func startRecording() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        try? session.setActive(true)

        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        recordingURL = url

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try? AVAudioRecorder(url: url, settings: settings)
        recorder?.record()
    }

    func stopRecording() {
        recorder?.stop()
    }
}
