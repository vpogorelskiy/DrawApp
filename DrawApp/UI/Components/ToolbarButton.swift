//
//  ToolbarButton.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

protocol ActionSendable {
    func getPublisher(for action: ControlsContentViewModel.Action) -> AnyPublisher<Bool, Never>
//    func isSelected(forAction: ControlsContentViewModel.Action) -> Bool
    func sendAction(_ action: ControlsContentViewModel.Action)
}

struct ToolbarButton: View {
    private var actionReceiver: ActionSendable
    @Environment(\.defaultColor) private var defaultColor: UIColor
    @Environment(\.selectedColor) private var selectedColor: UIColor
    
    @State var isHighlighted: Bool = false
    
    private let selectedPublisher: AnyPublisher<Bool, Never>
    private let action: ControlsContentViewModel.Action
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
    
    init(image: UIImage, action: ControlsContentViewModel.Action, actionReceiver: ActionSendable) {
        self.action = action
        self.image = image
        self.actionReceiver = actionReceiver
        self.selectedPublisher = actionReceiver.getPublisher(for: action)
//        self.isSelected = isSelected
    }
}

//#Preview {
//    ToolbarButton()
//}

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

// MARK: - actionReceiver

//struct ToolbarButtonActionReceiverEnvironmentKey: EnvironmentKey {
//    static let defaultValue: ActionSendable = 
//}
//
//extension EnvironmentValues {
//    var actionReceiver: ActionSendable? {
//        get { self[ToolbarButtonActionReceiverEnvironmentKey.self] }
//        set { self[ToolbarButtonActionReceiverEnvironmentKey.self] = newValue }
//    }
//}
