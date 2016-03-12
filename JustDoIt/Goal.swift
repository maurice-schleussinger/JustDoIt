//
//  Goal.swift
//  JustDoIt
//
//  Created by Some one on 11/03/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import CoreData

class Goal: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var frequencyType: String
    @NSManaged var frequencyValue: NSNumber
    @NSManaged var currentProgress: NSNumber
    @NSManaged var totalAchieved: NSNumber
    
    @NSManaged var currentStreak: NSNumber
    @NSManaged var bestStreak: NSNumber
    
    @NSManaged var lastAchieved: NSDate?
    @NSManaged var nextDue: NSDate
    
    
}