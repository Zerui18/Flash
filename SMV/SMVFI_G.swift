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

class SMVFI_G: Codable
{
    
    var points: [CGPoint]
    
    var _graph: RegressionModelER?
    /// Convenient getter for the underlying _graph property.
    var graph: RegressionModelER
    {
        if _graph == nil {
            _graph = exponentialRegression(points: points)
        }
        return _graph!
    }
    
    init(points: [CGPoint]? = nil)
    {
        self.points = points ?? []
    }
    
    func _registerPoint(fi: CGFloat, g: CGFloat)
    {
        points.append(CGPoint(x: fi, y: g + GRADE_OFFSET))
        points = points.suffix(MAX_POINT_COUNT)
    }
    
    /// Update regression of FI-G graph
    func update(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        let expectedFI = item.uf(now: now) / CGFloat(item.of) * sm.requestedFI
        _registerPoint(fi: expectedFI, g: grade)
        _graph = nil
    }
    
    /// Estimate forgetting index
    func fi(grade: CGFloat)-> CGFloat
    {
        return max(0, min(100, graph.x(grade + GRADE_OFFSET)))
    }
    
    func grade(fi: CGFloat)-> CGFloat
    {
        return graph.y(fi) - GRADE_OFFSET
    }
    
    // MARK: Codable Conformances
    enum CodingKeys: CodingKey
    {
        case points
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
    }
    
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let points = try container.decode([CGPoint].self, forKey: .points)
        self.init(points: points)
    }
}
