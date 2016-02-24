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
    
    private let reuseIdentifier = "GoalTableCell"
    var goals = [NSManagedObject]()
    
    override func viewDidAppear(animated: Bool) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        
        do {
            
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [NSManagedObject]
            self.tableView.reloadData()
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableCell {
        let cell:GoalTableCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! GoalTableCell
        let goal = self.goals[indexPath.row]
        let goalName = String(goal.valueForKey("name")!)
        cell.goalNameLabel.text = goalName
        print("goalName: \(goalName)")
        
        let currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber).floatValue
        let bestStreak = (goal.valueForKey("bestStreak")! as! NSNumber).floatValue
        print("  currentStreak: \(currentStreak)")
        print("  bestStreak: \(bestStreak)")
        
        let percentValue = (currentStreak/bestStreak)
        print("  percentValue: \(percentValue)")
        print("")
        //        cell.streakProgressView.hidden = true
        //        cell.progressCounter.numberOfPoints = 5
        //        cell.streakCountLabel.hidden = false
        //        cell.streakProgressView.setProgress(0.5, animated: false)
        cell.streakCountLabel.text = String("\(Int(currentStreak))")
        
        return cell
    }
    
    
    //#### EDIT ACTIONS FOR TABLE CELLS
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let archievedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (action, NSIndexPath) -> Void in
            
            let goal = self.goals[indexPath.row]
            var currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber).shortValue
            let bestStreak = (goal.valueForKey("bestStreak")! as! NSNumber).shortValue
            print ("Current streak for this goal is \(currentStreak)")
            currentStreak++
            
            // set bestStreak to currentStreak if the value is now higher
            if currentStreak > bestStreak {
                goal.setValue(NSNumber(short: currentStreak), forKey: "bestStreak")
                
            }
            goal.setValue(NSNumber(short: currentStreak), forKey: "currentStreak")
            self.saveChanges()
            
            
            print ("Goal archieved, streak counter incremented by +1.")
            self.tableView.reloadData()
        }
        let skippedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Destructive, title: "Skip") { (action, NSIndexPath) -> Void in
            // maybe ask the user before breaking the streak
            let goal = self.goals[indexPath.row]
            //            reset the streak counter if the goal is skipped
            goal.setValue(NSNumber(short: Int16(0)), forKey: "currentStreak")
            self.saveChanges()
            print ("Goal skipped, streak counter set to 0.")
            self.tableView.reloadData()
            
            
        }
        
        return [archievedAction, skippedAction]
    }
    
    
}
