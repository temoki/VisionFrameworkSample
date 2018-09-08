//
//  CoreGraphics+.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    
    func scaled(to size: CGSize) -> CGPoint {
        return CGPoint(x: CGFloat(self.x) * size.width,
                       y: CGFloat(1 - self.y) * size.height)
    }
    
}
extension CGRect {
    
    func scaled(to size: CGSize) -> CGRect {
        return CGRect(x: self.minX * size.width,
                      y: (1 - self.maxY) * size.height,
                      width: self.width * size.width,
                      height: self.height * size.height)
    }
    
}

extension CGContext {
    
    func draw(points: [CGPoint], close: Bool) {
        guard !points.isEmpty else { return }
        
        if points.count == 1 {
            addArc(center: points[0], radius: 3, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            strokePath()
            return
        }
        
        for (i, p) in points.enumerated() {
            if i == 0 {
                self.move(to: p)
            } else {
                self.addLine(to: p)
            }
        }
        if close { self.closePath() }
        self.strokePath()
    }
    
}
