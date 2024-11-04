//
//  DrawingTooManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import UIKit

enum DrawingMode {
    enum Shape {
        case square, circle, triangle, arrow
    }
    
    case pencil, brush, erase
    case shape(Shape)
}

protocol DrawingToolManager {
    var drawingMode: DrawingMode? { get }
    var selectedColor: UIColor { get }
    
    func selectColor(_: UIColor)
    func setDrawingMode(_: DrawingMode)
}

final class DrawingToolManagerImpl: DrawingToolManager {
    var drawingMode: DrawingMode?
    var selectedColor: UIColor = AppColor.white
    
    func selectColor(_ color: UIColor) {
        selectedColor = color
    }
    
    func setDrawingMode(_ drawingMode: DrawingMode) {
        self.drawingMode = drawingMode
    }
}
