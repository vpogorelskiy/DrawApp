//
//  PlaybackManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

protocol PlaybackManager {
    var canPause: Bool { get }
    var canPlay: Bool { get }
    
    func pause()
    func play()
}

final class PlaybackManagerImpl: PlaybackManager {
    var canPause: Bool = false
    var canPlay: Bool = false
    
    func pause() {
        canPause.toggle()
    }
    func play() {
        canPlay.toggle()
    }
}
