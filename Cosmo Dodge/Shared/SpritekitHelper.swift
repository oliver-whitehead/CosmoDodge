//
//  SpritekitHelper.swift
//  Cosmo Dodge
//
//  Created by user211509 on 5/21/22.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    func loadTextures(atlas: String, prefix: String, StartsAt: Int, StopsAt: Int) -> [SKTexture] {
        
        var textureArray = [SKTexture]()
        let textureAtlas = SKTextureAtlas(named: atlas)
        for i in StartsAt...StopsAt {
            
            let textureName = "\(prefix)\(i)"
            let temp = textureAtlas.textureNamed(textureName)
            textureArray.append(temp)
            
        }
        return textureArray
        
    }
 
    func startAnimation(textures: [SKTexture], speed: Double, name: String, count: Int, resize: Bool, restore: Bool) {
        
        if (action(forKey: name) == nil) {
            
            let animation = SKAction.animate(with: textures, timePerFrame: speed, resize: resize, restore: restore)
            
            if count == 0 {
                
                let repeatAction = SKAction.repeatForever(animation)
                run(repeatAction, withKey: name)
                
            } else if count == 1 {
                
                run(animation, withKey: name)
                
            } else {
                
                let repeatAction = SKAction.repeat(animation, count: count)
                run(repeatAction, withKey: name)
                
            }
            
        }
        
    }
    
}
