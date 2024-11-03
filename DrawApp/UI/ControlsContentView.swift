//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class ControlsContentViewModel: ObservableObject, ActionSendable {
    @Published var isUndoAvailable: Bool = false
    @Published var isRedoAvailable: Bool = false
    
    @Published var isStopAvailable: Bool = false
    @Published var isPlayAvailable: Bool = false
    
    private let undoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let redoAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    
    private let stopAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    private let playAvailableSubject = CurrentValueSubject<Bool, Never>(false)
    
    
    enum Action {
        case undo, redo, delete, newFile, layers, play, stop
        case pencil, brush, erase, shapes, colors
    }
    
    func isSelected(forAction action: ControlsContentViewModel.Action) -> Bool {
        return switch action {
        case .undo:
            isUndoAvailable
        case .redo:
            isRedoAvailable
        case .stop:
            isStopAvailable
        case .play:
            isPlayAvailable
        default:
            false
        }
    }
    
    func getPublisher(for action: ControlsContentViewModel.Action) -> CurrentValueSubject<Bool, Never> {
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

        return subject//.eraseToAnyPublisher()
    }
    
    func sendAction(_ action: Action) {
        switch action {
        case .undo:
            isUndoAvailable.toggle()
        case .redo:
            isRedoAvailable.toggle()
        case .stop:
            isStopAvailable.toggle()
        case .play:
            isPlayAvailable.toggle()
        default:
            break
        }
    }
}

struct ControlsContentView: View {
    
    @ObservedObject var viewModel: ControlsContentViewModel
    
    init(viewModel: ControlsContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            topButtonsBar
            drawView
            bottomButtonsBar
        }
        .background(Color(uiColor: AppColor.black))
    }
    
    // TODO: Inject content view
    var drawView: some View  {
        Image(uiImage: AppImage.backgroundTexture)
            .padding(16)
    }
    
    var topButtonsBar: some View {
        HStack {
            ToolbarButton(image: AppImage.arrowLeft, action: .undo)
            ToolbarButton(image: AppImage.arrowRight, action: .redo)
            
            Spacer()
            
            ToolbarButton(image: AppImage.bin, action: .delete)
            ToolbarButton(image: AppImage.filePlus, action: .newFile)
            ToolbarButton(image: AppImage.Layers, action: .layers)
            
            Spacer()
            
            ToolbarButton(image: AppImage.stop, action: .stop)
            ToolbarButton(image: AppImage.play, action: .play)
        }
        .environment(\.defaultColor, AppColor.grey)
        .environment(\.selectedColor, AppColor.white)
        .environment(\.actionReceiver, viewModel)
        .padding(16)
    }
    
    var bottomButtonsBar: some View {
        HStack {
            ToolbarButton(image: AppImage.pencil, action: .pencil)
            ToolbarButton(image: AppImage.brush, action: .brush)
            
            ToolbarButton(image: AppImage.erase, action: .erase)
            ToolbarButton(image: AppImage.shapes, action: .shapes)
            ToolbarButton(image: AppImage.circle, action: .colors)
        }
        .environment(\.defaultColor, AppColor.white)
        .environment(\.selectedColor, AppColor.green)
        .environment(\.actionReceiver, viewModel)
        .padding(16)
    }
}

#Preview {
    ControlsContentView(viewModel: .init())
}
