//
//  SMVOFM.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

// MARK: Constants
fileprivate let INITIAL_REP_VALUE: CGFloat = 1

fileprivate func afFromIndex(a: Int)-> CGFloat
{
    return CGFloat(a) * NOTCH_AF + MIN_AF
}

/// Repetition value used for regression
fileprivate func repFromIndex(r: Int)-> CGFloat
{
    return CGFloat(r) + INITIAL_REP_VALUE
}

// MARK: SMVOFM
/// Optimum Factor Matrix
class SMVOFM
{
    
    // MARK: Properties
    var af: CGFloat!
    var of: CGFloat!
    
    // MARK: TMP Variables
    private var _decay: RegressionModel?
    private var _ofm0: RegressionModelER?
    
    // MARK: Init
    init()
    {
        update()
    }
    
    // MARK: Methods
    func update()
    {
        // D-factor (a/p^b): the basis of decline of O-Factors, the decay constant of power approximation along RF matrix columns
        var dfs = (0..<RANGE_AF).map { (a) in
            fixedPointPowerLawRegression(points: (1..<RANGE_REPETITION).map({ (r) in
                CGPoint(x: repFromIndex(r: r), y: sm.rfm.rf(repetition: r, afIndex: a))
            }), fixedPoint: CGPoint(x: repFromIndex(r: 1), y: afFromIndex(a: a))).b
        }
        dfs = (0..<RANGE_AF).map {a in
            afFromIndex(a: a) / pow(2, dfs[a])
        }
        
        _decay = linearRegression(points: (0..<RANGE_AF).map({ (a) in
            CGPoint(x: CGFloat(a), y: dfs[a])
        }))
        _ofm0 = exponentialRegression(points: (0..<RANGE_AF).map({ (a) in
            CGPoint(x: CGFloat(a), y: sm.rfm.rf(repetition: 0, afIndex: a))
        }))
    }
    
    func _ofm(a: Int)-> (x: OneToOneFunc, y: OneToOneFunc)?
    {
        guard let decay = _decay else {
            return nil
        }
        let af = afFromIndex(a: a)
        let b = log(af / decay.y(CGFloat(a))) / log(repFromIndex(r: 1))
        let model = powerLawModel(a: af / pow(repFromIndex(r: 1), b), b: b)
        return (
            x: {y in model.x(y) - INITIAL_REP_VALUE},
            y: {r in model.y(repFromIndex(r: Int(r)))}
        )
    }
    
    func _ofm0(a: CGFloat)-> CGFloat?
    {
        return _ofm0?.y(a)
    }
    
    func of(repetition: Int, afIndex: Int)-> CGFloat?
    {
        if repetition == 0 {
            return _ofm0(a: CGFloat(afIndex))
        }
        else {
            return _ofm(a: afIndex)?.y(CGFloat(repetition))
        }
    }
    
    /// Obtain corresponding A-Factor (column) from n (row) and value
    func af(repetition: Int, of_: CGFloat)-> CGFloat?
    {
        // Checks if of() will return nil
        guard _ofm0 != nil else {
            return nil
        }
        let id = (0..<RANGE_AF).reduce(0) { (I, i) in
            let a = self.of(repetition: repetition, afIndex: I)! - of_
            let b = self.of(repetition: repetition, afIndex: i)! - of_
            return a < b ? I:i
        }
        return afFromIndex(a: id)
    }
}

// Note:
/*
 In the original implementation, there's js magic (or non-sense lol) to dynamically add function to `this` in call to update, these functions access local variables in the update call. This is translated as tmp variables (which store the update's calculations) and direct member methods (instead of dynamically added methods...), as well as use of optionals instead of checking whether the methods have been "added" to determine whether update has been called.
 */
