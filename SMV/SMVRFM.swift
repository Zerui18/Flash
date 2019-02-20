//
//  SMVRFM.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

/// Retention-factor matrix.
class SMVRFM {
    
    init() {}
    
    func rf(repetition: Int, afIndex: Int)-> CGFloat
    {
        return sm.forgettingCurves.curves[repetition][afIndex].uf(retention: 100 - sm.requestedFI)
    }
}
