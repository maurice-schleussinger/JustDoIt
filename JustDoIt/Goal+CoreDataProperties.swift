//
//  Goal+CoreDataProperties.swift
//  
//
//  Created by Some one on 11/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Goal {

    @NSManaged var alreadyAchieved: NSNumber?
    @NSManaged var bestStreak: NSNumber?
    @NSManaged var category: String?
    @NSManaged var currentStreak: NSNumber?
    @NSManaged var frequencyType: String?
    @NSManaged var frequencyValue: NSNumber?
    @NSManaged var lastAchieved: NSDate?
    @NSManaged var name: String?
    @NSManaged var nextDue: NSDate?
    @NSManaged var totalAchieved: NSNumber?

}
