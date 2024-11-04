//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class ControlsContentViewModel: ObservableObject {
    public let topToolbarViewModel = TopToolbarViewModel()
    public let bottomToolbarViewModel = BottomToolbarViewModel()
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
            
            toolbarsOverlay
        }
    }
    
    var toolbarsOverlay: some View {
        VStack(spacing: 8) {
            Spacer()
            
            if (viewModel.bottomToolbarViewModel.isShapesMenuShown) {
                HStack {
                    ForEach(Array(viewModel.bottomToolbarViewModel.shapesViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                        ToolbarButton(buttonItem: item)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            if (viewModel.bottomToolbarViewModel.isColorsMenuShown) {
                HStack {
                    ForEach(Array(viewModel.bottomToolbarViewModel.simpleColorsViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                        ToolbarButton(buttonItem: item)
                            .frame(width: 32, height: 32)
                    }
                }
            }
            
            if (viewModel.bottomToolbarViewModel.simpleColorsViewModel.isPaletteMenuShown) {
                Grid(horizontalSpacing: 16,
                     verticalSpacing: 16) {
                    ForEach(Array(viewModel.bottomToolbarViewModel.paletteViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                        ToolbarButton(buttonItem: item)
                            .frame(width: 32, height: 32)
                    }
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
            ForEach(Array(viewModel.topToolbarViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                ToolbarButton(buttonItem: item)
                
                if viewModel.topToolbarViewModel.gapIndices.contains(index) {
                    Spacer()
                }
            }
        }
        .environment(\.defaultColor, AppColor.grey)
        .environment(\.selectedColor, AppColor.white)
        .padding(16)
    }
    
    var bottomButtonsBar: some View {
        HStack {
            ForEach(Array(viewModel.bottomToolbarViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                ToolbarButton(buttonItem: item)
            }
        }
        .environment(\.defaultColor, AppColor.white)
        .environment(\.selectedColor, AppColor.green)
        .padding(16)
    }
}

#Preview {
    ControlsContentView(viewModel: .init(), contentView: { Text("Empty").background(Color.white) })
}
