//
//  EditExistingAssignmentViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/26/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class EditExistingAssignmentViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var currentAssignmentName: UILabel!
    @IBOutlet weak var newAssignmentName: UITextField!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var importantPicker: UISegmentedControl!
    
    var assignments = [Assignment]();
    var currClassImage: UIImage?;
    var currAssignment: Assignment?;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let loadedAssignemnts = loadAssignments(){
            assignments = loadedAssignemnts
        }
        
        classImage.image = currClassImage;
        currentAssignmentName.text = currAssignment?.name;
        newAssignmentName.text = currAssignment?.name;
        classLabel.text = currAssignment?.className;
        dueDate.date = (currAssignment?.dueDate)!;
        importantPicker.selectedSegmentIndex = (currAssignment?.important)!;
        
        newAssignmentName.delegate = self;
        // Do any additional setup after loading the view.
    }

//    @IBAction func Back(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil);
//    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        newAssignmentName.resignFirstResponder()
        if !(newAssignmentName.text?.isEmpty)!{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        newAssignmentName.resignFirstResponder()
        if !(newAssignmentName.text?.isEmpty)!{
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    private func loadAssignments() -> [Assignment]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Assignment.ArchiveURL.path) as? [Assignment]
    }
    private func saveAssignments(){
        NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path)
    }
}
