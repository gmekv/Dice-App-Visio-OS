//
//  ImmersiveView.swift
//  DiceVisionOS
//
//  Created by Giorgi Mekvabishvili on 19.08.24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    var body: some View {
        RealityView { content in
            let floor = ModelEntity(mesh: .generatePlane(width: 50, depth: 50), materials: [OcclusionMaterial()])
            floor.generateCollisionShapes(recursive: false)
            floor.components[PhysicsBodyComponent.self] = .init(massProperties: .default, mode: .static)
            
            content.add(floor)
            if let diceModel = try? await
                Entity(named: "dice"),
               let dice = diceModel.children.first?.children.first {
                dice.scale = [0.1, 0.1, 0.1]
                dice.position.y = 0.5
                dice.position.x = -1
                dice.generateCollisionShapes(recursive: false)
                dice.components.set(InputTargetComponent())
                dice.components[PhysicsBodyComponent.self] = .init(PhysicsBodyComponent(massProperties: .default, material: .generate(staticFriction: 0.8, dynamicFriction: 0.5, restitution: 0.1),             mode: .dynamic                                 ))
                dice.components[PhysicsMotionComponent.self] = .init()
                content.add(dice)
            }
        }
        .gesture(dragGesture)
    }
    var dragGesture: some Gesture {
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    var newPosition = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                    
                    // Clamp the y position to prevent it from going below the floor
                    newPosition.y = max(newPosition.y, 0.1) // Assuming the floor's y position is 0
                    
                    value.entity.position = newPosition
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
                } .onEnded { value in
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                }
        }
    }


#Preview(immersionStyle: .mixed) {
    ImmersiveView()
}
