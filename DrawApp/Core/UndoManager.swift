//
//  UndoManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

protocol UndoManager {
    var canUndo: Bool { get }
    var canUndoPublished: Published<Bool> { get }
    var canUndoPublisher: Published<Bool>.Publisher { get }
    
    var canRedo: Bool { get }
    var canRedoPublished: Published<Bool> { get }
    var canRedoPublisher: Published<Bool>.Publisher { get }
    
    func undo()
    func redo()
}

public final class UndoManagerImpl: UndoManager {
    @Published var canUndo: Bool = true
    var canUndoPublished: Published<Bool> { _canUndo }
    var canUndoPublisher: Published<Bool>.Publisher { $canUndo }
    
    @Published var canRedo: Bool = true
    var canRedoPublished: Published<Bool> { _canRedo }
    var canRedoPublisher: Published<Bool>.Publisher { $canRedo }
    
    func undo() {
        // TODO: Implement
    }
    func redo() {
        // TODO: Implement
    }
}
