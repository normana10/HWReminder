//
//  SelectAClassCollectionViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/17/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectAClassCollectionViewController: UICollectionViewController {
    
    var classes = [Class]()
    var assignments = [Assignment]()
    
    @IBOutlet weak var classesEmpty: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        classes += loadClasses()!
        
        if let loadedClasses = loadClasses() {
            classes = loadedClasses
        }
        
        if classes.isEmpty {
            classesEmpty.adjustsFontSizeToFitWidth = true
            classesEmpty.isHidden = false
        } else {
            classesEmpty.adjustsFontSizeToFitWidth = true
            classesEmpty.isHidden = true
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movingTo = segue.destination as! AddAnAssignmentDetailViewController
        let sentBy = sender as! SelectAClassCellCollectionViewCell
        
        movingTo.ClassImage = sentBy.Image
        movingTo.newClass = classes[(collectionView?.indexPath(for: sender as! SelectAClassCellCollectionViewCell)?.row)!]
        //FIGURE OUT HOW TO MAKE TAPPING IMAGE EFFECT NEXT FRAME
        
        
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return classes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectAClassCellCollectionViewCell", for: indexPath) as? SelectAClassCellCollectionViewCell else {
            fatalError()
        }
    
        // Configure the cell
        let currentClass = classes[indexPath.row]
        cell.Image.image = currentClass.image
        cell.ClassLabel.text = currentClass.shortName
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    private func loadSampleAssignments() -> [Assignment]{
        var assigns = [Assignment]()
        
        //        let cal = Calendar(identifier: .gregorian)
        let oneDay = Double(60*60*24)
        let date1 = Date().addingTimeInterval(oneDay)
        let date2 = Date().addingTimeInterval(oneDay*7)
        let date3 = Date().addingTimeInterval(oneDay*14)
        
        let assign1 = Assignment(name: "Project 6", className: "CS 220", dueDate: date1)
        let assign2 = Assignment(name: "Take notes on Ch 6", className: "CS 220", dueDate: date2)
        let assign3 = Assignment(name: "TEST", className: "MATH 233", dueDate: date3)
        assigns += [assign1, assign2, assign3]
        return assigns
    }
    private func loadSampleClasses() -> [Class]{
        var classes = [Class]()
        let class1 = Class(name: "Computer Science 220", image: UIImage(named: "Computer")!, shortName: "CS 220", notes: "")
        let class2 = Class(name: "Multivariable Caclulus", image: UIImage(named: "Math")!, shortName: "MATH 233", notes: "")
        classes += [class1, class2]
        return classes;
    }
    private func loadAssignments() -> [Assignment]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Assignment.ArchiveURL.path) as? [Assignment]
    }
    private func saveAssignments(){
        NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path)
    }
    private func loadClasses() -> [Class]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Class.ArchiveURL.path) as? [Class]
    }
    private func saveClasses(){
        NSKeyedArchiver.archiveRootObject(classes, toFile: Class.ArchiveURL.path)
    }
}
