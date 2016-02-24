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

class AddGoalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var goalNameTextField: UITextField!
    @IBOutlet var frequencyTextField: UITextField!
    
    @IBOutlet var frequencyTypeTextField: UITextField!
    @IBOutlet var frequencyTypePicker: UIPickerView!
    
    @IBOutlet var finishAddGoalButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    var goals = [NSManagedObject]()
    
    var frequencyTypes = ["day","week","month"]
    var frequencyNumbers = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20]
    
    
    // Code for dismissing the keyboard on tap is taken from http://stackoverflow.com/a/27079103/2175370
    override func viewDidLoad() {
        super.viewDidLoad()
        self.frequencyTypePicker.dataSource = self;
        self.frequencyTypePicker.delegate = self;
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
            
            return frequencyTypes.count
        }
        else {
            return frequencyNumbers.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 1 {
            return frequencyTypes[row]
        }
        else{
            return "\(frequencyNumbers[row])"
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            
            frequencyTypeTextField.text = frequencyTypes[row]
        }
        else{
            frequencyTextField.text = "\(frequencyNumbers[row])"
            
        }
        
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
    
    
    @IBAction func frequencyTypeFocused(sender: AnyObject) {
        print("frequencyTypeFocused")
        
        
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
            goals.append(goal)
            try managedContext.save()
            //
            // dismiss the current view when finish is pressed
            self.dismissViewControllerAnimated(true, completion: {})
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}
