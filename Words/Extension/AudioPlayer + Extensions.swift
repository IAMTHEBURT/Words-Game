//
//  AudioPlayer.swift
//  Words
//
//  Created by Ivan Lvov on 09.02.2023.
//

import Foundation
import AVFoundation
import SwiftUI

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){
    @AppStorage("isSoundOn") var isSoundOn: Bool = true
    
    if isSoundOn == false { return }
    
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            try AVAudioSession.sharedInstance()
                .setCategory(.playback, options: .duckOthers)
            
            try AVAudioSession.sharedInstance()
                .setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("Could not find and play the soundfile.")
        }
        
    }
}
