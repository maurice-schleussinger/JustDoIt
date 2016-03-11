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

class FinishAddGoalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var frequencyType: UISegmentedControl!
    
    @IBOutlet var frequencyValuePicker: UIPickerView!
    
    @IBOutlet var finishAddGoalButton: UINavigationItem!
    
    
    
    // define some constants for avaiable frequency types and values
    let frequencyTypes = ["day","week","month"]
    let frequencyValues = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20]
    let dayInSeconds = Double(86400)
    var goalName = ""
    var goalCategory = ""
    
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.frequencyValuePicker.dataSource = self;
        self.frequencyValuePicker.delegate = self;
        
        
        // Code for dismissing the keyboard on tap is taken from http://stackoverflow.com/a/27079103/2175370
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // the UIPickerView has 1 component
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    // return the corresponding array count for component 1 or 2 (frequency type or value)
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return frequencyValues.count
    }
    
    // return the corresponding array value for component 1 or 2 (frequency type or value)
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(frequencyValues[row])"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(sender)
    }
    
    
    @IBAction func finishAddGoalButtonPressed(sender: AnyObject) {
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Goal",
            inManagedObjectContext:managedContext)
        
        let goal = Goal(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        
        let frequency = Double(frequencyValues[self.frequencyValuePicker.selectedRowInComponent(0)])
        let frequencyType = "\(frequencyTypes[self.frequencyType.selectedSegmentIndex])"
        print("finish button pressed.")
        print("frequency: \(frequency) frequencyType: \(frequencyType)")
        //        create an instance of the Goal class (which is a subclass of NSManagedObject
        goal.name = goalName
        goal.category = goalCategory
        goal.frequencyType = frequencyType
        goal.frequencyValue = frequency
        goal.nextDue = NSDate()
        
        do {
            try managedContext.save()
            //
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        // dismiss the current view when goal creation is completed
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
