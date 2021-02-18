//
//  ViewController.swift
//  VoiceLavel
//
//  Created by 申潤五 on 2021/2/18.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,AVCaptureAudioDataOutputSampleBufferDelegate {

    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var level: UIProgressView!
    var session:AVCaptureSession!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVCaptureSession()
        let audioDevice = AVCaptureDevice.default(for: .audio)
        var audioInput: AVCaptureDeviceInput? = nil
        do {
            if let audioDevice = audioDevice {
                audioInput = try AVCaptureDeviceInput(device: audioDevice)
                session.addInput(audioInput!)
            }
        } catch {
            print(error.localizedDescription)
        }

        let output = AVCaptureAudioDataOutput()
        output.setSampleBufferDelegate(self, queue: .main)
        
        session.addOutput(output)
        session.startRunning()
    }

    func captureOutput(_ captureOutput: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let channel = connection.audioChannels[0]
        let averagePowerLevel = channel.averagePowerLevel // NB: not KVO-able!
        let peak = channel.peakHoldLevel
        print(String(format: "averagePowerLevel: %.2lf peak:%.2lf", averagePowerLevel,peak))
        
        level.progress = abs(peak) / 30
        levelLabel.text = String(format: "averagePowerLevel: %.2lf", abs(peak) / 30 )
    }
}

