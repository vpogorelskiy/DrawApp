//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

//final class ControlsContentViewModel: ObservableObject {
//    @ObservedObject var topToolbarViewModel = TopToolbarViewModel()
//    @Published var bottomToolbarViewModel = BottomToolbarViewModel()
//}

struct ControlsContentView<Content: View>: View {
    
    @ObservedObject private var topToolbarViewModel = TopToolbarViewModel()
    @ObservedObject private var bottomToolbarViewModel = BottomToolbarViewModel()
    @ObservedObject private var simpleColorsViewModel = ColorsViewModel()
    @ObservedObject private var paletteViewModel = PaletteViewModel()
    @ObservedObject private var shapesViewModel = ShapesViewModel()
    
    @ViewBuilder var contentBuilder: () -> Content
    
    init(topviewModel: TopToolbarViewModel,
         bottomViewModel: BottomToolbarViewModel,
         shapesViewModel: ShapesViewModel,
         simpleColorsViewModel: ColorsViewModel,
         paletteViewModel: PaletteViewModel,
         contentView: @escaping () -> Content) {
        self.topToolbarViewModel = topviewModel
        self.bottomToolbarViewModel = bottomViewModel
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
        ZStack {
            VStack(spacing: 8) {
                Spacer()
                
                // Palette grid
                if (simpleColorsViewModel.isPaletteMenuShown && bottomToolbarViewModel.isColorsMenuShown) {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5),
                              alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/,
                              spacing: 16) {
                        ForEach(Array(paletteViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                            ToolbarButton(buttonItem: item)
                                .frame(width: 32, height: 32)
                        }
                    }.padding(16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)

                }
                
                // Small colors toolbar
                if (bottomToolbarViewModel.isColorsMenuShown) {
                    HStack {
                        ForEach(Array(simpleColorsViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                            ToolbarButton(buttonItem: item)
                                .frame(width: 32, height: 32)
                        }
                    }.padding(16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                }
                
                // Shapes selection toolbar
                if (bottomToolbarViewModel.isShapesMenuShown) {
                    HStack {
                        ForEach(Array(shapesViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                            ToolbarButton(buttonItem: item)
                                .frame(width: 32, height: 32)
                        }
                    }.padding(16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(4)
                }
            }
            .environment(\.defaultColor, AppColor.white)
            .environment(\.selectedColor, AppColor.green)
            .padding(60)
        }.onTapGesture {
            bottomToolbarViewModel.dismissOverlay()
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
            ForEach(Array(topToolbarViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                ToolbarButton(buttonItem: item)
                
                if topToolbarViewModel.gapIndices.contains(index) {
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
            ForEach(Array(bottomToolbarViewModel.buttonItems.enumerated()), id: \.offset) { index, item in
                ToolbarButton(buttonItem: item)
            }
        }
        .environment(\.defaultColor, AppColor.white)
        .environment(\.selectedColor, AppColor.green)
        .padding(16)
    }
}

#Preview {
    ControlsContentView(topviewModel: .init(),
                        bottomViewModel: .init(),
                        shapesViewModel: .init(),
                        simpleColorsViewModel: .init(),
                        paletteViewModel: .init(),
                        contentView: { Text("Empty").background(Color.white) })
}
