//
//  LayerManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import SwiftUI
import UIKit

protocol LayerManager {
    func deleteLayer()
    func addLayer()
    func getLayersImages() -> [UIImage] // TODO: Consider mobing to background thread
    
    var currentImage: UIImage? { get }
    var currentImagePublished: Published<UIImage?> { get }
    var currentImagePublisher: Published<UIImage?>.Publisher { get }
    
    var backgroundImage: UIImage? { get }
    var backgroundImagePublished: Published<UIImage?> { get }
    var backgroundImagePublisher: Published<UIImage?>.Publisher { get }
    
    func setImageSize(_: CGSize)
    func draw(_ gesture: DragGesture.Value)
    func stopDrawing(_ gesture: DragGesture.Value)
}

enum ShapeType{
    struct PathData {
        var points: [CGPoint]
        var width: CGFloat
        var color: UIColor
        var blendMode: CGBlendMode
    }
    
    struct ImageData {
        var image: UIImage
        var color: UIColor
        var frame: CGRect
    }
    
    case image(ImageData)
    case path(PathData)
}

final class LayerInfo {
    var shapes: [ShapeType] = []
}

final class CurrentDrawnShape {
    let tool: DrawingMode
    var points: [DragGesture.Value]
    
    init(tool: DrawingMode, points: [DragGesture.Value]) {
        self.tool = tool
        self.points = points
    }
}

final class LayerManagerImpl: LayerManager {
    
    @Published var currentImage: UIImage?
    var currentImagePublished: Published<UIImage?> { _currentImage }
    var currentImagePublisher: Published<UIImage?>.Publisher { $currentImage }
    
    @Published var backgroundImage: UIImage?
    var backgroundImagePublished: Published<UIImage?> { _backgroundImage }
    var backgroundImagePublisher: Published<UIImage?>.Publisher { $backgroundImage }
    
    private var layers: [LayerInfo] = [.init()]
    
    private var imageSize: CGSize = .zero
    
    @Injected private var drawingToolManager: DrawingToolManager!
    @Injected private var undoManager: UndoManager!
    
    private var currentShape: CurrentDrawnShape?
    
    func deleteLayer() {
        if !layers.isEmpty {
            layers.removeLast()
        }
        if layers.isEmpty {
            layers = [.init()]
        }
        reRenderAllViews()
    }
    
    func addLayer() { 
        layers.append(.init())
        
        reRenderAllViews()
    }
    
    func getLayersImages() -> [UIImage] {
        layers.compactMap {
            renderShapes($0.shapes)
        }
    }
    
    func setImageSize(_ size: CGSize) {
        imageSize = size
        reRenderAllViews()
    }
    
    func draw(_ gesture: DragGesture.Value) {
        if let currentShape = currentShape {
            currentShape.points.append(gesture)
            renderForeground()
        } else if let currentTool = drawingToolManager.drawingMode {
            currentShape = .init(tool: currentTool, points: [gesture])
            renderForeground()
        }
    }
    
    func stopDrawing(_ gesture: DragGesture.Value) {
        guard let currentShape = currentShape else { return }
        currentShape.points.append(gesture)
        let shapeType = currentDrawnToLayerShape(currentShape)
        layers.last?.shapes.append(shapeType)
        self.currentShape = nil
        renderForeground()
    }
    
    private func reRenderAllViews() {
        renderBackground()
        renderForeground()
    }
    
    private func renderBackground() {
        let shapes = layers.flatMap{ $0.shapes }
        backgroundImage = renderShapes(shapes)
    }
    
    private func renderForeground() {
        guard var shapes = layers.last?.shapes else { return }
        
        if let currentShape = currentShape {
            shapes.append(currentDrawnToLayerShape(currentShape))
        }
        
        currentImage = renderShapes(shapes)
    }
    
    private func currentDrawnToLayerShape(_ currentShape: CurrentDrawnShape) -> ShapeType {
        var color: UIColor = drawingToolManager.selectedColor
        var blendMode: CGBlendMode = .normal
        switch currentShape.tool {
        case .erase:
            color = .black
            blendMode = .clear
            fallthrough
        case .pencil, .brush:
            var points: [CGPoint] = []
            if let origin = currentShape.points.first?.startLocation {
                points.append(origin)
            }
            currentShape.points.forEach{ points.append($0.location) }
            
            return .path(.init(points: points,
                               width: drawingToolManager.strokeWidth,
                               color: color,
                               blendMode: blendMode))
        case .shape(let shape):
            let image = shape.image
            var rect: CGRect = .zero
            
            if let origin = currentShape.points.first?.startLocation,
               let lastPoint = currentShape.points.last?.location {
                let minX = min(origin.x, lastPoint.x)
                let maxX = max(origin.x, lastPoint.x)
                let minY = min(origin.y, lastPoint.y)
                let maxY = max(origin.y, lastPoint.y)
                
                rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
            }
            
            
            return .image(.init(image: image, color: color, frame: rect))
        }
    }
    
    private func renderShapes(_ shapes: [ShapeType]) -> UIImage? {
        UIGraphicsBeginImageContext(imageSize)
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        
        for shape in shapes {
            switch shape {
            case .image(let imageData):
                let image = imageData.image.withTintColor(imageData.color,
                                                          renderingMode: .alwaysTemplate)
                image.draw(in: imageData.frame)
            case .path(let pathData):
                context.setLineWidth(pathData.width)
                context.setStrokeColor(pathData.color.cgColor)
                context.setBlendMode(pathData.blendMode)
                
                if let firstPoint = pathData.points.first {
                    context.move(to: firstPoint)
                }
                
                pathData.points.forEach { point in
                    context.addLine(to: point)
                    context.move(to: point)
                }
                
                context.strokePath()
            }
        }
        
        guard let resultImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return resultImage
    }
}
