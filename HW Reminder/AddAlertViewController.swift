//
//  AddAlertViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/18/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class AddAlertViewController: UIViewController, UITextFieldDelegate {
    
    var newAlert: Alert?
    var alerts = [Alert]()
    
    @IBOutlet weak var alertName: UITextField!
    @IBOutlet weak var alertTime: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        alertName.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var count = 1
        if let loadedAlerts = loadAlerts() {
            alerts = loadedAlerts
            count = alerts.count+1
        }
        var newAlertName = "Alert"
        if alertName.text == nil || alertName.text == ""{
            newAlertName = "Alert \(count)"
        } else {
            newAlertName = alertName.text!
        }
        newAlert = Alert(alertName: newAlertName, time: alertTime.date, alertOn: true)
    }

    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
    
    private func loadAlerts() -> [Alert]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alert.ArchiveURL.path) as? [Alert]
    }
    private func saveAlerts(){
        NSKeyedArchiver.archiveRootObject(alerts, toFile: Alert.ArchiveURL.path)
    }
}
