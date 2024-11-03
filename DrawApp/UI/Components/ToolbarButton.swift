//
//  ToolbarButton.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI

protocol ActionSendable {
    func sendAction(_ action: ControlsContentViewModel.Action)
}

struct ToolbarButton: View {
    @Environment(\.actionReceiver) private var actionReceiver: ActionSendable?
    @Environment(\.defaultColor) private var defaultColor: UIColor
    @Environment(\.selectedColor) private var selectedColor: UIColor
    
    let isSelected: Bool
    let action: ControlsContentViewModel.Action
    let image: UIImage
    
    var body: some View {
        Button(action: {
            actionReceiver?.sendAction(action)
        }, label: {
            Image(uiImage: image.withRenderingMode(.alwaysTemplate))
                .tint(.init(uiColor: isSelected ? selectedColor : defaultColor))
        })
    }
    
    init(image: UIImage, action: ControlsContentViewModel.Action, isSelected: Bool) {
        self.action = action
        self.image = image
        self.isSelected = isSelected
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

struct ToolbarButtonActionReceiverEnvironmentKey: EnvironmentKey {
    static let defaultValue: ActionSendable? = nil
}

extension EnvironmentValues {
    var actionReceiver: ActionSendable? {
        get { self[ToolbarButtonActionReceiverEnvironmentKey.self] }
        set { self[ToolbarButtonActionReceiverEnvironmentKey.self] = newValue }
    }
}
