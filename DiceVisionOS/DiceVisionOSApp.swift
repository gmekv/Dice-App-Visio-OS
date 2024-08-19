//
//  DiceVisionOSApp.swift
//  DiceVisionOS
//
//  Created by Giorgi Mekvabishvili on 19.08.24.
//

import SwiftUI

@main
struct DiceVisionOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        .defaultSize(width: 100, height: 100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
