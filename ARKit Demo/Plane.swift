//
//  Plane.swift
//  ARKit Demo
//
//  Created by Laura Vuorenoja on 12/09/2018.
//  Copyright © 2018 New Things Company. All rights reserved.
//

import ARKit

class Plane: SCNNode {

    let extentNode: SCNNode

    init(anchor: ARPlaneAnchor, in sceneView: ARSCNView) {

        // Create a node to visualize the plane's bounding rectangle.
        let extentPlane: SCNPlane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        extentNode = SCNNode(geometry: extentPlane)
        extentNode.simdPosition = anchor.center
        // `SCNPlane` is vertically oriented in its local coordinate space, so
        // rotate it to match the orientation of `ARPlaneAnchor`.
        extentNode.eulerAngles.x = -.pi / 2
        super.init()
        self.setupExtentVisualStyle()
        addChildNode(extentNode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupExtentVisualStyle() {
        // Make the extent visualization semitransparent to clearly show real-world placement.
        extentNode.opacity = 0.6
        
        guard let material = extentNode.geometry?.firstMaterial
            else { fatalError("SCNPlane always has one material") }
        material.diffuse.contents = "newthingsco"
    }
}
