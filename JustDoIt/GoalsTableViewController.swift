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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        
        self.tableView.reloadData()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        Fetch existing goals from CoreData
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        do {
            let results =
            try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> GoalTableCell {
        let cell:GoalTableCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)  as! GoalTableCell
        let goal = self.goals[indexPath.row]
        
        cell.goalNameLabel.text = String(goal.valueForKey("name")!)
        let currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber)
        
        cell.streakCountLabel.text = String(currentStreak.stringValue)
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let archievedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Done") { (action, NSIndexPath) -> Void in
            
            
            let goal = self.goals[indexPath.row]
            var currentStreak = (goal.valueForKey("currentStreak")! as! NSNumber).shortValue
            let bestStreak = (goal.valueForKey("bestStreak")! as! NSNumber).shortValue
            print ("Current streak for this goal is \(currentStreak)")
            currentStreak++
            
            //            set bestStreak to currentStreak if the value is now higher
            if currentStreak > bestStreak {
                goal.setValue(NSNumber(short: currentStreak), forKey: "bestStreak")
                
            }
            goal.setValue(NSNumber(short: currentStreak), forKey: "currentStreak")
            //            do {
            //                try managedContext.save()
            //            } catch let error as NSError  {
            //                print("Could not save \(error), \(error.userInfo)")
            //            }
            
            print ("Goal archieved, streak counter incremented by +1.")
        }
        let skippedAction:UITableViewRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "Skip") { (action, NSIndexPath) -> Void in
            // maybe ask the user before breaking the streak
            let goal = self.goals[indexPath.row]
            //            reset the streak counter if the goal is skipped
            goal.setValue(NSNumber(short: Int16(0)), forKey: "currentStreak")
            print ("Goal skipped, streak counter set to 0.")
            
            
        }
        
        return [archievedAction, skippedAction]
    }
    
    
}
