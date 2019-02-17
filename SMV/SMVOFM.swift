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
fileprivate func afFromIndex(a: CGFloat)-> CGFloat
{
    return a * NOTCH_AF + MIN_AF
}
fileprivate func repFromIndex(r: CGFloat)-> CGFloat
{
    return r + INITIAL_REP_VALUE
}

// MARK: SMVOFM
class SMVOFM {
    
    let sm: SMVEngine
    
    init(sm: SMVEngine) {
        self.sm = sm
        update()
    }
    
    func update() {
    }
}
