//
//  GameScene.swift
//  BasitOyun
//
//  Created by utku enes alagöz on 11.10.2022.
//

import SpriteKit
import GameplayKit

enum CarpismaTipi:UInt32{
    case anakarakter = 1
    case saridaire = 2
    case siyahkare = 3
    case kirmiziucgen = 4
}
class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var anakarakter:SKSpriteNode = SKSpriteNode()
    var siyahkare:SKSpriteNode = SKSpriteNode()
    var saridaire:SKSpriteNode = SKSpriteNode()
    var kirmiziucgen:SKSpriteNode = SKSpriteNode()
    
    var skorLabel:SKLabelNode = SKLabelNode()
    
    var viewController: UIViewController?
    
    var dokunmaKontrol = false
    
    var oyunBaslangicKontrol = false
    
    var ekranGenisligi:Int?
    var ekranYuksekligi:Int?
    
    var sayici:Timer?
    
    var toplamSkor = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        ekranGenisligi = Int(self.size.width)
        ekranYuksekligi = Int(self.size.height)
        
        if let tempKarakter = self.childNode(withName: "anakarakter") as? SKSpriteNode {
            anakarakter = tempKarakter
            
            anakarakter.physicsBody?.categoryBitMask = CarpismaTipi.anakarakter.rawValue
            anakarakter.physicsBody?.collisionBitMask = CarpismaTipi.siyahkare.rawValue | CarpismaTipi.saridaire.rawValue | CarpismaTipi.kirmiziucgen.rawValue
            anakarakter.physicsBody?.contactTestBitMask = CarpismaTipi.siyahkare.rawValue | CarpismaTipi.saridaire.rawValue | CarpismaTipi.kirmiziucgen.rawValue
            
        }
        if let tempKarakter = self.childNode(withName: "siyahkare") as? SKSpriteNode {
            siyahkare = tempKarakter
            
            siyahkare.physicsBody?.categoryBitMask = CarpismaTipi.siyahkare.rawValue
            siyahkare.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            siyahkare.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
            
        }
        if let tempKarakter = self.childNode(withName: "saridaire") as? SKSpriteNode {
            saridaire = tempKarakter
            
            saridaire.physicsBody?.categoryBitMask = CarpismaTipi.saridaire.rawValue
            saridaire.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            saridaire.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
        }
        if let tempKarakter = self.childNode(withName: "kirmiziucgen") as? SKSpriteNode {
            kirmiziucgen = tempKarakter
            
            kirmiziucgen.physicsBody?.categoryBitMask = CarpismaTipi.kirmiziucgen.rawValue
            kirmiziucgen.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            kirmiziucgen.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
        }
        if let tempKarakter = self.childNode(withName: "skorLabel") as? SKLabelNode {
            skorLabel = tempKarakter
            
        }
        
        sayici = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(GameScene.hareket), userInfo: nil, repeats: true)
       
    }
    
    @objc func hareket(){
        
        if oyunBaslangicKontrol{
            
            let anakarakterHiz = CGFloat(ekranGenisligi!/36)
            let siyahkareHiz = CGFloat(ekranGenisligi!/75)
            let saridaireHiz = CGFloat(ekranGenisligi!/36)
            let kirmiziucgenHiz = CGFloat(ekranGenisligi!/50)
            
            if dokunmaKontrol{
                
                let yukariHareket:SKAction = SKAction.moveBy(x: 0, y: +anakarakterHiz, duration: 0.2)
                anakarakter.run(yukariHareket)
                
            }
            else{
                
                let asagiHareket:SKAction = SKAction.moveBy(x: 0, y: -anakarakterHiz, duration: 0.2)
                anakarakter.run(asagiHareket)
                
            }
            cisimlerinSerbestHareketi(cisimAdi: kirmiziucgen, cisimHizi: -kirmiziucgenHiz)
            cisimlerinSerbestHareketi(cisimAdi: siyahkare, cisimHizi: -siyahkareHiz)
            cisimlerinSerbestHareketi(cisimAdi: saridaire, cisimHizi: -saridaireHiz)
        }
    }
    
    func cisimlerinSerbestHareketi(cisimAdi:SKSpriteNode,cisimHizi:CGFloat){
        
        if Int(cisimAdi.position.x) < 0 {
            
            cisimAdi.position.x = CGFloat(ekranGenisligi! + 20)
            
            cisimAdi.position.y = -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!)))// random bir yerden başlatır
            
        }else{
            let solaHareket:SKAction = SKAction.moveBy(x: cisimHizi, y: 0, duration: 6)
            cisimAdi.run(solaHareket)
        }
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
        
        dokunmaKontrol = true
        oyunBaslangicKontrol = true
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        dokunmaKontrol = false
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) { // çarpışma kontrolü
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyB.categoryBitMask == CarpismaTipi.siyahkare.rawValue {
            
            sayici?.invalidate()
            
            let d = UserDefaults.standard
            
            d.set(toplamSkor, forKey: "anlikSkor")
            
            self.viewController?.performSegue(withIdentifier: "oyunTosonuc", sender: nil)
            
            print("anakarakter - siyah kareye çarptı")
        }
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyA.categoryBitMask == CarpismaTipi.siyahkare.rawValue {
            
            sayici?.invalidate()
            
            let d = UserDefaults.standard
            
            d.set(toplamSkor, forKey: "anlikSkor")
            
            self.viewController?.performSegue(withIdentifier: "oyunTosonuc", sender: nil)
                        
            print("siyahkare - anakaraktere çarptı")
        }
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyB.categoryBitMask == CarpismaTipi.saridaire.rawValue {
            
            let basaAl:SKAction = SKAction.moveBy(x: CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            saridaire.run(basaAl)
            
            toplamSkor += 20
            
            skorLabel.text = "Skor: \(toplamSkor)"
            
            print("anakarakter - saridaire çarptı")
        }
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyA.categoryBitMask == CarpismaTipi.saridaire.rawValue {
            
            let basaAl:SKAction = SKAction.moveBy(x: CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            saridaire.run(basaAl)
            
            toplamSkor += 20
            
            skorLabel.text = "Skor: \(toplamSkor)"
            
            print("saridaire - anakaraktere çarptı")
        }
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyB.categoryBitMask == CarpismaTipi.kirmiziucgen.rawValue {
            
            let basaAl:SKAction = SKAction.moveBy(x: CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            kirmiziucgen.run(basaAl)
            
            toplamSkor += 50
            
            skorLabel.text = "Skor: \(toplamSkor)"
            
            print("anakarakter - kirmiziucgen çarptı")
        }
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue && contact.bodyA.categoryBitMask == CarpismaTipi.kirmiziucgen.rawValue {
            
            let basaAl:SKAction = SKAction.moveBy(x: CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            kirmiziucgen.run(basaAl)
            
            toplamSkor += 50
            
            skorLabel.text = "Skor: \(toplamSkor)"
            
            print("kirmiziucgen - anakaraktere çarptı")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
