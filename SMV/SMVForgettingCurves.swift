//
//  SMVForgettingCurves.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

// MARK: Constants
let FORGOTTEN: CGFloat = 1
let REMEMBERED: CGFloat = 100 + FORGOTTEN

// MARK: 2D Collection of forgettingCurve.
class SMVForgettingCurves: Codable
{
    
    let curves: [[SMVForgettingCurve]]
    
    init(points: [[[CGPoint]]]? = nil)
    {
        self.curves = (0..<RANGE_REPETITION).map { (r) in
            (0..<RANGE_AF).map { a in
                let partialPoints: [CGPoint]
                if points != nil {
                    partialPoints = points![r][a]
                }
                else {
                    let p: [CGPoint]
                    if r > 0 {
                        p = (0...20).map {i in
                            let _a = -CGFloat(r + 1) / 200
                            let _b = CGFloat(i) - CGFloat(a) * sqrt(2 / CGFloat(r + 1))
                            let _c = (REMEMBERED - sm.requestedFI)
                            return CGPoint(
                                x: MIN_AF + NOTCH_AF * CGFloat(i),
                                y: min(REMEMBERED, exp(_a * _b) * _c)
                            )
                        }
                    }
                    else {
                        p = (0...20).map {i in
                            let _a = -1 / CGFloat(11 + a)
                            let _b = CGFloat(i) - pow(CGFloat(a), 0.6)
                            let _c = (REMEMBERED - sm.requestedFI)
                            return CGPoint(
                                x: MIN_AF + NOTCH_AF * CGFloat(i),
                                y: min(REMEMBERED, exp(_a * _b) * _c)
                            )
                        }
                    }
                    partialPoints = [CGPoint(x: 0, y: REMEMBERED)] + p
                }
                return SMVForgettingCurve(points: partialPoints)
            }
        }
    }
    
    /// Register a point representing the grading event in the suitable forgetting-curve.
    func registerPoint(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        let afIndex: Int = item.repetition > 0 ? item.afIndex() : Int(item.lapse)
        curves[Int(item.repetition)][afIndex].registerPoint(grade: grade, uf: item.uf(now: now))
    }

    // MARK: Codable Conformances
    enum CodingKeys: CodingKey
    {
        case points
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let points = curves.map {curves in
            curves.map {curve in
                curve.points
            }
        }
        try container.encode(points, forKey: .points)
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let points = try container.decode([[[CGPoint]]].self, forKey: .points)
        self.init(points: points)
    }
}
