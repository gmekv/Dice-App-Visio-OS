//
//  ContentView.swift
//  DiceVisionOS
//
//  Created by Giorgi Mekvabishvili on 19.08.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    
    var diceData: DiceData

    var body: some View {
        VStack {
            Text(diceData.rolledNumber ==  0 ? "🎲" : "\(diceData.rolledNumber)")
                .foregroundStyle(.black)
                .font(.custom("Menlo", size: 100))

        }
        .task {
            await openImmersiveSpace(id: "ImmersiveSpace")
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView(diceData: DiceData())
}
