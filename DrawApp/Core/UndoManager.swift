//
//  UndoManager.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

protocol UndoManager {
    var canUndo: Bool { get }
    var canRedo: Bool { get }
    
    func undo()
    func redo()
}

public final class UndoManagerImpl: UndoManager {
    @Published var canUndo: Bool = true
    @Published var canRedo: Bool = true
    
    func undo() {
        canUndo.toggle()
    }
    func redo() {
        canRedo.toggle()
    }
}
