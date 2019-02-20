//
//  SMVForgettingCurve.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

// MARK: Constants
fileprivate let MAX_POINTS_COUNT = 500

// MARK: SMVForgettingCurve
class SMVForgettingCurve
{
    
    var points: [CGPoint]
    /// The exponential regression model of this curve.
    private var _curve: RegressionModelER?
    /// Convenient getter for the underlying _curve property.
    var curve: RegressionModelER
    {
        if _curve == nil {
            _curve = exponentialRegression(points: points)
        }
        return _curve!
    }
    
    init(points: [CGPoint])
    {
        self.points = points
    }
    
    /// Appends a new point to this curve, clears the current regression model.
    func registerPoint(grade: CGFloat, uf: CGFloat)
    {
        let isRemembered = grade >= THRESHOLD_RECALL
        points.append(CGPoint(x: uf, y: isRemembered ? REMEMBERED:FORGOTTEN))
        points = points.suffix(MAX_POINTS_COUNT)
        _curve = nil
    }
    
    func retention(uf: CGFloat)-> CGFloat
    {
        return max(FORGOTTEN, min(curve.y(uf), REMEMBERED)) - FORGOTTEN
    }
    
    func uf(retention: CGFloat)-> CGFloat
    {
        return max(0, curve.x(retention + FORGOTTEN))
    }
}
