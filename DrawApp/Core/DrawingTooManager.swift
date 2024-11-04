//
//  DrawingTooManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

enum DrawingMode: Equatable {
    enum Shape: Equatable {
        case square, circle, triangle, arrow
    }
    
    case pencil, brush, erase
    case shape(Shape)
    
    var isShape: Bool {
        switch self {
        case .shape(_):
            return true
        default:
            return false
        }
    }
}

protocol DrawingToolManager {
    var drawingMode: DrawingMode? { get }
    var drawingModePublished: Published<DrawingMode?> { get }
    var drawingModePublisher: Published<DrawingMode?>.Publisher { get }
    
    var selectedColor: UIColor { get }
    var selectedColorPublished: Published<UIColor> { get }
    var selectedColorPublisher: Published<UIColor>.Publisher { get }
    
    func selectColor(_: UIColor)
    func setDrawingMode(_: DrawingMode?)
}

final class DrawingToolManagerImpl: DrawingToolManager {
    @Published var drawingMode: DrawingMode?
    var drawingModePublished: Published<DrawingMode?> { _drawingMode }
    var drawingModePublisher: Published<DrawingMode?>.Publisher { $drawingMode }
    
    @Published var selectedColor: UIColor = AppColor.white
    var selectedColorPublished: Published<UIColor> { _selectedColor }
    var selectedColorPublisher: Published<UIColor>.Publisher { $selectedColor }
    
    func selectColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func setDrawingMode(_ newMode: DrawingMode?) {
        drawingMode = newMode != drawingMode ? newMode : nil
    }
}
