//
//  GoalDetailsViewController.swift
//  JustDoIt
//
//  Created by Some one on 04/01/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class GoalDetailsViewController: UIViewController {
    var goal: NSManagedObject!
    
    @IBOutlet var goalNameLabel: UILabel!
    
    @IBOutlet var statsLabel: UILabel!
    @IBOutlet var frequencyValue: UILabel!
    
    @IBOutlet var lastAchieved: UILabel!
    @IBOutlet var frequencyType: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // test notifications
        let notification = UILocalNotification()
        notification.alertBody = "Todo Item  Is Overdue" // text that will be displayed in the notification
        notification.alertAction = "ok" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.fireDate = NSDate(timeIntervalSinceNow: 30) // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.category = "TODO_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        if let goal = goal {
            goalNameLabel.text = String(goal.valueForKey("name")!)
            frequencyValue.text = String(goal.valueForKey("frequencyValue")!)
            frequencyType.text = String(goal.valueForKey("frequencyType")!) + "!"
            let bestStreak = goal.valueForKey("bestStreak")!
            statsLabel.text = "So far I have archieved this goal \(bestStreak) times"
            let lastAchievedVal = goal.valueForKey("lastAchieved")
            if lastAchievedVal != nil {
                lastAchieved.text = String(lastAchievedVal!)
            }
            else {
                lastAchieved.text = ""
            }
        }
    }
}
