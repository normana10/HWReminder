//
//  ManageClasssesTableViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/17/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class ManageClasssesTableViewController: UITableViewController {
    
    var classes = [Class]()
    var assignments = [Assignment]()
    var delClass: Class?
    var delIndex: IndexPath?
    var editIndex: Int?
    var editClass: Class?
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let loadedClasses = loadClasses() {
            classes += loadedClasses
        } else {
            classes += loadSampleClasses()
            saveClasses()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
//    @IBAction func Cancel(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func unwindToClassList(sender: UIStoryboardSegue){
        if let source = sender.source as? NameClassViewController, let newClass = source.newClass {
            let newIndexPath = IndexPath(row: classes.count, section: 0)
            classes.append(newClass)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            tableView.reloadData()
            saveClasses()
        }
    }
    
    @IBAction func undwindFromEditClassToClassList(sender: UIStoryboardSegue){
        let source = sender.source as! ClassDetailViewViewController
        classes.remove(at: source.editIndex!)
        classes.append(editClass!)
        saveClasses()
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ManageClassesTableViewCell", for: indexPath) as? ManageClassesTableViewCell else {
            fatalError()
        }

        // Configure the cell...
        let currentClass = classes[indexPath.row]
        cell.ClassName.text = currentClass.name
        cell.ClassShortname.text = currentClass.shortName
        cell.ClassImage.image = currentClass.image
        
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            delClass = classes[indexPath.row]
            delIndex = indexPath
            confirmDelete()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    private func confirmDelete(){
        let deleteAlert = UIAlertController(title: "Are you sure you want to delete \(delClass!.name)?", message: "If you delete this class, all Assignments for this class will be deleted", preferredStyle: UIAlertControllerStyle.actionSheet)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: pressedDelete))
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: pressedCancel))
        self.present(deleteAlert, animated: true, completion: nil)
    }
    private func pressedDelete(alertAction: UIAlertAction) -> Void{
        assignments = loadAssignments()!
        for assign in assignments {
            if assign.className == delClass!.shortName {
                assignments.remove(at: assignments.index(of: assign)!)
            }
        }
        saveAssignments()
        classes.remove(at: delIndex!.row)
        saveClasses()
        tableView.deleteRows(at: [delIndex!], with: .fade)
    }
    private func pressedCancel(alertAction: UIAlertAction){
        tableView.reloadData()
        delClass = nil
        delIndex = nil
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if sender as? UIBarButtonItem == backButton {
            let sendingTo = segue.destination as! MainTableViewController
            sendingTo.assignments = loadAssignments()!
            sendingTo.tableView.reloadData()
        }
        if ((sender as? ManageClassesTableViewCell) != nil) {
            let movingTo = segue.destination as! ClassDetailViewViewController
            movingTo.currClass = classes[(tableView.indexPath(for: sender as! ManageClassesTableViewCell)?.row)!]
            movingTo.editIndex = (tableView.indexPath(for: sender as! ManageClassesTableViewCell)?.row)!
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 
    private func loadSampleAssignments() -> [Assignment]{
        var assigns = [Assignment]()
        
        //        let cal = Calendar(identifier: .gregorian)
        let oneDay = Double(60*60*24)
        let date1 = Date().addingTimeInterval(oneDay)
        let date2 = Date().addingTimeInterval(oneDay*7)
        let date3 = Date().addingTimeInterval(oneDay*14)
        
        let assign1 = Assignment(name: "Project 6", className: "CS 220", dueDate: date1, important: 0)
        let assign2 = Assignment(name: "Take notes on Ch 6", className: "CS 220", dueDate: date2, important: 1)
        let assign3 = Assignment(name: "TEST", className: "MATH 233", dueDate: date3, important: 1)
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
