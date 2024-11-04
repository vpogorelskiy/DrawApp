//
//  UndoManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation
import Combine

enum UndoRedoAction {
    case draw(ShapeType)
    case deleteLayer
    case createLayer
}

protocol UndoManager {
    var canUndo: Bool { get }
    var canUndoPublished: Published<Bool> { get }
    var canUndoPublisher: Published<Bool>.Publisher { get }
    
    var canRedo: Bool { get }
    var canRedoPublished: Published<Bool> { get }
    var canRedoPublisher: Published<Bool>.Publisher { get }
    
    var undoPublisher: AnyPublisher<UndoRedoAction, Never> { get }
    var redoPublisher: AnyPublisher<UndoRedoAction, Never> { get }
    
    func undo()
    func redo()
    func addAction(_ : UndoRedoAction)
}

public final class UndoManagerImpl: UndoManager {
    @Published var canUndo: Bool = true
    var canUndoPublished: Published<Bool> { _canUndo }
    var canUndoPublisher: Published<Bool>.Publisher { $canUndo }
    
    @Published var canRedo: Bool = true
    var canRedoPublished: Published<Bool> { _canRedo }
    var canRedoPublisher: Published<Bool>.Publisher { $canRedo }
    
    var undoPublisher: AnyPublisher<UndoRedoAction, Never> { undoSubject.eraseToAnyPublisher() }
    var redoPublisher: AnyPublisher<UndoRedoAction, Never> { redoSubject.eraseToAnyPublisher() }
    
    private var undoSubject = PassthroughSubject<UndoRedoAction, Never>()
    private var redoSubject = PassthroughSubject<UndoRedoAction, Never>()
    
    private var actions: [UndoRedoAction] = []
    private var actionIndex: Int = 0
    
    func undo() {
        if !actions.isEmpty && actionIndex >= 0 && actionIndex < actions.count {
            let action = actions[actionIndex]
            undoSubject.send(action)
            actionIndex -= 1
        }
    }
    
    func redo() {
        if !actions.isEmpty && actionIndex < actions.count - 1 {
            actionIndex += 1
            let action = actions[actionIndex]
            redoSubject.send(action)
        }
    }
    
    func addAction(_ newAction: UndoRedoAction) {
        if actionIndex < actions.endIndex {
            actions.removeLast(actions.endIndex - actionIndex)
        }
        
        actions.append(newAction)
        actionIndex = actions.endIndex
    }
}
