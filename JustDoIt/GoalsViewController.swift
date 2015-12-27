//
//  GoalsViewController.swift
//  JustDoIt
//
//  Created by Some one on 20/12/15.
//  Copyright © 2015 Some one. All rights reserved.
//

import Foundation
import UIKit



class GoalsViewController: UICollectionViewController {

    @IBOutlet var addGoalButton: UIBarButtonItem!
    
    private let reuseIdentifier = "GoalCell"
    var fakeData = [1,2,3,4]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        GoalsViewController.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeData.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        print ("numberOfSectionsInCollectionView got called")
        return 1
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                print ("cellForItemAtIndexPath got called")
        let cell: GoalCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! GoalCell
        cell.CellLabel.text = String(fakeData[indexPath.row])
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print(indexPath)
    }
    
    @IBAction func addGoalButtonPressed(sender: AnyObject) {

        fakeData.append(random())
        print(fakeData)
    }
    
}
