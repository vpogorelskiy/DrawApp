//
//  DrawingView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine

final class ShapeInfo {
    var startLocation: CGPoint
    let selectedTool: DrawingMode
    var path: [CGPoint]
    
    init(startLocation: CGPoint, selectedTool: DrawingMode, path: [CGPoint]) {
        self.startLocation = startLocation
        self.selectedTool = selectedTool
        self.path = path
    }
}


final class DrawingViewModel: ObservableObject {
    
    @Injected private var layerManager: LayerManager!
    @Injected private var playbackManager: PlaybackManager!
    
    @Published var currentImage: UIImage? = nil
    @Published var backgroundImage: UIImage? = nil
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        layerManager.currentImagePublisher
            .sink { [weak self] newImage in
                self?.currentImage = newImage
            }
            .store(in: &cancellables)
        
        layerManager.backgroundImagePublisher
            .sink { [weak self] newImage in
                self?.backgroundImage = newImage
            }
            .store(in: &cancellables)
    }
    
    func setImageSize(_ size: CGSize) {
        layerManager.setImageSize(size)
    }
    
    func receiveGesture(_ gesture: DragGesture.Value) {
        layerManager.draw(gesture)
    }
    
    func stopCurrentGesture(_ gesture: DragGesture.Value) {
        layerManager.stopDrawing(gesture)
    }
}

struct DrawingView: View {
    @ObservedObject var viewModel: DrawingViewModel
    
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: .center) {
                Image(uiImage: AppImage.backgroundTexture)
                if let image = viewModel.currentImage {
                    Image(uiImage: image)
                }
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        viewModel.receiveGesture(value)
                        print("DragGesture.onChanged.value: \(value)")
                    })
                    .onEnded({ value in
                        viewModel.stopCurrentGesture(value)
                        print("DragGesture.onEnded.value: \(value)")
                    })
            )
            .onAppear(perform: {
                viewModel.setImageSize(geometry.size)
            })
        })
    }
    
    init(viewModel: DrawingViewModel) {
        self.viewModel = viewModel
    }
}

//#Preview {
//    DrawingView()
//}
