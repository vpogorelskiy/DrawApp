//
//  ColorsViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

final class PaletteViewModel: ObservableObject {
    @Injected var toolManager: DrawingToolManager!
    
    private var colors: [UIColor] = [
        AppColor.white,
        AppColor.red,
        AppColor.black,
        AppColor.blue
    ]
    
    lazy var buttonItems: [ToolbarButtonItem] = colors.map { color in
        ToolbarButtonItem(image: AppImage.circleFilled(withColor: color),
                          isSelected: toolManager.selectedColor == color,
                          onTap: { [weak self] in self?.selectColor(color) })
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        // TODO: Implement
    }
}

final class ColorsViewModel: ObservableObject {
    @Published var isPaletteShown: Bool = false
    
    @Injected var toolManager: DrawingToolManager!
    @Published var isPaletteMenuShown = false
    
    private var colors: [UIColor] = [
        AppColor.white,
        AppColor.red,
        AppColor.black,
        AppColor.blue
    ]
    
    lazy var buttonItems: [ToolbarButtonItem] = {
        [
            .init(image: AppImage.palette,
                  isSelected: isPaletteShown,
                  onTap: { [weak self] in self?.selectPalette() }),
            
        ] + colors.map { color in
            ToolbarButtonItem(image: AppImage.circleFilled(withColor: color),
                              isSelected: toolManager.selectedColor == color,
                              onTap: { [weak self] in self?.selectColor(color) })
        }
    }()
    
    private func selectPalette() {
        // TODO: Implement
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        // TODO: Implement
    }
}

final class ShapesViewModel: ObservableObject {
    
    enum Shape: Equatable {
        case square, circle, triangle, arrow
    }
    
    @Injected var toolManager: DrawingToolManager!
    @Published private var selectedShape: Shape? = nil
    
    lazy var buttonItems: [ToolbarButtonItem] = {
        [
            .init(image: AppImage.square,
                  isSelected: selectedShape == .square,
                  onTap: { [weak self] in self?.selectShape(.square) }),
            .init(image: AppImage.circle,
                  isSelected: selectedShape == .circle,
                  onTap: { [weak self] in self?.selectShape(.circle) }),
            .init(image: AppImage.erase,
                  isSelected: selectedShape == .triangle,
                  onTap: { [weak self] in self?.selectShape(.triangle) }),
            .init(image: AppImage.shapes,
                  isSelected: selectedShape == .arrow,
                  onTap: { [weak self] in self?.selectShape(.arrow) }),
        ]
    }()
    
    func deselect() {
        selectShape(nil)
    }
    
    private func selectShape(_ shape: Shape?) {
        selectedShape = shape
    }
}
