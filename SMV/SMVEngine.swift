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
/// Class encapsulating the main logic of the SM-15 algorithm.
public final class SMVEngine: Codable
{
    
    // MARK: Properties
    var requestedFI: CGFloat = 0.0
    var intervalBase = 3 * 60 * 60.0
    
    /// Items sorted by due date
    private var q = [SMVItem]()
    
    var forgettingCurves = SMVForgettingCurves()
    let rfm = SMVRFM()
    let ofm = SMVOFM()
    var fi_g: SMVFI_G!
    
    // MARK: Init
    /// Initialise an empty (fresh) instance.
    fileprivate init() {}
    
    // MARK: Private Methods
    /// Finds the appropriate index in the queue to insert the given item with binary search.
    private func _findIndexToInsert(item: SMVItem, lowerI: Int = 0, upperI: Int = -1)-> Int
    {
        let actUpperI = upperI >= 0 ? upperI:q.count-1
        if actUpperI == lowerI
        {
            return lowerI
        }
        let midI = (actUpperI + lowerI) / 2
        if q[midI].dueDate! < item.dueDate!
        {
            return _findIndexToInsert(item: item, lowerI: midI + 1, upperI: actUpperI)
        }
        else
        {
            return _findIndexToInsert(item: item, lowerI: lowerI, upperI: midI - 1)
        }
    }
    
    private func _update(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        if item.repetition >= 0
        {
            forgettingCurves.registerPoint(grade: grade, item: item, now: now)
            ofm.update()
            fi_g.update(grade: grade, item: item, now: now)
        }
        item.answer(grade: grade, now: now)
    }
    
    /// Removes the item from the queue.
    private func removeFromQueue(item: SMVItem)
    {
        if let index = q.firstIndex(of: item)
        {
            q.remove(at: index)
        }
    }
    
    /// Inserts the item into the queue at the appropriate index, removing it first it's present.
    private func insertIntoQueue(item: SMVItem)
    {
        removeFromQueue(item: item)
        q.insert(item, at: _findIndexToInsert(item: item))
    }
    
    /// Create and add a new item into the queue.
    public func addItem(front: String, back: String)
    {
        let item = SMVItem.new(front: front, back: back)
        q.insert(item, at: _findIndexToInsert(item: item))
    }
    
    /// Returns the next item which is past due date in the queue, nil if none.
    public func nextItem(isAdvanceable: Bool = false)-> SMVItem?
    {
        if q.isEmpty
        {
            return nil
        }
        if isAdvanceable || q[0].dueDate!.timeIntervalSinceNow < 0
        {
            return q[0]
        }
        return nil
    }
    
    /// Inform the engine that the specified item has been answered.
    public func answer(grade: CGFloat, item: SMVItem, now: Date = Date())
    {
        _update(grade: grade, item: item, now: now)
        insertIntoQueue(item: item)
    }
    
    /// Save an archive file of this SMVEngine onto disk, also saves its items with CoreData.
    func saveToDisk() throws
    {
        try JSONEncoder().encode(self).write(to: archiveURL)
        sCDHelper.save()
    }
    
    // MARK: Codable Conformance
    enum CodingKeys: CodingKey
    {
        case requestedFI, intervalBase, fi_g, forgettingCurves
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestedFI, forKey: .requestedFI)
        try container.encode(intervalBase, forKey: .intervalBase)
        try container.encode(fi_g, forKey: .fi_g)
        try container.encode(forgettingCurves, forKey: .forgettingCurves)
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        q = try sCDHelper.fetchSortedItems()
        requestedFI = try container.decode(CGFloat.self, forKey: .requestedFI)
        intervalBase = try container.decode(TimeInterval.self, forKey: .intervalBase)
        fi_g = try container.decode(SMVFI_G.self, forKey: .fi_g)
        forgettingCurves = try container.decode(SMVForgettingCurves.self, forKey: .forgettingCurves)
    }
}

extension SMVEngine
{
    /// Singleton SMVEngine object. Loads archive if exists.
    static let shared: SMVEngine = {
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
