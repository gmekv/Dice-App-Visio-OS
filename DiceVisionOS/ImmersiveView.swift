//
//  ImmersiveView.swift
//  DiceVisionOS
//
//  Created by Giorgi Mekvabishvili on 19.08.24.
//

import SwiftUI
import RealityKit
import RealityKitContent


let diceMap = [
    [1,6],
    [4,3],
    [2,5],
]

struct ImmersiveView: View {
    var diceData: DiceData
    @State var dropDice = false
    
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
                
                let _ = content.subscribe(to: SceneEvents.Update.self) { event in
                    guard dropDice else { return}
                    guard let diceMotion = dice.components[PhysicsMotionComponent.self] else {return}
                    if simd_length(diceMotion.linearVelocity) < 0.1 && simd_length(diceMotion.angularVelocity) < 0.1 {
                        let xDirection = dice.convert(direction: SIMD3(x: 1, y: 0, z: 0), to: nil)
                        let yDirection = dice.convert(direction: SIMD3(x: 0, y: 1, z: 0), to: nil)
                        let zDirection = dice.convert(direction: SIMD3(x: 0, y: 0, z: 1), to: nil)
                        
                        let greatestDirection = [
                            0: xDirection.y,
                            1: yDirection.y,
                            2: zDirection.y
                        ]
                            .sorted(by: { abs($0.1) > abs($1.1) })[0]
                        
                        diceData.rolledNumber = diceMap [ greatestDirection.key][ greatestDirection.value > 0 ? 0 : 1]
                    }
                }}
        }
        .gesture(dragGesture)
    }
    var dragGesture: some Gesture {
            DragGesture()
                .targetedToAnyEntity()
                .onChanged { value in
                    var newPosition = value.convert(value.location3D, from: .local, to: value.entity.parent!)
                    
                    newPosition.y = max(newPosition.y, 0.1)
                    
                    value.entity.position = newPosition
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .kinematic
                } .onEnded { value in
                    value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                    if !dropDice {
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                            dropDice = true
                        }
                    }
                }
        }
    }


#Preview(immersionStyle: .mixed) {
    ImmersiveView(diceData: DiceData())
}
