//
//  Vision+.swift
//  VisionAPI
//
//  Created by temoki on 2017/06/08.
//  Copyright © 2017年 temoki. All rights reserved.
//

import Vision

extension vector_float2 {
    
    func convertToCGPoint(in rect: CGRect) -> CGPoint {
        return CGPoint(x: CGFloat(self.x) * rect.size.width + rect.origin.x,
                       y: CGFloat(1 - self.y) * rect.size.height + rect.origin.y)
    }
    
}

extension VNFaceLandmarkRegion2D {
    
    func convertToCGPoints(in rect: CGRect) -> [CGPoint] {
        var cgPoints: [CGPoint] = []
        for i in 0 ..< self.pointCount {
            cgPoints.append(self.point(at: i).convertToCGPoint(in: rect))
        }
        return cgPoints
    }
}


