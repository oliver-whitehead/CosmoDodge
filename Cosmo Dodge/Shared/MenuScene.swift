//
//  MenuScene.swift
//  Cosmo Dodge
//
//  Created by user211509 on 5/23/22.
//

import Foundation
import SpriteKit
import GameplayKit
import SwiftUI

class MenuScene: SKScene, SKPhysicsContactDelegate {
    
    var gameTimer: Timer?
    let asteroidInterval = 3.0
    let highScoreDisplay = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var highScore = storedHighScore {
        didSet {
            highScoreDisplay.text = "HIGH SCORE: \(highScore)"
        }
    }
    

    
  override func didMove(to view: SKView) {
      
      let background = SKSpriteNode(imageNamed: "background_1")
      background.anchorPoint = CGPoint(x: 0, y: 0)
      background.position = CGPoint(x: 0, y: 0)
      background.zPosition = -1
      addChild(background)
      
      highScoreDisplay.fontSize = 17
      highScoreDisplay.zPosition = 3
      highScoreDisplay.position.y = (self.frame.size.height/2.5)
      highScoreDisplay.position.x = (self.frame.size.width/2)
      addChild(highScoreDisplay)
      highScore += 0
      
      let title = SKSpriteNode(imageNamed: "Title")
      title.zPosition = 3
      title.position.y = (self.frame.size.height/1.7)
      title.position.x = (self.frame.size.width/2)
      addChild(title)
      
      let btn = SKSpriteNode(imageNamed: "StartBtn")
      btn.name = "btn"
      btn.zPosition = 3
      btn.position.y = (self.frame.size.height/3)
      btn.position.x = (self.frame.size.width/2)
      addChild(btn)
      
      if let particles = SKEmitterNode(fileNamed: "Stars") {
          
          particles.advanceSimulationTime(10)
          particles.position.x = self.frame.size.width/2
          particles.position.y = self.frame.size.height*1.5
          particles.particlePositionRange.dy = self.frame.size.height
          addChild(particles)
          
      }
      
      if let particles2 = SKEmitterNode(fileNamed: "Nebula") {
          
          particles2.advanceSimulationTime(10)
          particles2.position.x = self.frame.size.width/2
          particles2.position.y = self.frame.size.height*1.5
          particles2.particlePositionRange.dy = self.frame.size.height
          addChild(particles2)
          
      }
      
      gameTimer = Timer.scheduledTimer(timeInterval: asteroidInterval, target: self, selector: #selector(createAsteroid), userInfo: nil, repeats: true)
      
  }

  override func update(_ currentTime: TimeInterval) {
      
      for node in children {
          
          if node.position.y > 1000 || node.position.y < -1000 || node.position.x > 1000 || node.position.x < -1000 {
              
              node.removeFromParent()
              
          }
      }
  }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
      let touch = touches.first
      let touchPos = touch!.location(in: self)
      let touchNode = self.atPoint(touchPos)
      
      if let check = touchNode.name {
          if check == "btn" {
              
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                  
                  self.removeAllChildren()
                  let newScene = GameScene(size: self.size)
                  newScene.scaleMode = self.scaleMode
                  let animation = SKTransition.fade(withDuration: 1.0)
                  self.view?.presentScene(newScene, transition: animation)
                  
              }
          }

      }
      
  }
    
    
    @objc func createAsteroid() {
        
        let randomDistribution = GKRandomDistribution(lowestValue: 0, highestValue: Int((self.frame.self.width - 0)))
        let sprite = SKSpriteNode(imageNamed: "asteroid")
        let asteroidy = Int((self.frame.size.height + 100))
        sprite.position = CGPoint(x: randomDistribution.nextInt(), y: asteroidy)
        sprite.name = "asteroid"
        sprite.zPosition = 1
        let randomDouble = Double.random(in: 1..<6)
        sprite.zRotation = randomDouble
        sprite.setScale(1)
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, alphaThreshold: 0.9, size: sprite.size)
        sprite.physicsBody?.velocity = CGVector(dx: 0, dy: -100)
        sprite.physicsBody?.affectedByGravity = false
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.contactTestBitMask = 1
        sprite.physicsBody?.categoryBitMask = 0
    }

}
