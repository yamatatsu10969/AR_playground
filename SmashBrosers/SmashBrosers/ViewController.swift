//
//  ViewController.swift
//  SmashBrosers
//
//  Created by 山本竜也 on 2019/1/12.
//  Copyright © 2019 山本竜也. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        //sphere作成 半径20cm
        let earth = SCNSphere(radius: 0.2)
        //テキスチャを貼り付けている
        earth.firstMaterial?.diffuse.contents = UIImage(named: "earth")
        let earthNode = SCNNode(geometry: earth)
        earthNode.position = SCNVector3(0,0,-1)
        
        //Mario作成
        let marioScene = SCNScene(named:"art.scnassets/Mario/mario.scn")!
        let marioNode = marioScene.rootNode
        marioNode.position = SCNVector3(0,0,-1)
        
        //CaptainFalcon作成
        let captainFalconScene = SCNScene(named:"art.scnassets/CaptainFalcon/cf.obj")!
        let captainFalconNode = captainFalconScene.rootNode
        captainFalconNode.position = SCNVector3(0,0,2)
        
        //Luigi作成
        let luigiScene = SCNScene(named:"art.scnassets/Luigi/luigi.obj")!
        let luigiNode = luigiScene.rootNode
        luigiNode.position = SCNVector3(1,0,0)
        
        //Link作成
        let linkScene = SCNScene(named:"art.scnassets/Link/link.obj")!
        let linkNode = linkScene.rootNode
        linkNode.position = SCNVector3(-1,0,0)
        
        //動きはnodeに対してつけていく。nodeをどこに置くかを変える　timerで,earthNode.position = SCNVector3(0,0,-1) を減らしていくのもあり。
        //x,y,z は軸の方向、duration はどのくらいの間隔で回るか
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 4)))
        
        scene.rootNode.addChildNode(earthNode)
        earthNode.addChildNode(marioNode)
        earthNode.addChildNode(captainFalconNode)
        earthNode.addChildNode(luigiNode)
        earthNode.addChildNode(linkNode)
        
        //これで画像をタップしたら、とかもできるようになる。
        //targetのselfはここで関数を使うよってこと
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        //このsceneViewに追加するよ
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    @objc func tapped(recognizer :UIGestureRecognizer){
        //        print("タップしたよ")
        // ! はアプリ落ちる。必ずsceneViewなら !で良い。無難なのは？でnilを返す
        let sceneView = recognizer.view as! SCNView
        //どこを触ったか
        let touchLocation = recognizer.location(in: sceneView)
        //
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        if !hitResults.isEmpty {
            
            let node = hitResults[0].node
            if let name = node.geometry?.name {
                if name == "moon"{
                    node.geometry?.firstMaterial?.diffuse.contents = UIColor.red
                }
            }
            
            //            let material = node.geometry?.material(named: "Color")
            //
            //            material?.diffuse.contents = UIColor.random()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
