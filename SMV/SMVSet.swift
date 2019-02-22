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
    
    lazy var itemsQueue = mutableOrderedSetValue(forKey: "itemsQueueAny")
    
    public var numberOfItems: Int
    {
        return itemsQueue.count
    }
    
    /// Finds the appropriate index in the queue to insert the given item with binary search.
    private func _findIndexToInsert(item: SMVItem, lowerI: Int = 0, upperI: Int = -1)-> Int
    {
        if itemsQueue.count == 0
        {
            return 0
        }
        let actUpperI = upperI >= 0 ? upperI:itemsQueue.count-1
        if actUpperI == lowerI
        {
            return lowerI
        }
        let (midI, r) = (actUpperI + lowerI).quotientAndRemainder(dividingBy: 2)
        if (itemsQueue[midI] as! SMVItem).dueDate! > item.dueDate!
        {
            return _findIndexToInsert(item: item, lowerI: lowerI, upperI: midI - r)
        }
        else
        {
            return _findIndexToInsert(item: item, lowerI: midI + r, upperI: actUpperI)
        }
    }
    
    /// Removes the item from the queue.
    private func removeFromQueue(item: SMVItem)
    {
        itemsQueue.remove(item)
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
        insertIntoQueue(item: item)
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
        if itemsQueue.count == 0
        {
            return nil
        }
        if isAdvanceable || (itemsQueue[0] as! SMVItem).dueDate!.timeIntervalSinceNow < 0
        {
            return (itemsQueue[0] as! SMVItem)
        }
        return nil
    }
    
    /// Returns the item in the queue at the given index.
    public subscript(_ index: Int)-> SMVItem
    {
        return itemsQueue[index] as! SMVItem
    }
    
    // MARK: Init
    /// Initialise a new set with the provided name and detail.
    convenience init(name: String, detail: String)
    {
        self.init(context: sCDHelper.viewContext)
        self.name = name
        self.detail = detail
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
            (item as! SMVItem).dueDate!.timeIntervalSinceNow < 0
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
