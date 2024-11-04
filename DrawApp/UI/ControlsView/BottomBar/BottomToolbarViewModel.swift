//
//  BottomToolbarViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI

class BottomToolbarViewModel: ObservableObject {
    
    enum Tool: Equatable {
        case pencil, brush, erase
        case shapes
        case color
    }
    
    @Injected var toolManager: DrawingToolManager!
    
    @Published var isShapesMenuShown = true
    @Published var isColorsMenuShown = true
    
    @Published private var selectedTool: Tool? = nil
    
    public let simpleColorsViewModel = ColorsViewModel()
    public let paletteViewModel = PaletteViewModel()
    public let shapesViewModel = ShapesViewModel()
    
    lazy var buttonItems: [ToolbarButtonItem<Tool>] = {
        [
            .init(image: AppImage.pencil,
                  isSelected: selectedTool == .pencil,
                  value: .pencil,
                  onTap: { [weak self] in self?.selectTool(.pencil) }),
            .init(image: AppImage.brush,
                  isSelected: selectedTool == .brush,
                  value: .brush,
                  onTap: { [weak self] in self?.selectTool(.brush) }),
            .init(image: AppImage.erase,
                  isSelected: selectedTool == .erase,
                  value: .erase,
                  onTap: { [weak self] in self?.selectTool(.erase) }),
            .init(image: AppImage.shapes,
                  isSelected: selectedTool == .shapes,
                  value: .shapes,
                  onTap: { [weak self] in self?.selectTool(.shapes) }),
            .init(imageType: .double(bottom: AppImage.circleFilled(withColor: toolManager.selectedColor),
                                     top: AppImage.colorCircle),
                  isSelected: selectedTool == .color,
                  value: .color,
                  onTap: { [weak self] in self?.selectTool(.color) })
        ]
    }()
    
    func dismissOverlay() {
        isShapesMenuShown = false
        isColorsMenuShown = false
        simpleColorsViewModel.isPaletteMenuShown = false
    }
    
    func deselect() {
        selectTool(nil)
    }
    
    private func selectTool(_ tool : Tool?) {
        if tool == .shapes {
            isShapesMenuShown.toggle()
        }
        
        if tool == .color {
            isColorsMenuShown.toggle()
        }
        
        buttonItems.forEach{
            $0.isSelected = $0.value == tool
        }
    }
    
    private func updateItems() {
        
    }
}
