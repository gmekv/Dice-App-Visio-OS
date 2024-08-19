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

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
