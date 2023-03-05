//
//  GameViewController.swift
//  gameon
//
//  Created by Arman on 3/26/1401 AP.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    let defaults = UserDefaults.standard

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        
            let skView = self.view as! SKView
            if skView.scene == nil {
                let scene = GameScene(fileNamed: "GameScene")
                view.backgroundColor = UIColor.green
                let skView = view as! SKView
                skView.showsFPS = false
                skView.showsNodeCount = false
                skView.ignoresSiblingOrder = true
                skView.presentScene(scene)
                
            }
        }
    

}
