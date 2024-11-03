//
//  ControlsContentView.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI
import Combine

final class ControlsContentViewModel: ObservableObject {
    
    
}

struct ControlsContentView: View {
    var body: some View {
        topButtonsBar
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    var topButtonsBar: some View {
        HStack {
            Image(uiImage: AppImage.arrowLeft)
            Image(uiImage: AppImage.arrowRight)
            Spacer()
            Image(uiImage: AppImage.bin)
            Image(uiImage: AppImage.filePlus)
            Image(uiImage: AppImage.Layers)
            Spacer()
            Image(uiImage: AppImage.stop)
            Image(uiImage: AppImage.play)
        }
        .padding(16)
    }
}

#Preview {
    ControlsContentView()
}
