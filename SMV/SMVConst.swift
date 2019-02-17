//
//  SMVConst.swift
//  SMV
//
//  Created by Zerui Chen on 17/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation

let RANGE_AF = 20
let RANGE_REPETITION = 20

let MIN_AF: CGFloat = 1.2
let NOTCH_AF: CGFloat = 0.3
let MAX_AF: CGFloat = MIN_AF + NOTCH_AF * (CGFloat(RANGE_AF) - 1)

let MAX_GRADE: CGFloat = 5
let THRESHOLD_RECALL: CGFloat = 3
