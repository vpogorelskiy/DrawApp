//
//  ToolbarButton.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

protocol ActionSendable {
    associatedtype Action
    func getPublisher(for action: Action) -> AnyPublisher<Bool, Never>
    func sendAction(_ action: Action)
}

struct ToolbarButton<ActionReceiver: ActionSendable>: View {
    private var actionReceiver: ActionReceiver
    @Environment(\.defaultColor) private var defaultColor: UIColor
    @Environment(\.selectedColor) private var selectedColor: UIColor
    
    @State private var isHighlighted: Bool = false
    
    private let selectedPublisher: AnyPublisher<Bool, Never>
    private let action: ActionReceiver.Action
    private let image: UIImage
    private var imageColor: UIColor {
        isHighlighted ? selectedColor : defaultColor
    }
    private var cancellables: [AnyCancellable] = []
    
    var body: some View {
        Button(action: {
            actionReceiver.sendAction(action)
        }, label: {
            Image(uiImage: image.withRenderingMode(.alwaysTemplate))
                .tint(.init(uiColor: imageColor))
        })
        .onReceive(selectedPublisher, perform: { isHighlighted = $0 })
        
    }
    
    init(image: UIImage, action: ActionReceiver.Action, actionReceiver: ActionReceiver) {
        self.action = action
        self.image = image
        self.actionReceiver = actionReceiver
        self.selectedPublisher = actionReceiver.getPublisher(for: action)
    }
}

// MARK: - selectedColor

struct ToolbarButtonSelectedColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIColor = .white
}

// ## Introduce new value to EnvironmentValues
extension EnvironmentValues {
    var selectedColor: UIColor {
        get { self[ToolbarButtonSelectedColorEnvironmentKey.self] }
        set { self[ToolbarButtonSelectedColorEnvironmentKey.self] = newValue }
    }
}

// MARK: - defaultColor

struct ToolbarButtonDefaultColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: UIColor = .white
}

// ## Introduce new value to EnvironmentValues
extension EnvironmentValues {
    var defaultColor: UIColor {
        get { self[ToolbarButtonDefaultColorEnvironmentKey.self] }
        set { self[ToolbarButtonDefaultColorEnvironmentKey.self] = newValue }
    }
}
