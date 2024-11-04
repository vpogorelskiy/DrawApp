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
        case pencil
        case brush
        case erase
        case shapes
        case color
    }
    
    // MARK - Public vars
    
    @Published var isShapesMenuShown = false
    @Published var isColorsMenuShown = false
    
    var buttonItems: [ToolbarButtonItem<Tool>] {
        toolItems + [shapesItem, colorItem]
    }
    
    // MARK - Private vars
    
    @Injected private var toolManager: DrawingToolManager!
    
    @Published private var selectedTool: Tool? = nil
    
    private lazy var shapesItem: ToolbarButtonItem<Tool> = .init(image: AppImage.shapes,
                                                                 isSelected: false,
                                                                 value: .shapes,
                                                                 onTap: { [weak self] in self?.selectTool(.shapes) })
    
    private lazy var colorItem: ToolbarButtonItem<Tool> = .init(imageType: .circle(toolManager.selectedColor),
                                                                isSelected: selectedTool == .color,
                                                                value: .color,
                                                                onTap: { [weak self] in self?.selectTool(.color) })
    
    private lazy var toolItems: [ToolbarButtonItem<Tool>] = [
        .init(image: AppImage.pencil,
              isSelected: false,
              value: .pencil,
              onTap: { [weak self] in self?.selectTool(.pencil) }),
        .init(image: AppImage.brush,
              isSelected: false,
              value: .brush,
              onTap: { [weak self] in self?.selectTool(.brush) }),
        .init(image: AppImage.erase,
              isSelected: false,
              value: .erase,
              onTap: { [weak self] in self?.selectTool(.erase) })
    ]
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK - Public methods
    
    init() {
        toolManager.selectedColorPublisher
            .sink { [weak self] color in
                self?.colorItem.imageStore = .circle(color)
            }
            .store(in: &cancellables)
        
        toolManager.drawingModePublisher
            .sink { [weak self] mode in
                self?.toolItems.forEach{
                    $0.isSelected = mode?.toTool() == $0.value
                }
                self?.isShapesMenuShown = mode?.isShape == true
            }.store(in: &cancellables)
    }
    
    func dismissOverlay() {
        isShapesMenuShown = false
        isColorsMenuShown = false
    }
    
    func deselect() {
        selectTool(nil)
    }
    
    // MARK - Private methods
    
    private func selectTool(_ tool : Tool?) {
        
        selectedTool = tool != selectedTool ? tool : nil
        
        buttonItems.forEach {
            $0.isSelected = $0.value == tool
        }
        
        isColorsMenuShown = selectedTool == .color
        isShapesMenuShown = selectedTool == .shapes

        if let drawingMode = selectedTool?.toDrawingMode() {
            toolManager.setDrawingMode(drawingMode)
        }
    }
}

fileprivate extension DrawingMode {
    func toTool() -> BottomToolbarViewModel.Tool {
        return switch self {
        case .pencil: .pencil
        case .brush: .brush
        case .erase: .erase
        case .shape(_): .shapes
        }
    }
}

fileprivate extension BottomToolbarViewModel.Tool {
    func toDrawingMode() -> DrawingMode? {
        return switch self {
        case .pencil: .pencil
        case .brush: .brush
        case .erase: .erase
        default:
            nil
        }
    }
}
