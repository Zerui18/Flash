//
//  SMVItem.swift
//  SMV
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

let MAX_AFS_COUNT = 30

/// Represents a single vocab item.
@objc(SMVItem)
public final class SMVItem: NSManagedObject
{
    
    /// Convenient getter & setter for afs_, ensures afs_ is never nil, afs_ does not exceed MAX_AFS_COUNT.
    var _afs: [CGFloat]
    {
        get
        {
            if afs_ == nil
            {
                afs_ = []
            }
            return afs_!
        }
        set
        {
            afs_ = newValue.suffix(MAX_AFS_COUNT)
        }
    }
    
    func interval(now: Date = Date())-> TimeInterval
    {
        if previousDate == nil
        {
            return SMVEngine.shared.intervalBase
        }
        return now.timeIntervalSince(previousDate!)
    }
    
    func uf(now: Date = Date())-> CGFloat
    {
        let z = optimumInterval / of
        return CGFloat(interval(now: now) / z)
    }
    
    func af(value: CGFloat? = nil)-> CGFloat
    {
        guard let value = value else
        {
            return CGFloat(af_)
        }
        let a = round((value - MIN_AF) / NOTCH_AF)
        af_ = Double(max(MIN_AF, min(MAX_AF, MIN_AF + a * NOTCH_AF)))
        return CGFloat(af_)
    }
    
    func afIndex()-> Int
    {
        let afs = (0..<RANGE_AF).map { (i) in
            MIN_AF + CGFloat(i) * NOTCH_AF
        }
        return (0..<RANGE_AF).reduce(0, { (I, i) in
            let a = abs(self.af() - afs[I])
            let b = abs(af() - afs[i])
            return a < b ? I:i
        })
    }
    
    /// Obtain optimum interval
    func _I(now: Date = Date())
    {
        let afI = repetition == 0 ? Int(lapse):afIndex()
        guard let of_ = sm.ofm.of(repetition: Int(repetition), afIndex: afI) else
        {return}
        of = Double(max(1, (of_ - 1) * CGFloat(interval(now: now) / optimumInterval) + 1))
        optimumInterval = round(optimumInterval * of)
        previousDate = now
        dueDate = Date(timeIntervalSinceNow: optimumInterval)
    }
    
    @discardableResult
    func _updateAF(grade: CGFloat, now: Date = Date())-> CGFloat
    {
        var estimatedFI = max(1, sm.fi_g.fi(grade: grade))
        let correctedUF = uf(now: now) * (sm.requestedFI / estimatedFI)
        if repetition > 0
        {
            estimatedFI = sm.ofm.af(repetition: Int(repetition), of_: correctedUF)!
        }
        else
        {
            estimatedFI = max(MIN_AF, min(MAX_AF, correctedUF))
        }
        _afs.append(estimatedFI)
        let weightedSum = _afs.reduce(CGFloat(0)) { (a, i) in
            a * CGFloat(i + 1)
        }
        let ave = weightedSum / CGFloat((1 + _afs.count) * _afs.count / 2)
        return af(value: ave)
    }
    
    func answer(grade: CGFloat, now: Date = Date())
    {
        if repetition >= 0
        {
            _updateAF(grade: grade, now: now)
        }
        if grade >= THRESHOLD_RECALL
        {
            if repetition < RANGE_REPETITION - 1
            {
                repetition += 1
            }
            _I(now: now)
        }
        else
        {
            if lapse < RANGE_AF - 1
            {
                lapse += 1
            }
            optimumInterval = sm.intervalBase
            previousDate = nil
            dueDate = now
            repetition = -1
        }
    }
}

extension SMVItem
{
    
    public class func new(front: String, back: String)-> SMVItem
    {
        let new = sCDHelper.newItem()
        new.front = front
        new.back = back
        return new
    }
    
}
