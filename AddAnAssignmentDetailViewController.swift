//
//  AddAnAssignmentDetailViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/17/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class AddAnAssignmentDetailViewController: UIViewController, UITextFieldDelegate {
    
    var classes = [Class]()
    var assignments = [Assignment]()
    var newAssignment: Assignment?
    
    var newClass: Class?
    var selectedPriority = 2
    let bigFont: CGFloat = 28.0
    let smallFont: CGFloat = 18.0
    
    var repeating = false
    var repeatTo = Date()
    
    @IBOutlet weak var ClassImage: UIImageView!
    @IBOutlet weak var className: UILabel!
    @IBOutlet weak var assignmentName: UITextField!
//    @IBOutlet weak var prioritySelector: UISegmentedControl!
    @IBOutlet weak var assignmentDate: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var repeatDatePicker: UIDatePicker!
    @IBOutlet weak var RepeatSwitch: UISwitch!
    @IBOutlet weak var importantChooser: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ClassImage.image = newClass?.image
        className.text = newClass?.name
        
        saveButton.isEnabled = false
        
        assignmentName.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func repeatSwitched(_ sender: UISwitch) {
        let switchRepeat = sender.isOn
        repeatDatePicker.isHidden = !switchRepeat
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        assignmentName.resignFirstResponder()
        if !(assignmentName.text?.isEmpty)! {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if !(assignmentName.text?.isEmpty)! {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let button = sender as! UIBarButtonItem
        if button != saveButton {
            return
        }
        newAssignment = Assignment(name: assignmentName.text!, className: newClass!.shortName, dueDate: assignmentDate.date, important: importantChooser.selectedSegmentIndex)
        repeating = RepeatSwitch.isOn
        repeatTo = repeatDatePicker.date
    }
    
    @IBAction func Save(_ sender: UIBarButtonItem) {
//        let assignDate = assignmentDate.date
//        let cal = Calendar.current
//        var assignDateComponents = cal.dateComponents(in: .current, from: assignDate)
//        assignDateComponents.setValue(23, for: .hour)
//        assignDateComponents.setValue(59, for: .minute)
//        assignDateComponents.setValue(59, for: .second)
//        print("THIS HAPPENED?")
//        assignments += [Assignment(name: assignmentName.text!, className: newClass!.shortName, dueDate: assignDateComponents.date!)]
//        saveAssignments()
//        dismiss(animated: true, completion: nil)
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
//        NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path)
        assignments.remove(at: 0)
        NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path)
    }
}











