//
//  SMVEngine.swift
//  SMV
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

/// Class encapsulating the main logic of the SM-5 algorithm.
public final class SMVEngine {
    
    var requestedFI: CGFloat = 0.0
    
    /// Initialise an instance.
    fileprivate init() {}
    
}

extension SMVEngine {
    static let shared = SMVEngine()
}
