//
//  TopToolbarView.swift
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
    
    @Published var isShapesMenuShown = false
    @Published var isColorsMenuShown = false
    @Published var isPalleteMenuShown = false
    
    @Published private var selectedTool: Tool? = nil
    
    lazy var buttonItems: [ToolbarButtonItem] = {
        [
            .init(image: AppImage.pencil,
                  isSelected: selectedTool == .pencil,
                  onTap: { [weak self] in self?.selectTool(.pencil) }),
            .init(image: AppImage.brush,
                  isSelected: selectedTool == .brush,
                  onTap: { [weak self] in self?.selectTool(.brush) }),
            .init(image: AppImage.erase,
                  isSelected: selectedTool == .erase,
                  onTap: { [weak self] in self?.selectTool(.erase) }),
            .init(image: AppImage.shapes,
                  isSelected: selectedTool == .shapes,
                  onTap: { [weak self] in self?.selectTool(.shapes) }),
            .init(image: AppImage.circleFilled(withColor: toolManager.selectedColor),
                  isSelected: selectedTool == .color,
                  onTap: { [weak self] in self?.selectTool(.color) })
        ]
    }()
    
    func deselectTool() {
        selectTool(nil)
    }
    
    private func selectTool(_ tool : Tool?) {
        isShapesMenuShown = tool == .shapes
        isColorsMenuShown = tool == .color
    }
}
