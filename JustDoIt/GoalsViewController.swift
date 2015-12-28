//
//  GoalsViewController.swift
//  JustDoIt
//
//  Created by Some one on 20/12/15.
//  Copyright © 2015 Some one. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class GoalsViewController: UICollectionViewController {

    @IBOutlet var addGoalButton: UIBarButtonItem!
    
    private let reuseIdentifier = "GoalCell"
    var fakeData: [NSNumber] = []
    var goals = [NSManagedObject]()
    
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
            print(goals)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goals.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: GoalCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GoalCell
        cell.CellLabel.text = String(goals[indexPath.row].valueForKey("name")!)
        print (cell.CellLabel.text)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        TODO: open View with details
    }
    
//    @IBAction func addGoalButtonPressed(sender: AnyObject) {
////        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
////        let managedContext = appDelegate.managedObjectContext
////        
////        let fetchRequest = NSFetchRequest(entityName: "goal")
//
//        goals.append(Int(random()/10000))
//        self.collectionView?.reloadData()
//    }
//    
}
