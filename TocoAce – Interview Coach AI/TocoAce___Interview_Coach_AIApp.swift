//
//  TocoAce___Interview_Coach_AIApp.swift
//  TocoAce – Interview Coach AI
//
//  Created by Rad on 06/11/2025.
//

import SwiftUI

@main
struct TocoAce_Interview_Coach_AIApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Configure window to be floating and always on top
        if let window = NSApplication.shared.windows.first {
            window.level = .floating
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.titlebarAppearsTransparent = true
            window.isMovableByWindowBackground = true
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
