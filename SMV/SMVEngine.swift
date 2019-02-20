//
//  SMVEngine.swift
//  SMV
//
//  Created by Zerui Chen on 16/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

// MARK: SMVEngine
/// Manages all sets of items, as well as their shared statistics. Currently, one memory model is shared across all sets, based on the assumption that regardless of type, items with the same difficulty property will have identical memory factors.
public final class SMVEngine: Codable
{
    
    // MARK: Properties
    public var sets = [SMVSet]()
    var requestedFI: CGFloat = 10
    var intervalBase = 3 * 60 * 60.0
    
    // Lazily initialized to break initialization circle
    lazy var forgettingCurves = SMVForgettingCurves()
    lazy var rfm = SMVRFM()
    lazy var ofm = SMVOFM()
    lazy var fi_g = SMVFI_G()
    
    // MARK: Init
    /// Initialise an empty (fresh) instance.
    init() {
    }
    
    // MARK: Internal Methods
    /// Registers the update onto the forgettign curves and update ofm n fi_g, if item has non-negative repetition. (learnt)
    func update(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        if item.repetition >= 0
        {
            forgettingCurves.registerPoint(grade: grade, item: item, now: now)
            ofm.update()
            fi_g.update(grade: grade, item: item, now: now)
        }
    }
    
    // MARK: Public API
    /// Save an archive file of this SMVEngine onto disk, also saves its items with CoreData.
    public func saveToDisk() throws
    {
        try JSONEncoder().encode(self).write(to: archiveURL)
        sCDHelper.save()
    }
    
    /// Creates a new set with the provided name and description, append it into sets.
    public func createSet(named name: String, description detail: String)
    {
        sets.append(SMVSet(name: name, detail: detail))
    }
    
    // MARK: Codable Conformance
    enum CodingKeys: CodingKey
    {
        case requestedFI, intervalBase, fi_g, forgettingCurves
    }
    
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestedFI, forKey: .requestedFI)
        try container.encode(intervalBase, forKey: .intervalBase)
        try container.encode(fi_g, forKey: .fi_g)
        try container.encode(forgettingCurves, forKey: .forgettingCurves)
    }
    
    required public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sets = try sCDHelper.fetchAllSets()
        requestedFI = try container.decode(CGFloat.self, forKey: .requestedFI)
        intervalBase = try container.decode(TimeInterval.self, forKey: .intervalBase)
        fi_g = try container.decode(SMVFI_G.self, forKey: .fi_g)
        forgettingCurves = try container.decode(SMVForgettingCurves.self, forKey: .forgettingCurves)
    }
}

extension SMVEngine
{
    /// Singleton SMVEngine object. Loads archive if exists.
    public static var shared: SMVEngine =
    {
        if FileManager.default.fileExists(atPath: archiveURL.path)
        {
            let data = try! Data(contentsOf: archiveURL)
            return try! JSONDecoder().decode(SMVEngine.self, from: data)
        }
        else
        {
            return SMVEngine()
        }
    }()
}

/// Getter for SMVEngine.shared
let sm = SMVEngine.shared
fileprivate let archiveURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("SMV.json")
