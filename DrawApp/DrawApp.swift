//
//  DrawApp.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 03.11.2024.
//

import SwiftUI

@main
struct DrawApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    init() {
        Resolver.sharedInstance.register(UndoManager.self) { r in
            UndoManagerImpl()
        }
        
        Resolver.sharedInstance.register(PlaybackManager.self) { r in
            PlaybackManagerImpl()
        }
        
        Resolver.sharedInstance.register(LayerManager.self) { r in
            LayerManagerImpl()
        }
    }
}
