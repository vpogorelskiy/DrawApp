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
    var drawingMode: DrawingMode { get }
    var selectedColor: UIColor { get }
    
    func selectColor(_: UIColor)
    func setDrawingMode(_: DrawingMode)
}
