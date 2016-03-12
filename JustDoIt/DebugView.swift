//
//  DebugView.swift
//  JustDoIt
//
//  Created by Some one on 11/03/16.
//  Copyright © 2016 Some one. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DebugView: UIViewController {
    var goals = [Goal]()
    
    @IBOutlet var debugTextView: UITextView!
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // dismiss the current view when cancel is pressed
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func viewDidLoad() {
        var output = "######### Number of goals: #########\n"
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Goal")
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            goals = results as! [Goal]
        } catch let error as NSError {
            //            should not happen at all
            print("Could not fetch \(error), \(error.userInfo)")
        }
        output = output + String(goals.count) + "\n"
        output = output + "######### Goals: #########\n" + String(goals) +  "\n######### local Notifications: #########\n"
        let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        output = output + String(localNotifications)
        debugTextView.text = output
        debugTextView.textColor = UIColor.greenColor()
        debugTextView.backgroundColor = UIColor.blackColor()
    }
    
}