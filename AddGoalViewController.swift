//
//  AddGoalViewController.swift
//  JustDoIt
//
//  Created by Some one on 27/12/15.
//  Copyright © 2015 Some one. All rights reserved.
//

import UIKit
import CoreData


class AddGoalViewController: UIViewController {
    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet var frequencyTextField: UITextField!
    @IBOutlet var finishAddGoalButton: UIButton!
    var goals = [NSManagedObject]()

    
    @IBAction func finishAddGoalButtonPressed(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Goal",
            inManagedObjectContext:managedContext)
        
        let goal = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        goal.setValue(goalNameTextField.text, forKey: "name")
        
        do {
            try managedContext.save()
            //5
            goals.append(goal)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
//        TODO: Add values to database
        print(frequencyTextField.text)
    }
    
}
