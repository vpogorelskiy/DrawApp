//
//  TopBarViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class TopBarViewModel: ObservableObject, ActionSendable {
    private let undoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let redoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let stopAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let playAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    
    enum Action {
        case undo, redo, delete, newFile, layers, play, stop
    }
    
    func getPublisher(for action: Action) -> AnyPublisher<Bool, Never> {
        getSubject(for: action).eraseToAnyPublisher()

    }
    
    private func getSubject(for action: Action) -> CurrentValueSubject<Bool, Never> {
        let subject: CurrentValueSubject<Bool, Never> = switch action {
        case .undo:
            undoAvailableSubject
        case .redo:
            redoAvailableSubject
        case .stop:
            stopAvailableSubject
        case .play:
            playAvailableSubject
        case .delete, .newFile, .layers:
            CurrentValueSubject<Bool, Never>(true)
        }

        return subject
    }
    
    func sendAction(_ action: Action) {
        let subject = getSubject(for: action)
        subject.send(!subject.value)
    }
}


