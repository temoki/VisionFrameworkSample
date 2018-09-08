//
//  TextDetectionResultView.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import Vision

class TextDetectionResultView: UIView {
    
    var observations: [VNTextObservation]? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        guard let obss = self.observations else { return }
        
        for obs in obss {
            UIColor.green.setStroke()
            let box = obs.boundingBox.scaled(to: self.frame.size)
            ctx.stroke(box, width: 3)
            
            guard let boxes = obs.characterBoxes else { continue }
            
            UIColor.white.setStroke()
            for box in boxes {
                ctx.stroke(box.boundingBox.scaled(to: self.frame.size), width: 1)
            }
        }
    }
    
}
