//
//  Player.swift
//  Cosmo Dodge
//
//  Created by user211509 on 5/21/22.
//

import Foundation
import SpriteKit
import GameplayKit

enum PlayerAnimationType: String {
    
    case fly
    
}


class Player: SKSpriteNode {
    
    private var flyTextures: [SKTexture]?
    public var playerSpeed: CGFloat = 1
    
    init() {
        
        let texture = SKTexture(imageNamed: "Spaceship_0")
        super.init(texture: texture, color: .clear, size: texture.size())
        self.flyTextures = self.loadTextures(atlas: "Spaceship", prefix: "Spaceship_", StartsAt: 0, StopsAt: 2)
        self.name = "player"
        self.setScale(1.0)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func fly() {
        
        guard let flyTextures = flyTextures else {
            
            preconditionFailure("Could not find textures")
            
        }
        
        startAnimation(textures: flyTextures, speed: 0.3, name: PlayerAnimationType.fly.rawValue, count: 0, resize: true, restore: true)

    }
    
    func moveToPosition(pos: CGPoint, speed: TimeInterval) {

        let moveAction = SKAction.move(to: pos, duration: speed)
        run(moveAction)
        
    }
}
