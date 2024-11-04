//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class ControlsContentViewModel: ObservableObject {
    @Published var isShapesMenuShown = false
    @Published var isColorsMenuShown = false
    @Published var isPalleteMenuShown = false
    
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
            
            toolbarsStack
        }
    }
    
    var toolbarsStack: some View {
        VStack(spacing: 8) {
            Spacer()
            
//            
//            // TODO: Extract toolbar into a separate class
//            if (viewModel.isPalleteMenuShown) {
//                HStack {
//                    ToolbarButton(image: AppImage.square, action: .square, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.circle, action: .circle, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.triangle, action: .triangle, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.arrowUp, action: .arrow, actionReceiver: viewModel)
//                }
//            }
//            
//            if (viewModel.isColorsMenuShown) {
//                HStack {
//                    ToolbarButton(image: AppImage.palette, action: .palette, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.circle, action: .circle, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.circle, action: .triangle, actionReceiver: viewModel)
//                    ToolbarButton(image: AppImage.circle, action: .arrow, actionReceiver: viewModel)
//                }
//            }
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
                NewToolbarButton(buttonItem: item)
                
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
                NewToolbarButton(buttonItem: item)
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
