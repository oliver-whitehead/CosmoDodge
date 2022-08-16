//
//  ContentView.swift
//  Shared
//
//  Created by user211509 on 5/21/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = MenuScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        SpriteView(scene: scene)
            .frame(width: scene.size.width, height: scene.size.height)
    }
}

