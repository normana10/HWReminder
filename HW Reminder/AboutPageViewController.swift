//
//  AboutPageViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 2/7/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit

class AboutPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Donate(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.paypal.me/normandconsulting")! as URL)
    }
    
    @IBAction func normandConsulting(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.normandconsulting.com")! as URL)
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
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
