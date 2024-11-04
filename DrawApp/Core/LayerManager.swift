//
//  PlaybackManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

protocol LayerManager {
    func deleteLayer()
    func addLayer()
    func showLayers()
}

final class LayerManagerImpl: LayerManager {
    func deleteLayer() { }
    func addLayer() { }
    func showLayers() { } 
}
