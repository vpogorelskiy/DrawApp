//
//  TopBarViewModel.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import Combine
import UIKit

final class ColorsViewModel: ActionSendable {
    
    private let paletteSybject = CurrentValueSubject<Bool, Never>(false)
    private let colorSubject = CurrentValueSubject<Bool, Never>(false)
    
    enum Action {
        case palette, color(UIColor)
    }
    
    func getPublisher(for action: Action) -> AnyPublisher<Bool, Never> {
        getSubject(for: action).eraseToAnyPublisher()
    }
    
    private func getSubject(for action: Action) -> CurrentValueSubject<Bool, Never> {
        let subject: CurrentValueSubject<Bool, Never> = switch action {
        case .palette:
            paletteSybject
        case .color:
            colorSubject
        }

        return subject
    }
    
    func sendAction(_ action: Action) {
        
    }
}

final class BottomBarViewModel: ActionSendable {
    
    enum Action {
        case pencil, brush, erase, shapes, colors
    }
    
    @Published var selectedColor: UIColor = AppColor.blue
    
    private let pencilSybject = CurrentValueSubject<Bool, Never>(false)
    private let brushSubject = CurrentValueSubject<Bool, Never>(false)
    private let eraseSubject = CurrentValueSubject<Bool, Never>(false)
    private let shapesSubject = CurrentValueSubject<Bool, Never>(false)
    private let colorsSubject = CurrentValueSubject<Bool, Never>(false)
    
    func getPublisher(for action: Action) -> AnyPublisher<Bool, Never> {
        getSubject(for: action).eraseToAnyPublisher()
    }
    
    private func getSubject(for action: Action) -> CurrentValueSubject<Bool, Never> {
        let subject: CurrentValueSubject<Bool, Never> = switch action {
        case .pencil:
            pencilSybject
        case .brush:
            brushSubject
        case .erase:
            eraseSubject
        case .shapes:
            shapesSubject
        case .colors:
            colorsSubject
        }

        return subject
    }
    
    func sendAction(_ action: Action) {
        let subject = getSubject(for: action)
        subject.send(!subject.value)
    }
}
