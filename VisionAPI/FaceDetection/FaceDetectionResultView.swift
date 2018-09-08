//
//  FaceDetectionResultView.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import UIKit
import Vision

class FaceDetectionResultView: UIView {
    
    var observation: VNFaceObservation? {
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
        let lineWidth: CGFloat = 3
        ctx.setLineWidth(lineWidth)
        
        UIColor.green.setStroke()
        let box = obs.boundingBox.scaled(to: self.frame.size)
        print(box)
        ctx.stroke(box, width: lineWidth)
        
        guard let marks = observation?.landmarks else { return }
        
        UIColor.lightGray.setStroke()
        if let points = marks.faceContour?.convertToCGPoints(in: box) { ctx.draw(points: points, close: false) }
        
        UIColor.orange.setStroke()
        if let points = marks.leftEye?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        if let points = marks.rightEye?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        
        UIColor.magenta.setStroke()
        if let points = marks.leftEyebrow?.convertToCGPoints(in: box) { ctx.draw(points: points, close: false) }
        if let points = marks.rightEyebrow?.convertToCGPoints(in: box) { ctx.draw(points: points, close: false) }
        
        UIColor.white.setStroke()
        if let points = marks.leftPupil?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        if let points = marks.rightPupil?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        
        UIColor.blue.setStroke()
        if let points = marks.nose?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        if let points = marks.noseCrest?.convertToCGPoints(in: box) { ctx.draw(points: points, close: false) }
        
        UIColor.yellow.setStroke()
        if let points = marks.medianLine?.convertToCGPoints(in: box) { ctx.draw(points: points, close: false) }
        
        UIColor.red.setStroke()
        if let points = marks.outerLips?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
        if let points = marks.innerLips?.convertToCGPoints(in: box) { ctx.draw(points: points, close: true) }
    }
    
}
