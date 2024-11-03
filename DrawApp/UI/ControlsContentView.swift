//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class ControlsContentViewModel: ObservableObject, ActionSendable {
    @Published var isShapesMenuShown = false
    @Published var isColorsMenuShown = false
    @Published var isPalleteMenuShown = false
    
    private let undoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let redoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let stopAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let playAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    
    enum Action {
        case undo, redo, delete, newFile, layers, play, stop
        case pencil, brush, erase, shapes, colors
        case square, circle, triangle, arrow
        case palette, color(UIColor)
    }
    
    func getPublisher(for action: ControlsContentViewModel.Action) -> AnyPublisher<Bool, Never> {
        getSubject(for: action).eraseToAnyPublisher()

    }
    
    private func getSubject(for action: ControlsContentViewModel.Action) -> CurrentValueSubject<Bool, Never> {
        let subject: CurrentValueSubject<Bool, Never> = switch action {
        case .undo:
            undoAvailableSubject
        case .redo:
            redoAvailableSubject
        case .stop:
            stopAvailableSubject
        case .play:
            playAvailableSubject
        default:
            CurrentValueSubject<Bool, Never>(false)
        }

        return subject
    }
    
    func sendAction(_ action: Action) {
        let subject = getSubject(for: action)
        subject.send(!subject.value)
    }
}

struct ControlsContentView<Content: View>: View {
    
    @ObservedObject var viewModel: ControlsContentViewModel
    
    @ViewBuilder var contentBuilder: () -> Content
    
    init(viewModel: ControlsContentViewModel, contentView: @escaping () -> Content) {
        self.viewModel = viewModel
        self.contentBuilder = contentView
    }
    
    var body: some View {
        ZStack {
            VStack {
                topButtonsBar
                drawView
                bottomButtonsBar
            }
            .background(Color(uiColor: AppColor.black))
        }
    }
    
    var toolbarsStack: some View {
        VStack(spacing: 8) {
            Spacer()
            
            if (viewModel.isPalleteMenuShown) {
                HStack {
                    ToolbarButton(image: AppImage.square, action: .square, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.circle, action: .circle, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.triangle, action: .triangle, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.arrowUp, action: .arrow, actionReceiver: viewModel)
                }
            }
            
            if (viewModel.isColorsMenuShown) {
                HStack {
                    ToolbarButton(image: AppImage.palette, action: .palette, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.circle, action: .circle, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.circle, action: .triangle, actionReceiver: viewModel)
                    ToolbarButton(image: AppImage.circle, action: .arrow, actionReceiver: viewModel)
                }
            }
        }
    }
    
    
    var drawView: some View  {
        contentBuilder()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            .cornerRadius(16)
            .padding(16)
    }
    
    var topButtonsBar: some View {
        HStack {
            ToolbarButton(image: AppImage.arrowLeft, action: .undo, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.arrowRight, action: .redo, actionReceiver: viewModel)
            
            Spacer()
            
            ToolbarButton(image: AppImage.bin, action: .delete, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.filePlus, action: .newFile, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.Layers, action: .layers, actionReceiver: viewModel)
            
            Spacer()
            
            ToolbarButton(image: AppImage.stop, action: .stop, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.play, action: .play, actionReceiver: viewModel)
        }
        .environment(\.defaultColor, AppColor.grey)
        .environment(\.selectedColor, AppColor.white)
        .padding(16)
    }
    
    var bottomButtonsBar: some View {
        HStack {
            ToolbarButton(image: AppImage.pencil, action: .pencil, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.brush, action: .brush, actionReceiver: viewModel)
            
            ToolbarButton(image: AppImage.erase, action: .erase, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.shapes, action: .shapes, actionReceiver: viewModel)
            ToolbarButton(image: AppImage.circle, action: .colors, actionReceiver: viewModel)
        }
        .environment(\.defaultColor, AppColor.white)
        .environment(\.selectedColor, AppColor.green)
        .padding(16)
    }
}

#Preview {
    ControlsContentView(viewModel: .init(), contentView: { Text("Empty").background(Color.white) })
}
