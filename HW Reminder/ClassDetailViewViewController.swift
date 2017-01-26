//
//  ClassDetailViewViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/19/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class ClassDetailViewViewController: UIViewController {
    
    var currClass: Class?
    var editIndex: Int?
    var classes = [Class]()
//    
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var classShortName: UILabel!
    @IBOutlet weak var classNotes: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classImage.image = currClass?.image
        className.text = currClass?.name
        classShortName.text = currClass?.shortName
        classNotes.text = currClass?.notes
        classNotes.layer.borderWidth = 2.5
        classNotes.layer.borderColor = UIColor.gray.cgColor
        // Do any additional setup after loading the view.
    }

    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        classNotes.resignFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIBarButtonItem == saveButton {
            let movingTo = segue.destination as! ManageClasssesTableViewController
            movingTo.editClass = Class(name: (currClass?.name)!, image: (currClass?.image)!, shortName: (currClass?.shortName)!, notes: classNotes.text ?? "")
        } else if sender as? UITapGestureRecognizer != nil {
            let movingTo = segue.destination as! EditClassIconCollectionViewController
            movingTo.editClass = currClass
        }
    }
    
    @IBAction func unwindToClassDetails(sender: UIStoryboardSegue){
        classImage.image = currClass?.image
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadClasses() -> [Class]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Class.ArchiveURL.path) as? [Class]
    }
    private func saveClasses(){
        NSKeyedArchiver.archiveRootObject(classes, toFile: Class.ArchiveURL.path)
    }
}
