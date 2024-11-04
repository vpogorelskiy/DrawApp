//
//  ToolbarView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine

struct ToolbarButton<Value: Equatable>: View {
    @ObservedObject var buttonItem: ToolbarButtonItem<Value>
    @Environment(\.defaultColor) private var defaultColor: UIColor
    @Environment(\.selectedColor) private var selectedColor: UIColor
    
    private var imageColor: UIColor {
        buttonItem.isSelected ? selectedColor : defaultColor
    }
    
    var body: some View {
        Button(action: { buttonItem.onTap() },
               label: {
            switch buttonItem.imageStore {
            case .single(let image):
                Image(uiImage: image.withRenderingMode(.alwaysTemplate))
                    .tint(.init(uiColor: imageColor))
            case .double(let bottom, let top):
                ZStack {
                    Image(uiImage: bottom)
                    Image(uiImage: top.withRenderingMode(.alwaysTemplate))
                        .tint(.init(uiColor: imageColor))
                }
            }
        })
    }
    
    init(buttonItem: ToolbarButtonItem<Value>) {
        self.buttonItem = buttonItem
    }
}

final class ToolbarButtonItem<Value: Equatable>: ObservableObject {
    
    enum ImageType {
        case single(UIImage)
        case double(bottom: UIImage, top: UIImage)
    }
    
    let imageStore: ImageType
    @Published var isSelected: Bool
    let onTap: () -> Void
    let value: Value
    
    convenience init(image: UIImage, isSelected: Bool, value: Value, onTap: @escaping () -> Void) {
        self.init(imageType: .single(image),
                  isSelected: isSelected,
                  value: value,
                  onTap: onTap)
    }
    
    init(imageType: ImageType, isSelected: Bool, value: Value, onTap: @escaping () -> Void) {
        self.imageStore = imageType
        self.isSelected = isSelected
        self.onTap = onTap
        self.value = value
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
