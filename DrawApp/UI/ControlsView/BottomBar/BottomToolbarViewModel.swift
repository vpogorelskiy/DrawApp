//
//  BottomToolbarViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine

class BottomToolbarViewModel: ObservableObject {
    
    enum Tool: Equatable {
        case pencil, brush, erase
        case shapes
        case color
    }
    
    @Injected var toolManager: DrawingToolManager!
    
    @Published var isShapesMenuShown = false
    @Published var isColorsMenuShown = false
    @Published var isPaletteMenuShown = false
    
    @Published private var selectedTool: Tool? = nil
    
    public let simpleColorsViewModel = ColorsViewModel()
    public let paletteViewModel = PaletteViewModel()
    public let shapesViewModel = ShapesViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var colorItem: ToolbarButtonItem<Tool> = .init(imageType: .circle(toolManager.selectedColor),
                                                                isSelected: selectedTool == .color,
                                                                value: .color,
                                                                onTap: { [weak self] in self?.selectTool(.color) })
    
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
            colorItem
        ]
    }()
    
    init() {
        simpleColorsViewModel.$isPaletteMenuShown
            .assign(to: \.isPaletteMenuShown, on: self)
            .store(in: &cancellables)
    }
    
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
            if (!isColorsMenuShown) {
                isPaletteMenuShown = false
            }
        }
        
        buttonItems.forEach{
            if $0.value == tool {
                $0.isSelected.toggle()
            }
        }
    }
    
    private func updateItems() {
        
    }
}
