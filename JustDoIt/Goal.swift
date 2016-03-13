

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
    
    func calculateNextDue(){
        let dayInSeconds = Double(86400)
        let frequency = self.frequencyValue.doubleValue
        let frequencyType = self.frequencyType
        var intervall = Double()
        
        //            calculate nextDue based on frequency and frequencyType
        switch frequencyType {
        case "Day":
            intervall = Double(dayInSeconds/frequency)
        case "Week":
            intervall = Double(dayInSeconds/frequency*7)
        case "Month":
            intervall = Double(dayInSeconds/frequency*30)
        default: break
        }
        self.nextDue = NSDate(timeIntervalSinceNow: Double(intervall + (intervall * self.currentProgress.doubleValue)))
    }
}