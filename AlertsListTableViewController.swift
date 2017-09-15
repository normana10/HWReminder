//
//  AlertsListTableViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/18/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit
import UserNotifications

class AlertsListTableViewController: UITableViewController {
    
    var alerts = [Alert]()
    var assignments = [Assignment]()
    var newAlert: Alert?
    let MAX_NUMBER_ALERTS = 5
    
    @IBOutlet weak var newButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ALERT LIST LOADED")
        
        if let loadedAlerts = loadAlerts() {
            alerts += loadedAlerts
        }
        alerts.sort(by: sortTimes)
        if let loadedAssignments = loadAssignments() {
            assignments = loadedAssignments
        }
        if alerts.count >= MAX_NUMBER_ALERTS {
            newButton.isEnabled = false
        } else {
            newButton.isEnabled = true
        }
//        let header = UILabel()
//        header.text = "Alerted the Day Before Due at:"
//        tableView.tableHeaderView = header
        
        if #available(iOS 10.0, *) {
            updateAlertNotifications()
        } else {
            // Fallback on earlier versions
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    @available(iOS 10.0, *)
    @IBAction func alertSwitchSwitched(_ sender: UISwitch) {
        let cell = sender.superview?.superview as! AlertTableViewCell
//        print("Switched state in data from: \(alerts[tableView.indexPath(for: cell)!.row].alertOn) to \(sender.isOn)")
        alerts[tableView.indexPath(for: cell)!.row].alertOn = sender.isOn
        saveAlerts()
        updateAlertNotifications()
    }

    @IBAction func Cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        return alerts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertTableViewCell", for: indexPath) as! AlertTableViewCell
        
        let currAlert = alerts[indexPath.row]
        // Configure the cell...
        cell.AlertName.text = currAlert.alertName
        
        let dateFormat = DateFormatter()
        dateFormat.locale = Locale(identifier: "en_US")
        dateFormat.timeZone = TimeZone(abbreviation: "EST")
        dateFormat.dateFormat = "h:mma"
        cell.AlertTime.text = dateFormat.string(from: currAlert.time)
        cell.AlertActivated.isOn = currAlert.alertOn
        return cell
    }
    
    @IBAction func unwindToAlertLsit(sender: UIStoryboardSegue){
        let comingFrom = sender.source as! AddAlertViewController
        self.newAlert = comingFrom.newAlert
        let newIndexPath = IndexPath(item: alerts.count, section: 0)
        alerts.append(newAlert!)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
        alerts.sort(by: sortTimes)
        tableView.reloadData()
        saveAlerts()
        if #available(iOS 10.0, *) {
            updateAlertNotifications()
        } else {
            // Fallback on earlier versions
        }
        if alerts.count >= MAX_NUMBER_ALERTS {
            newButton.isEnabled = false
        } else {
            newButton.isEnabled = true
        }
    }
    private func sortTimes(alert1: Alert, alert2: Alert) -> Bool {
        let cal = Calendar.current
        let hr1 = cal.component(.hour, from: alert1.time)
        let min1 = cal.component(.minute, from: alert1.time)
        let hr2 = cal.component(.hour, from: alert2.time)
        let min2 = cal.component(.minute, from: alert2.time)
        if hr1 < hr2 {
//            print("\(alert1.alertName) is earlier than \(alert2.alertName)")
            return true
        } else if hr1 > hr2 {
//            print("\(alert1.alertName) is later than \(alert2.alertName)")
            return false
        } else {
            if min1 < min2 {
                return true
            } else {
                return false
            }
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("DELETING ALERT ROW \(indexPath.row)")
            // Delete the row from the data source
            alerts.remove(at: indexPath.row)
            saveAlerts()
            tableView.deleteRows(at: [indexPath], with: .fade)
            if #available(iOS 10.0, *) {
                updateAlertNotifications()
            } else {
                // Fallback on earlier versions
            }
            if alerts.count >= MAX_NUMBER_ALERTS {
                newButton.isEnabled = false
            } else {
                newButton.isEnabled = true
            }
//            updateAlertNotifications()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
    
    private func loadAssignments() -> [Assignment]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Assignment.ArchiveURL.path) as? [Assignment]
    }
    private func saveAssignments(){
        NSKeyedArchiver.archiveRootObject(assignments, toFile: Assignment.ArchiveURL.path)
    }
    
    //MARK: - update badge/notifications
    @available(iOS 10.0, *)
    private func updateBadgeNumber(){
        //        print("\n\nUPDATING BADGE NUMBER AND SETTING UPDATES FOR THIS WEEK")
        let notifCenter = UNUserNotificationCenter.current()
        var badgeNum = [0,0,0,0,0,0,0]
        for assign in assignments {
            let daysLefttoDue = DaysLeft(assignment: assign)
            if daysLefttoDue > 0 && daysLefttoDue < 7 {
                badgeNum[daysLefttoDue] += 1
            }
        }
        let app = UIApplication.shared
        app.applicationIconBadgeNumber = badgeNum[1]
        //        print("Badge should be \(badgeNum[1]) in 0 days")
        //Remove any old
        for i in 2...6 {
            notifCenter.removePendingNotificationRequests(withIdentifiers: ["HWReminder.updateBadgeAtMidnight\(i)"])
        }
        //        add new for next week
        for i in 2...6 {
            let content = UNMutableNotificationContent()
            let dueToday = badgeNum[i]
            content.title = "HW Reminder Badge Updated"
            content.badge = dueToday as NSNumber?
            content.categoryIdentifier = "HWReminder.badgeUpdater.\(i)"
            
            let cal = Calendar.current
            let secondsInDay: Double = 60*60*24*Double(i-1)
            let target = Date().addingTimeInterval(secondsInDay)
            let yr = cal.component(.year, from: target)
            let month = cal.component(.month, from: target)
            let day = cal.component(.day, from: target)
            let hr = 0
            let minute = 0
            let trigDate = DateComponents(calendar: cal, year: yr, month: month, day: day, hour: hr, minute: minute)
            
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
            //            print("Badge should be \(badgeNum[i]) in \(i-1) days left")
            //            print("And will trigger on: \(dateFormat.string(from: trigDate.date!))      and also has identifier: HWReminder.updateBadgeAtMidnight\(i)")
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: trigDate, repeats: false)
            let request = UNNotificationRequest(identifier: "HWReminder.updateBadgeAtMidnight\(i)", content: content, trigger: trigger)
            notifCenter.add(request, withCompletionHandler: nil)
        }
        //        print("\n\n\nSo just to recap Badges:")
        
        //        var notifs = [UNNotificationRequest]()
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {(lst) in
            //            print("I AM IMPOARTNANT    \(lst.count)      \(lst.first?.content.badge)      \(lst.first?.identifier)")
        }
        )
        //        for notif in notifs {
        //            if (notif.identifier.range(of: "HWReminder.updateBadge") != nil) {
        //                print("Badge will be \(notif.content.badge) At \((notif.trigger as! UNCalendarNotificationTrigger).dateComponents)")
        //            }
        //        }
        
    }
    
    @available(iOS 10.0, *)
    private func updateAlertNotifications(){
        
        let notificationsEnabled = UserDefaults.standard.bool(forKey: "Notifications Enabled")
        
        if notificationsEnabled {
            print("Notifications Enabled")
            if let loadedAlerts = loadAlerts() {
                alerts = loadedAlerts
            } else {
                return
            }
            if let loadedAssigns = loadAssignments() {
                assignments = loadedAssigns
            } else {
                return
            }
            
            let notifCenter = UNUserNotificationCenter.current()
            var arr = [String]()
            for dayNum in 1...7 {
                for alertNum in 1...5 {
                    arr += ["HWReminer.notification.\(dayNum).\(alertNum)"]
                }
            }
            notifCenter.removePendingNotificationRequests(withIdentifiers: arr)
            //            notifCenter.removeAllPendingNotificationRequests()
            
            var assignmentsByDay = [[Assignment](),[Assignment](),[Assignment](),[Assignment](),[Assignment](),[Assignment](),[Assignment](),[Assignment]()]
            for assign in assignments {
                let daysFromNow = DaysLeft(assignment: assign)
                if daysFromNow <= 7 && daysFromNow > 0{
                    assignmentsByDay[daysFromNow].append(assign)
                    print("Adding \(assign.name) because it's due \(daysFromNow) days from now, making \(assignmentsByDay[daysFromNow].count) now due on that day")
                }
            }
            //            print("\n\n\n")
            var daysFromNow = 0
            for assignsForThisDay in assignmentsByDay {
                var alertNum = 0
                
                for alert in alerts {
                    if alert.alertOn {
                        //                        let secondsInADay = 60*60*24.0
                        if let assignDate = assignsForThisDay.first?.dueDate {
                            let cal = Calendar.current
                            let dateFormat = DateFormatter()
                            dateFormat.dateFormat = "MM-dd-yyyy HH:mm"
                            
                            var trigDate = DateComponents()
                            trigDate.calendar = cal
                            trigDate.setValue(cal.component(.year, from: assignDate), for: .year)
                            trigDate.setValue(cal.component(.month, from: assignDate), for: .month)
                            trigDate.setValue(cal.component(.day, from: assignDate)-1, for: .day)
                            
                            let alertTime = alert.time
                            //                        print("Alert is Dated \(dateFormat.string(from: alertTime))")
                            trigDate.setValue(cal.component(.hour, from: alertTime), for: .hour)
                            trigDate.setValue(cal.component(.minute, from: alertTime), for: .minute)
                            trigDate.setValue(0, for: .second)
                            
                            let content = UNMutableNotificationContent()
                            content.title = "HW Reminder"
                            if assignsForThisDay.count == 1 {
                                content.subtitle = "You have \(assignsForThisDay.count) assignment due tomorrow:"
                            } else {
                                content.subtitle = "You have \(assignsForThisDay.count) assignments due tomorrow:"
                            }
                            
                            var tomorrowList = ""
                            for assign in assignsForThisDay {
                                tomorrowList += "\(assign.className): \(assign.name)"
                                tomorrowList += "\n"
                            }
                            tomorrowList = tomorrowList.substring(to: tomorrowList.index(before: tomorrowList.endIndex))
                            content.body = tomorrowList
                            tomorrowList = ""
                            content.categoryIdentifier = "HWReminder.alert.\(daysFromNow).\(alertNum)"
                            let trigger = UNCalendarNotificationTrigger(dateMatching: trigDate, repeats: false)
                            let request = UNNotificationRequest(identifier: "HWReminer.notification.\(daysFromNow).\(alertNum)", content: content, trigger: trigger)
                            //                                                        UNUserNotificationCenter.current().add(request)
                            notifCenter.add(request, withCompletionHandler: nil)
                            
                            print("Alert Added for \(assignsForThisDay.first!.name) with unique ID: HWReminder.alert.\(daysFromNow).\(alertNum)")
                            print("\tdue on \(dateFormat.string(from: assignDate))")
                            print("\tso alert will be on \(dateFormat.string(from: trigDate.date!))")
                        }
                    }
                    alertNum += 1
                }
                daysFromNow += 1
            }
            print("\n\n\nSo just to recap alerts:")
            notifCenter.getPendingNotificationRequests(completionHandler: {(lst) in
                print("There are: \(lst.count) notifications\n")
                for notif in lst {
                    print("\t\(notif.content.title)")
                    print("\(notif.content.subtitle)")
                    print("\(notif.content.body)")
                    print("\((notif.trigger as! UNCalendarNotificationTrigger).dateComponents)")
                }
            }
            )
        }
    }
    private func DaysLeft(assignment: Assignment) -> Int{
        let assignDate = assignment.dueDate
        let calendar = Calendar.current
        let midnightAssignmentDate = calendar.startOfDay(for: assignDate)
        
        let secondsInDay = Double(60*60*24);
        //        midnightAssignmentDate.addTimeInterval(secondsInDay);
        //        let dateFormatter = DateFormatter();
        let daysLeft = ceil(midnightAssignmentDate.timeIntervalSinceNow/secondsInDay)
        //        dateFormatter.dateFormat = "MM-dd-yyyy hh:mm"
        //        print("Named: \(assignment.name) is due on \(dateFormatter.string(from: assignDate)) Today is: \(dateFormatter.string(from: Date())) so the assignment is due in \(daysLeft) days")
        
        //        return Int(midnightAssignmentDate.timeIntervalSinceNow/secondsInDay)
        return Int(daysLeft)
    }
}
























