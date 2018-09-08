//
//  RectDetectionResultView.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import Vision

class RectDetectionResultView: UIView {
    
    var observation: VNRectangleObservation? {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.setNeedsDisplay()
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        guard let obs = self.observation else { return }
        let points = [obs.topLeft, obs.topRight, obs.bottomRight, obs.bottomLeft]
        
        UIColor.green.setStroke()
        ctx.setLineWidth(3)
        ctx.draw(points: points.map({ $0.scaled(to: self.frame.size)}), close: true)
    }
    
}

