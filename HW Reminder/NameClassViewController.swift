//
//  NameClassViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/17/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class NameClassViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var Save: UIBarButtonItem!
    @IBOutlet weak var classNAme: UITextField!
    @IBOutlet weak var classShortName: UITextField!
    @IBOutlet weak var classImage: UIImageView!
    @IBOutlet weak var notesField: UITextView!
    var newClass: Class?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classImage.image = newClass?.image
        notesField.layer.borderWidth = 2.5
        notesField.layer.borderColor = UIColor.gray.cgColor
        
        Save.isEnabled = false
        classNAme.delegate = self
        classShortName.delegate = self
        notesField.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func screenTapped(_ sender: UITapGestureRecognizer) {
        classNAme.resignFirstResponder()
        classShortName.resignFirstResponder()
        notesField.resignFirstResponder()
        if !(classNAme.text?.isEmpty)! && !(classShortName.text?.isEmpty)! {
            Save.isEnabled = true
        } else {
            Save.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        if !(classNAme.text?.isEmpty)! && !(classShortName.text?.isEmpty)! {
            Save.isEnabled = true
        } else {
            Save.isEnabled = false
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let button = sender as! UIBarButtonItem
        if button != Save {
            return
        }
        let nam = classNAme.text ?? ""
        let shortName = classShortName.text ?? ""
        let img = classImage.image!
        let notes = notesField.text ?? ""
        newClass = Class(name: nam, image: img, shortName: shortName, notes: notes)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
