//
//  SMVFI_G.swift
//  SMV
//
//  Created by Zerui Chen on 18/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

let MAX_POINT_COUNT = 5000
let GRADE_OFFSET: CGFloat = 1

/// Grade over forgetting-index graph.
class SMVFI_G: Codable
{
    
    private var points: [CGPoint]
    private var _graph: RegressionModelER?
    /// Convenient getter for the underlying _graph property.
    private var graph: RegressionModelER
    {
        if _graph == nil {
            _graph = exponentialRegression(points: points)
        }
        return _graph!
    }
    
    /// Initialise the graph with the given points, otherwise two default points will be set as starting point.
    init(points: [CGPoint]? = nil)
    {
        if points != nil
        {
            self.points = points!
        }
        else
        {
            self.points = []
            _registerPoint(fi: 0, g: MAX_GRADE)
            _registerPoint(fi: 100, g: 0)
        }
    }
    
    /// Append the new point to points, while maintaining max length of MAX_POINT_COUNT.
    private func _registerPoint(fi: CGFloat, g: CGFloat)
    {
        points.append(CGPoint(x: fi, y: g + GRADE_OFFSET))
        points = points.suffix(MAX_POINT_COUNT)
    }
    
    /// Update the FI-G graph by registering the new points, clears the previous regression model.
    func update(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        let expectedFI = item.uf(now: now) / CGFloat(item.of) * sm.requestedFI
        _registerPoint(fi: expectedFI, g: grade)
        _graph = nil
    }
    
    /// Estimate forgetting-index from grade.
    func fi(grade: CGFloat)-> CGFloat
    {
        return max(0, min(100, graph.x(grade + GRADE_OFFSET)))
    }
    
    /// Estimate grade from forgetting-index.
    func grade(fi: CGFloat)-> CGFloat
    {
        return graph.y(fi) - GRADE_OFFSET
    }
    
    // MARK: Codable Conformances
    enum CodingKeys: CodingKey
    {
        case points
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
    
    required convenience init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let points = try container.decode([CGPoint].self, forKey: .points)
        self.init(points: points)
    }
}
