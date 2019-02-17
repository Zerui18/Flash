//
//  SMVItem.swift
//  SMV
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

/// Represents a single vocab item.
@objc(SMVItem)
public final class SMVItem: NSManagedObject {
    
    
    
}

extension SMVItem {
    
    public class func new(vocab: String, def: String)-> SMVItem {
        let new = sCDHelper.newItem()
        new.vocab = vocab
        new.definition = def
        return new
    }
    
}
