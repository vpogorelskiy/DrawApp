//
//  PlaybackView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI

final class PlaybackViewModel: ObservableObject {
    
    @Injected var layerManager: LayerManager!
    
    @Published var currentImage: UIImage? = nil
    
    private var currentImages: [UIImage] = []
    private var currentIndex: Int = 0
    private var delay: CGFloat = 0.1
    private var timer: Timer?
    
    func startPlayback() {
        currentImages = layerManager.getLayersImages()
        if !currentImages.isEmpty {
            timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: true, block: { [weak self] timer in
                guard let self = self else { return }
                if currentIndex < currentImages.count {
                    currentImage = currentImages[currentIndex]
                    currentIndex += 1
                } else {
                    currentIndex = 0
                }
            })
        }
    }
    
    func stopPlayback() {
        timer?.invalidate()
        timer = nil
        currentImages = []
        currentImage = nil
    }
}

struct PlaybackView: View {
    @ObservedObject var viewModel: PlaybackViewModel
    
    var body: some View {
        ZStack {
            if let image = viewModel.currentImage {
                Image(uiImage: image)
            }
        }.onAppear(perform: {
            viewModel.startPlayback()
        })
        .onDisappear(perform: {
            viewModel.stopPlayback()
        })
        
    }
}
