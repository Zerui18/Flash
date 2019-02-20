//
//  SMVTests.swift
//  SMVTests
//
//  Created by Zerui Chen on 19/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import XCTest
@testable import SMV

class SMVTests: XCTestCase {
    
    let points: [CGPoint] = (1...100).map { (x) in
        CGPoint(x: CGFloat(x), y: CGFloat(x*x + 10))
    }
    
//    let points2d: [[CGPoint]] = (1...30).map { (x) in
//        (1...30).map { (x2) in
//            CGPoint(x: CGFloat(x * x2), y: CGFloat(x * x2 / 30))
//        }
//    }
//    
//    let points3d: [[[CGPoint]]] = (1...30).map { (x: Int) in
//        let points2: [[CGPoint]] = (1...30).map { (x2: Int) in
//            let points: [CGPoint] = (1...10).map { (x3: Int) in
//                CGPoint(x: CGFloat(x * x2 * x3) * 3.5e-2, y: CGFloat(x * x2 * x3) / 30e2)
//            }
//            return points
//        }
//        return points2
//    }

    func testExpRegression()
    {
        
        let model = exponentialRegression(points: points)
        XCTAssertEqual(round(model.a), 103)
        XCTAssertEqual(round(model.b * 1000), 54)
    }
    
    func testLinearRegression()
    {
        let model = linearRegression(points: points)
        XCTAssertEqual(model.a, -1707)
        XCTAssertEqual(model.b, 101)
    }
    
    func testFPPLRegression()
    {
        let model = fixedPointPowerLawRegression(points: points, fixedPoint: CGPoint(x: 23.2, y: 2323))
        XCTAssertEqual(round(model.a), 52)
        XCTAssertEqual(round(model.b * 100), 121)
    }
    
    func testForgettingCurves()
    {
        let sm = SMVEngine.shared
        let curve = sm.forgettingCurves
        let curves = curve.curves[0]
        // stage 1
        XCTAssertEqual(round(curves.reduce(CGFloat(0), { (sum2, curve) in
            sum2 + curve.curve.a * curve.curve.b
        })), -400)
        // stage 2
        let sum = curve.curves.reduce(CGFloat(0), { (sum, curves) in
            sum + curves.reduce(CGFloat(0), { (sum2, curve) in
                sum2 + curve.curve.a * curve.curve.b
            })
        })
        XCTAssertEqual(round(sum), -8299)
    }
    
    func testFI_G()
    {
        let sm = SMVEngine.shared
        let fi_g = sm.fi_g
        XCTAssertEqual(fi_g.fi(grade: <#T##CGFloat#>), <#T##expression2: Equatable##Equatable#>)
    }

}
