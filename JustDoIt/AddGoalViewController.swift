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
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var goalCategoryPicker: UIPickerView!
    
    // define some constants for avaiable frequency types and values
    let frequencyTypes = ["day","week","month"]
    let frequencyValues = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,20]
    let dayInSeconds = Double(86400)
    let goalCategories = ["None", "Health", "Home", "Social", "Privat"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goalCategoryPicker.dataSource = self;
        self.goalCategoryPicker.delegate = self;
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
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return goalCategories.count
    }
    
    
    //    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    //        return "\(goalCategories[row])"
    //        
    //    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let category = goalCategories[row]
        
        let label = UILabel()
        label.text = "the cat is: \(category)"
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont.boldSystemFontOfSize(15)
        label.textColor = UIColor.blackColor()
        
        let image = UIImage(named: "\(category).png")
        let imageView = UIImageView(image: image)
        let rowView = UIView()
        
        //        rowView.addSubview(imageView)
        rowView.addSubview(label)
        return rowView
        
    }
    
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        // dismiss the current view when cancel is pressed
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    //    use prepareForeSegue to pass the calling Cell to the GoalDetailsViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //        check if the correct segue is called
        if segue.identifier == "AddGoalStep2" {
            //            get reference to GoalDetailsViewController
            let finishAddGoalViewController = segue.destinationViewController as! FinishAddGoalViewController
            //            pass goal name and category to the next ViewController
            finishAddGoalViewController.goalName = goalNameTextField.text!
            finishAddGoalViewController.goalCategory = goalCategories[goalCategoryPicker.selectedRowInComponent(0)]
        }
    }
    
    
    
}
