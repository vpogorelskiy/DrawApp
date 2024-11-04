//
//  ShapesViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

final class ShapesViewModel: ObservableObject {
    
    enum Shape: Equatable {
        case square, circle, triangle, arrow
    }
    
    @Injected var toolManager: DrawingToolManager!
    @Published private var selectedShape: Shape? = nil
    
    lazy var buttonItems: [ToolbarButtonItem<Shape>] = {
        [
            .init(image: AppImage.square,
                  isSelected: selectedShape == .square,
                  value: .square,
                  onTap: { [weak self] in self?.selectShape(.square) }),
            .init(image: AppImage.circle,
                  isSelected: selectedShape == .circle,
                  value: .circle,
                  onTap: { [weak self] in self?.selectShape(.circle) }),
            .init(image: AppImage.triangle,
                  isSelected: selectedShape == .triangle,
                  value: .triangle,
                  onTap: { [weak self] in self?.selectShape(.triangle) }),
            .init(image: AppImage.arrowUp,
                  isSelected: selectedShape == .arrow,
                  value: .arrow,
                  onTap: { [weak self] in self?.selectShape(.arrow) }),
        ]
    }()
    
    func deselect() {
        selectShape(nil)
    }
    
    private func selectShape(_ shape: Shape?) {
        selectedShape = shape
        
        buttonItems.forEach{
            $0.isSelected = $0.value == shape
        }
        
//        buttonItems.forEach{
//            $0.isSelected ==
//
//            
//        }
        
        
    }
}
