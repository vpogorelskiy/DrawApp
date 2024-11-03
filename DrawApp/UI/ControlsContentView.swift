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
    
    enum Action {
        case undo, redo, delete, newFile, layers, play, stop
        case pencil, brush, erase, shapes, colors
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
            ToolbarButton(image: AppImage.arrowLeft, action: .undo, isSelected: viewModel.isUndoAvailable)
            ToolbarButton(image: AppImage.arrowRight, action: .redo, isSelected: viewModel.isRedoAvailable)
            
            Spacer()
            
            ToolbarButton(image: AppImage.bin, action: .delete, isSelected: true)
            ToolbarButton(image: AppImage.filePlus, action: .newFile, isSelected: true)
            ToolbarButton(image: AppImage.Layers, action: .layers, isSelected: true)
            
            Spacer()
            
            ToolbarButton(image: AppImage.stop, action: .stop, isSelected: viewModel.isStopAvailable)
            ToolbarButton(image: AppImage.play, action: .play, isSelected: viewModel.isPlayAvailable)
        }
        .environment(\.defaultColor, AppColor.grey)
        .environment(\.selectedColor, AppColor.white)
        .environment(\.actionReceiver, viewModel)
        .padding(16)
    }
    
    var bottomButtonsBar: some View {
        HStack {
            ToolbarButton(image: AppImage.pencil, action: .pencil, isSelected: false)
            ToolbarButton(image: AppImage.brush, action: .brush, isSelected: false)
            
            ToolbarButton(image: AppImage.erase, action: .erase, isSelected: false)
            ToolbarButton(image: AppImage.shapes, action: .shapes, isSelected: false)
            ToolbarButton(image: AppImage.circle, action: .colors, isSelected: false)
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
