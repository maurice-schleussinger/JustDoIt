//
//  AddGoalViewController.swift
//  JustDoIt
//
//  Created by Some one on 27/12/15.
//  Copyright © 2015 Some one. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class AddGoalViewController: UIViewController {
    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet var frequencyTextField: UITextField!
    @IBOutlet var finishAddGoalButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    var goals = [NSManagedObject]()
    
    
    // Code for dismissing the keyboard on tap is taken from http://stackoverflow.com/a/27079103/2175370
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(sender)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // dismiss the current view when cancel is pressed
        self.dismissViewControllerAnimated(true, completion: {})
    }
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
            print (sender)
            //
            goals.append(goal)
            // dismiss the current view when finish is pressed
            self.dismissViewControllerAnimated(true, completion: {})
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
