//
//  SMVSet.swift
//  SMV
//
//  Created by Zerui Chen on 20/2/19.
//  Copyright © 2019 Zerui Chen. All rights reserved.
//

import Foundation
import CoreData

@objc(SMVSet)
public class SMVSet: NSManagedObject
{
    
    lazy var itemsQueue = mutableArrayValue(forKey: "itemsQueueAny") as! [SMVItem]
    
    /// Finds the appropriate index in the queue to insert the given item with binary search.
    private func _findIndexToInsert(item: SMVItem, lowerI: Int = 0, upperI: Int = -1)-> Int
    {
        let actUpperI = upperI >= 0 ? upperI:itemsQueue.count-1
        if actUpperI == lowerI
        {
            return lowerI
        }
        let midI = (actUpperI + lowerI) / 2
        if itemsQueue[midI].dueDate! < item.dueDate!
        {
            return _findIndexToInsert(item: item, lowerI: midI + 1, upperI: actUpperI)
        }
        else
        {
            return _findIndexToInsert(item: item, lowerI: lowerI, upperI: midI - 1)
        }
    }
    
    /// Removes the item from the queue.
    private func removeFromQueue(item: SMVItem)
    {
        if let index = itemsQueue.firstIndex(of: item)
        {
            itemsQueue.remove(at: index)
        }
    }
    
    /// Inserts the item into the queue at the appropriate index, removing it first it's present.
    func insertIntoQueue(item: SMVItem)
    {
        removeFromQueue(item: item)
        itemsQueue.insert(item, at: _findIndexToInsert(item: item))
    }
    
    /// Create and add a new item into the queue.
    public func addItem(front: String, back: String)
    {
        let item = SMVItem(front: front, back: back, into: self)
        itemsQueue.insert(item, at: _findIndexToInsert(item: item))
    }
    
    /// Remove the item from the queue and delete it from CoreData.
    public func delete(item: SMVItem)
    {
        removeFromQueue(item: item)
        sCDHelper.delete(item: item)
    }
    
    /// Returns the next item which is past due date in the queue, nil if none.
    public func nextItem(isAdvanceable: Bool = false)-> SMVItem?
    {
        if itemsQueue.isEmpty
        {
            return nil
        }
        if isAdvanceable || itemsQueue[0].dueDate!.timeIntervalSinceNow < 0
        {
            return itemsQueue[0]
        }
        return nil
    }
    
    // MARK: Init
    /// Initialise a new set with the provided name and detail.
    convenience init(name: String, detail: String)
    {
        self.init(context: sCDHelper.viewContext)
        self.name = name
        self.detail = description
        self.creationDate = Date()
    }
    
    // MARK: Urgency
    public enum Urgency
    {
        /// overdue > 10
        case high
        /// 0 > overdue > 10
        case medium
        /// overdue == 0
        case low
    }
    
    /// Urgency sampling the first 10 items in queue.
    public var urgency: Urgency
    {
        let overdueCnt = itemsQueue.prefix(10).count(where: { (item) in
            item.dueDate!.timeIntervalSinceNow < 0
        })
        if overdueCnt > 10
        {
            return .high
        }
        if overdueCnt > 0
        {
            return .medium
        }
        return .low
    }
}
