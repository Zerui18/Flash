//
//  SMVMath.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

typealias OneToOneFunc = (CGFloat) -> CGFloat
typealias RegressionModel = (x: OneToOneFunc, y: OneToOneFunc, a: CGFloat, b: CGFloat)
typealias RegressionModelLRTO = (x: OneToOneFunc, y: OneToOneFunc, b: CGFloat)
typealias RegressionModelER = (x: OneToOneFunc, y: OneToOneFunc, a: CGFloat, b: CGFloat, mse: CGFloat)

func powerLawModel(a: CGFloat, b: CGFloat)-> RegressionModel
{
    return (
        x: {y in pow(y / a, 1 / b)},
        y: {x in a * pow(x, b)},
        a: a,
        b: b
    )
}

func linearRegressionThroughOrigin(points: [CGPoint])-> RegressionModelLRTO
{
    let sumXY = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x * point.y
    }
    let sumSqX = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x * point.x
    }
    let b = sumXY / sumSqX
    return (
        x: {y in y / b},
        y: {x in b * x},
        b: b
    )
}

func fixedPointPowerLawRegression(points: [CGPoint], fixedPoint: CGPoint)-> RegressionModel
{
    let p = fixedPoint.x
    let q = fixedPoint.y
    let logQ = log(q)
    let X = points.map { (point) in
        log(point.x / p)
    }
    let Y = points.map { (point) in
        log(point.y) - logQ
    }
    let newPoints = zip(X, Y).map { (turple) in
        CGPoint(x: turple.0, y: turple.1)
    }
    let b = linearRegressionThroughOrigin(points: newPoints).b
    return powerLawModel(a: q / pow(p, b), b: b)
}

func linearRegression(points: [CGPoint])-> RegressionModel
{
    let n = CGFloat(points.count)
    let sqX = points.map { (point) in
        point.x * point.x
    }
    let sumY = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.y
    }
    let sumSqX = sqX.reduce(CGFloat(0), +)
    let sumX = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x
    }
    let sumXY = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x * point.y
    }
    let sqSumX = sumX * sumX
    let a = (sumY * sumSqX - sumX * sumXY) / (n * sumSqX - sqSumX)
    let b = (n * sumXY - sumX * sumY) / (n * sumSqX - sqSumX)
    return (
        x: {y in (y - a) / b},
        y: {x in (a + b * x)},
        a: a,
        b: b
    )
}

func mse(y: OneToOneFunc, points: [CGPoint])-> CGFloat {
    let n = CGFloat(points.count)
    return points.reduce(CGFloat(0), { (sum, point) in
        pow(y(point.x) - point.y, 2)
    }) / n
}

func exponentialRegression(points: [CGPoint])-> RegressionModelER
{
    let n = CGFloat(points.count)
    let logY = points.map { (point) in
        log(point.y)
    }
    let sqX = points.map { (point) in
        point.x * point.x
    }
    let sumLogY = logY.reduce(CGFloat(0), +)
    let sumSqX = sqX.reduce(CGFloat(0), +)
    let sumX = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x
    }
    let sumXLogY = points.reduce(CGFloat(0)) { (sum, point) in
        sum + point.x * log(point.y)
    }
    let sqSumX = sumX * sumSqX
    let a = (sumLogY * sumSqX - sumX * sumLogY) / (n * sumSqX - sqSumX)
    let b = (n * sumXLogY - sumX * sumLogY) / (n * sumSqX - sqSumX)
    let _y = {x in exp(a) * exp(b * x)}
    return (
        x: {y in (-a + log(y)) / b},
        y: _y,
        a: exp(a),
        b: b,
        mse: mse(y: _y, points: points)
    )
}
