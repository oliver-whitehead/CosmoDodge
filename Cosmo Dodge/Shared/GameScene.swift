//
//  GameScene.swift
//  Cosmo Dodge
//
//  Created by user211509 on 5/21/22.
//

import Foundation
import SpriteKit
import GameplayKit

var storedHighScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = Player()
    var gameTimer: Timer?
    let asteroidInterval = 1.25
    let scoreDisplay = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    let highScoreDisplay = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    var score = 0 {
        didSet {
            scoreDisplay.text = "SCORE: \(score)"
        }
    }
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
      scoreDisplay.zPosition = 2
      scoreDisplay.position.y = (self.frame.size.height - 75)
      scoreDisplay.position.x = (self.frame.size.width/2)
      addChild(scoreDisplay)
      score = 0
      highScoreDisplay.fontSize = 17
      highScoreDisplay.zPosition = 3
      highScoreDisplay.position.y = (self.frame.size.height - 35)
      highScoreDisplay.position.x = (self.frame.size.width/2)
      addChild(highScoreDisplay)
      highScore += 0
      
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
      
      player.position = CGPoint(x: size.width/2, y: size.height/4)
      player.zPosition = 4
      addChild(player)
      player.fly()
      player.physicsBody = SKPhysicsBody(texture: player.texture!, alphaThreshold: 0.9, size: player.size)
      player.physicsBody?.categoryBitMask = 1
      player.physicsBody?.affectedByGravity = false
      physicsWorld.contactDelegate = self
      
      gameTimer = Timer.scheduledTimer(timeInterval: asteroidInterval, target: self, selector: #selector(createAsteroid), userInfo: nil, repeats: true)
      
  }

  override func update(_ currentTime: TimeInterval) {
      
      if player.parent != nil {
          score += 1
      }
      
      for node in children {
          
          if node.position.y > 1000 || node.position.y < -1000 || node.position.x > 1000 || node.position.x < -1000 {
              
              node.removeFromParent()
              
          }
      }
  }

    func touchDown(atPoint pos : CGPoint) {
        
        var offPos = pos
        offPos.y -= 30
        let distance = hypot(pos.x - player.position.x, pos.y - player.position.y)
        let calculatedSpeed = TimeInterval(distance / player.playerSpeed) / 255
        player.moveToPosition(pos: offPos, speed: calculatedSpeed)
        
    }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
      for t in touches { self.touchDown(atPoint: t.location(in: self)) }
      
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

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
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            
            playerHit(nodeB)
            
        } else {
            
            playerHit(nodeA)
            
        }
        
    }
    
    func playerHit(_ node: SKNode) {
        
        if let particles = SKEmitterNode(fileNamed: "Explosion.sks") {
            
            particles.position = player.position
            particles.zPosition = 5
            addChild(particles)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                
                particles.removeFromParent()
                    
            }
                
        }
        
        player.removeFromParent()
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.zPosition = 10
        gameOver.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(gameOver)
        
        if score > highScore {
            highScore = score
        }
        
        if highScore > storedHighScore {
            storedHighScore = highScore
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.removeAllChildren()
            
            let newScene = MenuScene(size: self.size)
            newScene.scaleMode = self.scaleMode
            let animation = SKTransition.fade(withDuration: 2.0)
            self.view?.presentScene(newScene, transition: animation)
            
        }
        
    }
}

