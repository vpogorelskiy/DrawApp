//
//  ShapesViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import Combine

final class ShapesViewModel: ObservableObject {
    
    enum Shape: Equatable {
        case square, circle, triangle, arrow
    }
    
    @Injected private var toolManager: DrawingToolManager!
    @Published private var selectedShape: DrawingMode.Shape? = nil
    
    lazy var buttonItems: [ToolbarButtonItem<DrawingMode.Shape>] = {
        [
            .init(image: AppImage.square,
                  isSelected: false,
                  value: .square,
                  onTap: { [weak self] in self?.selectShape(.square) }),
            .init(image: AppImage.circle,
                  isSelected: false,
                  value: .circle,
                  onTap: { [weak self] in self?.selectShape(.circle) }),
            .init(image: AppImage.triangle,
                  isSelected: false,
                  value: .triangle,
                  onTap: { [weak self] in self?.selectShape(.triangle) }),
            .init(image: AppImage.arrowUp,
                  isSelected: false,
                  value: .arrow,
                  onTap: { [weak self] in self?.selectShape(.arrow) }),
        ]
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK - Public methods
    
    init() {
        toolManager.drawingModePublisher
            .sink { [weak self] mode in
                if case .shape(let shape) = mode {
                    self?.buttonItems.forEach{
                        $0.isSelected = $0.value == shape
                    }
                }
            }.store(in: &cancellables)
    }
    
    func deselect() {
        selectShape(nil)
    }
    
    private func selectShape(_ shape: DrawingMode.Shape?) {
        selectedShape = shape
        
        if let shape = shape {
            toolManager.setDrawingMode(.shape(shape))
        } else {
            toolManager.setDrawingMode(nil)
        }
    }
}
