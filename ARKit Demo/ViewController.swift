//
//  ViewController.swift
//  ARKit Demo
//
//  Created by Laura Vuorenoja on 07/09/2018.
//  Copyright © 2018 New Things Company. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var modeLabel: UILabel!

    enum Mode {
        case detectPlanes
        case recognizeImage
    }
    var mode = Mode.detectPlanes

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Show debug UI to view performance metrics (e.g. frames per second).
        sceneView.showsStatistics = true
        planeDetectionActivated(self);
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    @IBAction func planeDetectionActivated(_ sender: Any) {
        mode = Mode.detectPlanes
        updateMode()
    }

    @IBAction func imageRecognitionActivated(_ sender: Any) {
        mode = Mode.recognizeImage
        updateMode()
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if (mode == Mode.detectPlanes) {
            // Place content only for anchors found by plane detection.
            guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
            
            // Create a custom object to visualize the plane geometry and extent.
            let plane = Plane(anchor: planeAnchor, in: sceneView)
            
            // Add the visualization to the ARKit-managed node so that it tracks
            // changes in the plane anchor as plane estimation continues.
            node.addChildNode(plane)
        } else if (mode == Mode.recognizeImage) {
            guard let imageAnchor = anchor as? ARImageAnchor else { return }
            let text = Text(anchor: imageAnchor, in: sceneView)
            node.addChildNode(text)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if (mode == Mode.detectPlanes) {
            // Update only anchors and nodes set up by `renderer(_:didAdd:for:)`.
            guard let planeAnchor = anchor as? ARPlaneAnchor,
                let plane = node.childNodes.first as? Plane
                else { return }
            
            // Update extent visualization to the anchor's new bounding rectangle.
            if let extentGeometry = plane.extentNode.geometry as? SCNPlane {
                extentGeometry.width = CGFloat(planeAnchor.extent.x)
                extentGeometry.height = CGFloat(planeAnchor.extent.z)
                plane.extentNode.simdPosition = planeAnchor.center
            }
        }
    }
    
    private func runConfiguration(configuration: ARWorldTrackingConfiguration) {
        self.sceneView.scene.rootNode.enumerateChildNodes { (existingNode, _) in
            existingNode.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    private func updateMode() {
        let configuration = ARWorldTrackingConfiguration()
        switch mode {
        case Mode.detectPlanes:
            configuration.detectionImages = []
            configuration.planeDetection = [.horizontal, .vertical]
            modeLabel.text = "Plane detection"
            break
        case Mode.recognizeImage:
            guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
                fatalError("Missing expected asset catalog resources.")
            }
            configuration.detectionImages = referenceImages
            configuration.planeDetection = []
            modeLabel.text = "Image recognition"
            break
        }
        runConfiguration(configuration: configuration)
    }
}
