//
//  ToolbarView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import SwiftUI
import Combine


final class BaseColorsViewModel: ObservableObject, ActionSendable {
    
    enum Action {
        case palette, color(UIColor)
    }
    
    @Published var selectedColor: UIColor = AppColor.blue
    
    public var baseColors: [UIColor] = [AppColor.white,
                                        AppColor.red,
                                        AppColor.black, 
                                        AppColor.blue]
    
    private let paletteSybject = CurrentValueSubject<Bool, Never>(false)
    private let colorSubject = CurrentValueSubject<Bool, Never>(false)
    
    func getPublisher(for action: Action) -> AnyPublisher<Bool, Never> {
        getSubject(for: action).eraseToAnyPublisher()
    }
    
    private func getSubject(for action: Action) -> CurrentValueSubject<Bool, Never> {
        let subject: CurrentValueSubject<Bool, Never> = switch action {
        case .palette:
            paletteSybject
        case .color(let color):
            CurrentValueSubject(color == selectedColor)
        }

        return subject
    }
    
    func sendAction(_ action: Action) {
        
    }
}

struct BaseColorsView: View {
    
    @ObservedObject var viewModel: BaseColorsViewModel
    
    var body: some View {
        HStack {
            
            ToolbarButton(image: AppImage.palette, action: .palette, actionReceiver: viewModel)
            
            ForEach(viewModel.baseColors, id: \.self) { color in
                ToolbarButton(image: AppImage.circleFilled(withColor: color),
                              action: .color(color),
                              actionReceiver: viewModel)
            }
        }
        .environment(\.defaultColor, .clear)
        .environment(\.selectedColor, AppColor.green)
    }       
}

#Preview {
    BaseColorsView(viewModel: .init())
}
