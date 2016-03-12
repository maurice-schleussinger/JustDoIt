//
//  GoalsTableViewController.swift
//  JustDoIt
//
//  Created by Some one on 19/01/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation


class GoalsTableViewController : UITableViewController {
    
    let reuseIdentifier = "GoalTableCell"
    var goals = [Goal]()
    
    override func viewDidAppear(animated: Bool) {
        //        get the appDelegate and create a local managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        let sortDescriptor = NSSortDescriptor(key: "nextDue", ascending: true)
        let calendar = NSCalendar.currentCalendar()
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // try to get existing goals from the database
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [Goal]
            self.tableView.reloadData()
            
            
        } catch let error as NSError {
            //            should not happen at all
            print("Could not fetch \(error), \(error.userInfo)")
        }
        //        check if an goal is overdue by more than 1 of his frequencyType
        for goal in goals{
            var intervall = Double()
            let dayInSeconds = Double(86400)
            var calendarUnit = NSCalendarUnit.Day
            
            //            calculate nextDue based on frequency and frequencyType
            switch goal.frequencyType {
            case "Day":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue)
            case "Week":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue*7)
                calendarUnit = NSCalendarUnit.Day
            case "Month":
                intervall = Double(dayInSeconds/goal.frequencyValue.doubleValue*30)
                calendarUnit = NSCalendarUnit.Day
            default: break
            }
            print("intervall is \(intervall)")
            if calendar.compareDate(goal.nextDue, toDate: NSDate(timeIntervalSinceNow: intervall), toUnitGranularity: calendarUnit)  == NSComparisonResult.OrderedAscending{
                for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
                    // loop through
                    if notification.userInfo != nil{
                        if notification.userInfo!["name"] as! String == goal.name{
                            
                            
                            //                            BREAK
                            print("Overdue notification found for goal: \(goal.name)")
                        }
                        //                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        
        //        call parent function
        super.viewDidLoad()
        
    }
    // helper function to calculation the nextDue value for a given goal
    func calculateNextDue(goal:Goal){
        let dayInSeconds = Double(86400)
        let frequency = goal.frequencyValue.doubleValue
        let frequencyType = goal.frequencyType
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
        goal.nextDue = NSDate(timeIntervalSinceNow: Double(intervall + (intervall * goal.currentProgress.doubleValue)))
        
    }
    
    //    use prepareForeSegue to pass the calling Cell to the GoalDetailsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        check if the correct segue is called
        if segue.identifier == "ShowGoalDetail" {
            //            get reference to GoalDetailsViewController
            let goalDetailViewController = segue.destinationViewController as! GoalDetailsViewController
            if let selectedGoalCell = sender as? GoalTableCell {
                let indexPath = tableView.indexPathForCell(selectedGoalCell)!
                let selectedGoal = goals[indexPath.row]
                //                pass the goal of the corresponding cell
                goalDetailViewController.goal = selectedGoal
            }
        }
    }
    
    func saveChanges(){
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
        
    }
    //    cellForRowAtIndexPath
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableCell {
        //        create a cell
        let cell:GoalTableCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! GoalTableCell
        let goal = self.goals[indexPath.row]
        let calendar = NSCalendar.currentCalendar()
        //        set cell label to goal name
        cell.goalNameLabel.text = goal.name
        cell.categoryImageView.image = UIImage(named: "\(goal.category).png")
        print("goal: \(goal)")
        //        
        if  !calendar.isDateInToday(goal.nextDue) {
            cell.nextDueLabel.textColor = UIColor.lightGrayColor()
            cell.goalNameLabel.textColor = UIColor.lightGrayColor()
            cell.streakCountLabel.textColor = UIColor.lightGrayColor()
            cell.streakProgressView.progressTintColor = UIColor.lightGrayColor()
            
        }
        
        
        let formatter = NSDateFormatter()
        var nextDueString  = ""
        let dayInSeconds = Double(86400)
        let weekInSeconds = dayInSeconds * 7
        let oneWeekAhead = NSDate(timeIntervalSinceNow: weekInSeconds)
        
        if calendar.compareDate(goal.nextDue, toDate: NSDate(), toUnitGranularity: .Day)  == NSComparisonResult.OrderedAscending{
            nextDueString = "some time ago!!"
        }
        else if calendar.isDateInToday(goal.nextDue){
            nextDueString = "Today!"
        }
        else if calendar.isDateInTomorrow(goal.nextDue){
            nextDueString = "Tomorrow."
        }
        else if calendar.compareDate(goal.nextDue, toDate: oneWeekAhead, toUnitGranularity: .Minute)  == NSComparisonResult.OrderedAscending{
            formatter.dateFormat = "EEEE"
            nextDueString = formatter.stringFromDate(goal.nextDue)
            
        }
        else {
            formatter.dateFormat = "dd.MM."
            
            nextDueString = "the " + formatter.stringFromDate(goal.nextDue)
            
        }
        
        
        
        cell.nextDueLabel.text = "Next due to \(nextDueString)"
        cell.streakCountLabel.text = String("Streak of \(goal.currentStreak)")
        let percentValue = (goal.currentStreak.floatValue/goal.bestStreak.floatValue)
        print("  percentValue: \(percentValue)")
        cell.streakProgressView.setProgress(percentValue, animated: false)
        
        
        return cell
    }
    
    
    //#### EDIT ACTIONS FOR TABLE CELLS
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        //        Action to achieve a goal
        let archievedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal ,title: "Done") { (action, NSIndexPath) -> Void in
            
            //            get the corresponding goal and its current values
            let goal = self.goals[indexPath.row]
            //            increment currentStreak, alreadyAchieved
            goal.currentStreak = NSNumber(int: goal.currentStreak.intValue + 1)
            goal.totalAchieved = NSNumber(int: goal.totalAchieved.intValue + 1)
            goal.currentProgress = NSNumber(int: goal.currentProgress.intValue + 1)
            
            // set bestStreak to currentStreak if the value is now higher
            if goal.currentStreak.intValue > goal.bestStreak.intValue {
                goal.bestStreak = goal.currentStreak
                
            }
            goal.lastAchieved = NSDate()
            self.calculateNextDue(goal)
            
            self.saveChanges()
            
            // add a notification for the next due date of the goal
            let notification = UILocalNotification()
            notification.alertBody = "'\(goal.name)' is due today!"
            notification.fireDate = goal.nextDue
            notification.userInfo = ["name": goal.name]
            notification.soundName =  UILocalNotificationDefaultSoundName // play default sound
            //        TODO: whats this?
            notification.category = "TODO_CATEGORY"
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            
            print ("Goal archieved, streak counter incremented by +1.")
            self.tableView.reloadData()
            
        }
        //        change the color of the action to green
        archievedAction.backgroundColor = [#Color(colorLiteralRed: 0.2941176471, green: 0.8588235294, blue: 0.3607843137, alpha: 1)#]
        
        let skippedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Skip") { (action, NSIndexPath) -> Void in
            // maybe ask the user before breaking the streak
            let goal = self.goals[indexPath.row]
            //            reset the streak counter if the goal is skipped
            goal.currentProgress = NSNumber(int: goal.currentProgress.intValue + 1)
            goal.currentStreak = 0
            self.calculateNextDue(goal)
            
            self.saveChanges()
            print ("Goal skipped, streak counter set to 0.")
            self.tableView.reloadData()
            
            
        }
        return [archievedAction, skippedAction]
        
    }
    
    
}
