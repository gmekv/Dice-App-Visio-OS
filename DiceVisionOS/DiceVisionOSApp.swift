//
//  DiceVisionOSApp.swift
//  DiceVisionOS
//
//  Created by Giorgi Mekvabishvili on 19.08.24.
//

import SwiftUI

@Observable

class DiceData {
    var firstDiceNumber = 0
    var secondDiceNumber = 0

    var total: Int {
        return firstDiceNumber + secondDiceNumber
    }
}
@main
struct DiceVisionOSApp: App {
    @State var diceData = DiceData()
    var body: some Scene {
        WindowGroup {
            ContentView(diceData: diceData)
        }
        
        .defaultSize(width: 100, height: 100)

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(diceData: diceData)
        }
    }
}


#Preview(windowStyle: .automatic) {
    ContentView(diceData: DiceData())
}
