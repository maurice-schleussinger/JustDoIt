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
    var goals = [NSManagedObject]()
    
    override func viewDidAppear(animated: Bool) {
        //        get the appDelegate and create a local managedObjectContext
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        let sortDescriptor = NSSortDescriptor(key: "nextDue", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            // try to get existing goals from the database
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [NSManagedObject]
            self.tableView.reloadData()
            
            
        } catch let error as NSError {
            //            should not happen at all
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidLoad() {
        //        call parent func
        super.viewDidLoad()
        
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
        let goalName = String(goal.valueForKey("name")!)
        //        set cell label to goal name
        cell.goalNameLabel.text = goalName
        print("goalName: \(goalName)")
        //        set values for cell streak
        let currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber).floatValue
        let bestStreak = (goal.valueForKey("bestStreak")! as! NSNumber).floatValue
        
        let calendar = NSCalendar.currentCalendar()
        let nextDue = goal.valueForKey("nextDue") as! NSDate
        let formatter = NSDateFormatter()
        var nextDueString  = ""
        let dayInSeconds = Double(86400)
        let weekInSeconds = dayInSeconds * 7
        let oneWeekAhead = NSDate(timeIntervalSinceNow: weekInSeconds)
        
        if calendar.compareDate(nextDue, toDate: NSDate(), toUnitGranularity: .Day)  == NSComparisonResult.OrderedAscending{
            nextDueString = "some time ago!!"
        }
        else if calendar.isDateInToday(nextDue){
            nextDueString = "Today!"
            
        }
        else if calendar.isDateInTomorrow(nextDue){
            nextDueString = "Tomorrow."
        }
        else if calendar.compareDate(nextDue, toDate: oneWeekAhead, toUnitGranularity: .Minute)  == NSComparisonResult.OrderedAscending{
            formatter.dateFormat = "EEEE"
            nextDueString = formatter.stringFromDate(nextDue)
            
        }
        else {
            formatter.dateFormat = "the dd.MM."
            
            nextDueString = formatter.stringFromDate(nextDue)
            print(nextDueString)
            
        }
        
        
        
        cell.nextDueLabel.text = "Next due to \(nextDueString)"
        
        print("  currentStreak: \(currentStreak)")
        print("  bestStreak: \(bestStreak)")
        print("  frequencyType:\(goal.valueForKey("frequencyType"))")
        print("  frequencyValue:\(goal.valueForKey("frequencyValue"))")
        cell.streakCountLabel.text = String("\(Int(currentStreak))")
        
        let percentValue = (currentStreak/bestStreak)
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
            var currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber).shortValue
            var alreadyAchieved = (goal.valueForKey("alreadyAchieved")! as! NSNumber).shortValue
            let bestStreak = (goal.valueForKey("bestStreak")! as! NSNumber).shortValue
            print ("Current streak for this goal is \(currentStreak)")
            
            //            increment currentStreak, alreadyAchieved
            currentStreak++
            
            // set bestStreak to currentStreak if the value is now higher
            if currentStreak > bestStreak {
                goal.setValue(NSNumber(short: currentStreak), forKey: "bestStreak")
                
            }
            goal.setValue(NSDate(), forKey: "lastAchieved")
            goal.setValue(NSDate(), forKey: "nextDue")
            goal.setValue(NSNumber(short: currentStreak), forKey: "currentStreak")
            let dayInSeconds = 86400
            let frequency = goal.valueForKey("frequencyValue") as! Int
            let frequencyType = goal.valueForKey("frequencyType")! as! String
            
            //            calculate nextDue based on frequency and frequencyType
            switch frequencyType {
            case "day":
                goal.setValue(NSDate(timeIntervalSinceNow: Double(dayInSeconds / frequency)), forKey: "nextDue")
            case "week":
                goal.setValue(NSDate(timeIntervalSinceNow: Double((dayInSeconds * 7) / frequency)), forKey: "nextDue")
            case "month":
                goal.setValue(NSDate(timeIntervalSinceNow: Double(dayInSeconds * 30 / frequency)), forKey: "NextDue")
            default: break
                
            }
            
            self.saveChanges()
            
            
            print ("Goal archieved, streak counter incremented by +1.")
            self.tableView.reloadData()
        }
        //        change the color of the action to green
        archievedAction.backgroundColor = [#Color(colorLiteralRed: 0.2941176471, green: 0.8588235294, blue: 0.3607843137, alpha: 1)#]
        
        let skippedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Skip") { (action, NSIndexPath) -> Void in
            // maybe ask the user before breaking the streak
            let goal = self.goals[indexPath.row]
            //            reset the streak counter if the goal is skipped
            goal.setValue(NSNumber(short: Int16(0)), forKey: "currentStreak")
            goal.setValue(NSNumber(short: Int16(0)), forKey: "achievedCount")
            self.saveChanges()
            print ("Goal skipped, streak counter set to 0.")
            self.tableView.reloadData()
            
            
        }
        
        return [archievedAction, skippedAction]
    }
    
    
}
