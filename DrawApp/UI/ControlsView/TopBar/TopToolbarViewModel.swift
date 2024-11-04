//
//  TopToolbarViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI

class TopToolbarViewModel: ObservableObject {
    
    enum Action: Equatable {
        case undo, redo, delete, newLayer, layers, stop, play
    }
    
    @Injected var undoManager: UndoManager!
    @Injected var playbackManager: PlaybackManager!
    @Injected var layerManager: LayerManager!
    
    let gapIndices = [1, 4]
    
    lazy var buttonItems: [ToolbarButtonItem<Action>] = {
        [
           .init(image: AppImage.arrowLeft, 
                 isSelected: undoManager.canUndo,
                 value: .undo,
                 onTap: { [weak self] in self?.undoManager.undo() }),
           .init(image: AppImage.arrowRight, 
                 isSelected: undoManager.canRedo,
                 value: .redo,
                 onTap: { [weak self] in self?.undoManager.redo() }),
           .init(image: AppImage.bin, 
                 isSelected: true,
                 value: .delete,
                 onTap: { [weak self] in self?.layerManager.deleteLayer() }),
           .init(image: AppImage.filePlus, 
                 isSelected: true,
                 value: .newLayer,
                 onTap: { [weak self] in self?.layerManager.addLayer() }),
           .init(image: AppImage.Layers, 
                 isSelected: true,
                 value: .layers,
                 onTap: { [weak self] in self?.layerManager.showLayers() }),
           .init(image: AppImage.stop, 
                 isSelected: playbackManager.canPause,
                 value: .stop,
                 onTap: { [weak self] in self?.playbackManager.pause() }),
           .init(image: AppImage.play, 
                 isSelected: playbackManager.canPlay,
                 value: .play,
                 onTap: { [weak self] in self?.playbackManager.play() })
       ]
    }()
}
