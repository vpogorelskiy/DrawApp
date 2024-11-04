//
//  TopToolbarView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI

class TopToolbarViewModel {
    @Injected var undoManager: UndoManager!
    @Injected var playbackManager: PlaybackManager!
    @Injected var layerManager: LayerManager!
    
    let gapIndices = [1, 4]
    
    lazy var buttonItems: [ToolbarButtonItem] = {
        [
           .init(image: AppImage.arrowLeft, isSelected: undoManager.canUndo, onTap: { [weak self] in self?.undoManager.undo() }),
           .init(image: AppImage.arrowRight, isSelected: undoManager.canRedo, onTap: { [weak self] in self?.undoManager.redo() }),
           .init(image: AppImage.bin, isSelected: true, onTap: { [weak self] in self?.layerManager.deleteLayer() }),
           .init(image: AppImage.filePlus, isSelected: true, onTap: { [weak self] in self?.layerManager.addLayer() }),
           .init(image: AppImage.Layers, isSelected: true, onTap: { [weak self] in self?.layerManager.showLayers() }),
           .init(image: AppImage.stop, isSelected: playbackManager.canPause, onTap: { [weak self] in self?.playbackManager.pause() }),
           .init(image: AppImage.play, isSelected: playbackManager.canPlay, onTap: { [weak self] in self?.playbackManager.play() })
       ]
    }()
}

struct TopToolbarView: View {
    
    private let viewModel: TopToolbarViewModel
    
    var body: some View {
        ForEach(Array(viewModel.buttonItems.enumerated()), id: \.offset) { index, item in
            ToolbarButton(buttonItem: item)
            
            if viewModel.gapIndices.contains(index) {
                Spacer()
            }
        }
    }
    
    init(viewModel: TopToolbarViewModel) {
        self.viewModel = viewModel
    }
}
//
//#Preview {
//    TopToolbarView()
//}
