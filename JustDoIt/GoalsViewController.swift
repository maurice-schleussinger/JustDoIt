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
   
    
    @IBAction func addGoalPressed(sender: AnyObject) {
    }
    
    
}



extension GoalsViewController {
    
    //1
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fakeData.count
    }
    
    //2
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
}