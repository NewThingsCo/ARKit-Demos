//
//  Text.swift
//  ARKit Demo
//
//  Created by Laura Vuorenoja on 12/09/2018.
//  Copyright © 2018 New Things Company. All rights reserved.
//

import ARKit

class Text: SCNNode {
    
    let textNode: SCNNode

    init(anchor: ARImageAnchor, in sceneView: ARSCNView) {
        let text = SCNText(string: "Great, you found the sauna lounge!", extrusionDepth: 0.02)
        let font = UIFont(name: "Futura", size: 3)
        text.font = font
        text.alignmentMode = kCAAlignmentCenter
        text.firstMaterial?.diffuse.contents = UIColor.white
        text.firstMaterial?.specular.contents = UIColor.gray
        text.firstMaterial?.isDoubleSided = true
        text.chamferRadius = 0.01
        let (minBound, maxBound) = text.boundingBox
        textNode = SCNNode(geometry: text)
        textNode.pivot = SCNMatrix4MakeTranslation( (maxBound.x - minBound.x)/2, minBound.y, 0.02/2)
        textNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
        textNode.eulerAngles.x = -.pi / 2

        super.init()
        addChildNode(textNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
