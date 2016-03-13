
import Foundation
import UIKit


class AchievementsCollectionViewController: UICollectionViewController {
    let achievements = [
        //        generall achievements
        ["id":"None1","name":"Great start!", "category":"None", "points":50, "description": "Achieve your first goal.", "criteria":1],
        ["id":"None2","name":"Keeping it up", "category":"None", "points":100, "description": "Achieve any 20 goals.", "criteria":20],
        ["id":"None3","name":"I can do this all day!", "category":"None", "points":200, "description": "Achieve any 100 goals.", "criteria":20],
        //        health achievements
        ["id":"Health1","name":"Meet up!", "category":"Health", "points":50, "description": "Achieve your first health goal.", "criteria":1],
        ["id":"Health2","name":"People person", "category":"Health", "points":100,"description": "Achieve a health goal 10 times.", "criteria":10],
        ["id":"Health3","name":"Socializer", "category":"Health", "points":200, "description": "Achieve a health goal 50 times.", "criteria":50],
        //        home achievements
        ["id":"Home1", "name":"I know this place", "category":"Home", "points":50, "description": "Achieve a home goal 5 times.", "criteria":1],
        ["id":"Home2", "name":"Home sweet home", "category":"Home", "points":100,"description": "Achieve a home goal 10 times.", "criteria":10],
        ["id":"Home3", "name":"Forever at home!", "category":"Home", "points":200, "description": "Achieve a home goal 50 times.", "criteria":50],
        //        private achievements
        ["id":"Privat1", "name":"Lets make me better!", "category":"Privat", "points":50, "description": "Achieve a privat goal 5 times.", "criteria":1],
        ["id":"Privat2", "name":"All about me.", "category":"Privat", "points":100,"description": "Achieve a privat goal 10 times.", "criteria":10],
        ["id":"Privat3", "name":"I, infinite!", "category":"Privat", "points":200, "description": "Achieve a privat goal 50 times.", "criteria":50]
    ]
    let reuseIdentifier = "AchievementCell"
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achievements.count
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AchievementCollectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AchievementCollectionCell
        let         achievement = self.achievements[indexPath.row]
        cell.CellLabel.text = String(achievement["name"]!)
        let achievedAchievements = NSUserDefaults.standardUserDefaults().arrayForKey("achievedAchievements") as! [String]
        
        if achievedAchievements.contains("\(achievement["id"]!)"){
            cell.CellImage.alpha = 1
            cell.CellLabel.alpha = 1
        }
        else{
            cell.CellImage.alpha = 0.3
            cell.CellImage.alpha = 0.3
            
        }
        
        
        cell.CellImage.image = UIImage(named: "\(achievement["category"]!).png")
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        TODO: open View with details
    }
    
    
}