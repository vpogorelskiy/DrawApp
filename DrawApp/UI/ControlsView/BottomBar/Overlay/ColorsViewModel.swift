//
//  ColorsViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

final class ColorsViewModel: ObservableObject {
    enum Action: Equatable {
        case palette
        case color(UIColor)
    }
    
    @Injected var toolManager: DrawingToolManager!
    @Published var isPaletteMenuShown = false
    
    private var colors: [UIColor] = [
        AppColor.white,
        AppColor.red,
        AppColor.black,
        AppColor.blue
    ]
    
    lazy var buttonItems: [ToolbarButtonItem<Action>] = {
        [
            .init(image: AppImage.palette,
                  isSelected: isPaletteMenuShown,
                  value: .palette,
                  onTap: { [weak self] in self?.selectPalette() }),
            
        ] + colors.map { color in
            ToolbarButtonItem(imageType: .circle(color),
                              isSelected: toolManager.selectedColor == color,
                              value: .color(color),
                              onTap: { [weak self] in self?.selectColor(color) })
        }
    }()
    
    private func selectPalette() {
        isPaletteMenuShown.toggle()
        
        buttonItems.forEach{
            $0.isSelected = $0.value == .palette
        }
    }
    
    private func selectColor(_ color: UIColor) {
        toolManager.selectColor(color)
        
        buttonItems.forEach{
            $0.isSelected = $0.value == .color(color)
        }
        // TODO: Implement
    }
}
