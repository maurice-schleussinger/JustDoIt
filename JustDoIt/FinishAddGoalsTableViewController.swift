

import UIKit
import CoreData


class FinishAddGoalViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var frequencyType: UISegmentedControl!
    
    @IBOutlet var frequencyValuePicker: UIPickerView!
    
    @IBOutlet var finishAddGoalButton: UINavigationItem!
    
    
    
    // define some constants for avaiable frequency types and values
    let frequencyTypes = ["Day","Week","Month"]
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
        //        create an instance of the Goal class (which is a subclass of NSManagedObject
        goal.name = goalName
        goal.category = goalCategory
        goal.frequencyType = frequencyType
        goal.frequencyValue = frequency
        //        set new goals to be due in one hour
        goal.nextDue = NSDate(timeIntervalSinceNow: -36000)
        
        do {
            try managedContext.save()
            //
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        //        #### NOTIFICATION ###
        // add a notification for the new goal
        let notification = UILocalNotification()
        notification.alertBody = "You can start with '\(goal.name)' today!"
        //        fire the notification in 1 hour
        notification.fireDate = NSDate(timeIntervalSinceNow: 3600)
        notification.userInfo = ["name": goal.name]
        // play the default sound notification sound
        notification.soundName =  UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        // dismiss the current view when goal creation is completed
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
