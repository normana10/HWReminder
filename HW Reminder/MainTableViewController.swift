//
//  MainTableViewController.swift
//  HW Reminder
//
//  Created by Arthur Normand on 1/15/17.
//  Copyright © 2017 Normand Consulting. All rights reserved.
//

import UIKit
import UserNotifications

class MainTableViewController: UITableViewController {
    
    
    var assignments: [Assignment] = [Assignment]()
    var classes = [Class]()
    var alerts = [Alert]()
    var newAssignment: Assignment?
    var notificationsEnabled = false
    var editingAssignmentAt = -1;
    
    @IBAction func Refresh(_ sender: Any) {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MAIN VIEW LOADED")
        
        //        Load Assignments
        if let loadedAssignments = loadAssignments() {
            assignments += loadedAssignments
            //            print("I HAPPENENDDDDDDD")
        } else {
            assignments += loadSampleAssignments()
            saveAssignments()
        }
        
        //        Load Classes
        if let loadedClasses = loadClasses() {
            classes += loadedClasses
        } else {
            classes += loadSampleClasses()
            saveClasses()
        }
        assignments.sort(by: {$0.dueDate < $1.dueDate})
        //        NotificationCenter.default.addObserver(self, selector: "appBecomeActive", name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        if #available(iOS 10.0, *){
            
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            let notifCenter = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Title"
            content.subtitle = "Subtitle"
            content.body = "Body"
            var trigDate = DateComponents()
            trigDate.year = 2017
            trigDate.month = 1
            trigDate.day = 19
            trigDate.hour = 2
            trigDate.minute = 18
            trigDate.second = 30
            //        trigDate.calendar = Calendar.current
            let trigger = UNCalendarNotificationTrigger(dateMatching: trigDate, repeats: false)
            let request = UNNotificationRequest(identifier: "HWReminder.alert", content: content, trigger: trigger)
            notifCenter.add(request)
            
            
            //        let center = UNUserNotificationCenter.current()
            
            //        let cont = UNMutableNotificationContent()
            //        cont.title = "Late wake up call"
            //        cont.body = "The early bird catches the worm, but the second mouse gets the cheese."
            //        cont.categoryIdentifier = "alarm"
            //        content.userInfo = ["customData": "fizzbuzz"]
            //        content.sound = UNNotificationSound.default()
            //
            //        var dateComponents = DateComponents()
            //        dateComponents.hour = 23
            //        dateComponents.minute = 18
            //        let trig = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            //        let req = UNNotificationRequest(identifier: UUID().uuidString, content: cont, trigger: trig)
            //        notifCenter.add(req)
            
            //
            //        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: {(arr) in
            //            print("THERE BE \(arr.count) NOTIFICATIONS QUEUED UP")
            //            for alert in arr {
            //                print("\(alert.content.title)")
            //                print("\((alert.trigger as! UNCalendarNotificationTrigger).dateComponents.year)")
            //            }
            //        })
            //
            //        let dateformat = DateFormatter()
            //        dateformat.dateFormat = "MM-dd-yyyy hh:mm"
            //        print("Current Date is: \(dateformat.string(from: Date()))")
            //        print("Alert is set to date: \(dateformat.string(from: trigDate.date!))")
            //
            //        let trig = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
            //        let req = UNNotificationRequest(identifier: "HWReminder.msg", content: content, trigger: trig)
            //        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
            
            //        assignments += loadSampleAssignments()
            //        classes += loadSampleClasses()
            
            
            
            // Uncomment the following line to preserve selection between presentations
            // self.clearsSelectionOnViewWillAppear = false
            
            // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
            // self.navigationItem.rightBarButtonItem = self.editButtonItem()
            
            updateAlertNotifications()
            updateBadgeNumber()
        } else {
            
        }
        
    }
    
    private func appBecomeActive() {
        //reload your Tableview here
        tableView.reloadData()
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
//                    print("Adding \(assign.name) because it's due \(daysFromNow) days from now, making \(assignmentsByDay[daysFromNow].count) now due on that day")
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
                            
//                            print("Alert Added for \(assignsForThisDay.first!.name) with unique ID: HWReminder.alert.\(daysFromNow).\(alertNum)")
//                            print("\tdue on \(dateFormat.string(from: assignDate))")
//                            print("\tso alert will be on \(dateFormat.string(from: trigDate.date!))")
                        }
                    }
                    alertNum += 1
                }
                daysFromNow += 1
            }
//            print("\n\n\nSo just to recap alerts:")
            notifCenter.getPendingNotificationRequests(completionHandler: {(lst) in
//                print("There are: \(lst.count) notifications\n")
//                for notif in lst {
//                    print("\t\(notif.content.title)")
//                    print("\(notif.content.subtitle)")
//                    print("\(notif.content.body)")
//                    print("\((notif.trigger as! UNCalendarNotificationTrigger).dateComponents)")
//                }
            }
            )
        }
    }
    
    @IBAction func unwindToMain(sender: UIStoryboardSegue){
        if let source = sender.source as? AddAnAssignmentDetailViewController, let newAssignment = source.newAssignment {
//            let newIndexPath = IndexPath(row: assignments.count, section: 0)
            //            newAssignment.dueDate =
            assignments.append(newAssignment)
            
            if source.RepeatSwitch.isOn == true {
                let secondsInWeek = 60*60*24*7*1.0
                var workingDate = newAssignment.dueDate.addingTimeInterval(secondsInWeek)
                let targetDate = source.repeatDatePicker.date
                while workingDate < targetDate {
                    let weeklyAssignment = Assignment(name: newAssignment.name, className: newAssignment.className, dueDate: workingDate, important: newAssignment.important)
                    assignments.append(weeklyAssignment)
                    workingDate.addTimeInterval(secondsInWeek)
                }
            }
            //TODO CHECK IF REPEATING AND ADD REPEATED TO ASSIGNMENT LIST
            
            
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
            assignments.sort(by: {$0.dueDate < $1.dueDate})
            tableView.reloadData()
            saveAssignments()
            classes = loadClasses()!
            if #available(iOS 10.0, *) {
                updateAlertNotifications()
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                updateBadgeNumber()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    @IBAction func unwindToMainFromClasses(sender: UIStoryboardSegue){
        if let loadedAssignemnts = loadAssignments(){
            assignments = loadedAssignemnts
        }
        if let loadedClasses = loadClasses() {
            classes = loadedClasses
        }
        tableView.reloadData()
        if #available(iOS 10.0, *) {
            updateBadgeNumber()
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func unwindToMainFromEditAssignment(sender: UIStoryboardSegue){
        
        let sentFrom = sender.source as! EditExistingAssignmentViewController;
        
//        let editingAssignment = assignments[editingAssignmentAt];
        assignments[editingAssignmentAt].name = sentFrom.newAssignmentName.text!;
        assignments[editingAssignmentAt].dueDate = sentFrom.dueDate.date;
        assignments[editingAssignmentAt].important = sentFrom.importantPicker.selectedSegmentIndex;
//        print("THE SELECTED SEGMENT IS:", sentFrom.importantPicker.selectedSegmentIndex);
//        print("Does edited assignment say it's important:     And the saved assignment: ", assignments[editingAssignmentAt].important);
        
//        assignments[editingAssignmentAt] = editingAssignment;
        
        assignments.sort(by: {$0.dueDate < $1.dueDate})
        tableView.reloadData();
        saveAssignments()
//        print("Does edited assignment say it's important:     And the saved assignment: ", assignments[editingAssignmentAt].important);
        assignments = loadAssignments()!;
//        print("Does edited assignment say it's important:     And the saved assignment: ", assignments[editingAssignmentAt].important);
        
        
        if #available(iOS 10.0, *) {
            updateAlertNotifications()
            updateBadgeNumber();
        } else {
            // Fallback on earlier versions
        };
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return assignments.count
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentTableViewCell", for: indexPath) as? AssignmentTableViewCell else {
            fatalError()
        }
        
        let assignment = assignments[indexPath.row]
        
        cell.AssignmentName.text = assignment.name
        cell.ClassName.text = assignment.className
        
        let daysLeft = DaysLeft(assignment: assignment)
        
        cell.DaysLeftCounter.text = "\(daysLeft)"
        cell.DaysLeftCounter.adjustsFontSizeToFitWidth = true
        
        let classDNE = UIImage(named: "Class DNE")!
        let classImage = classes.first(where: {$0.shortName == assignment.className})?.image ?? classDNE
        cell.AssignmentClassImage.image = classImage
        
        //        switch assignment.priority {
        //        case 1:
        //            cell.DaysLeftView.backgroundColor = UIColor.red
        //        case 2:
        //            cell.DaysLeftView.backgroundColor = UIColor.yellow
        //        case 3:
        //            cell.DaysLeftView.backgroundColor = UIColor.green
        //        default:
        //            cell.DaysLeftView.backgroundColor = UIColor.green
        //        }
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        switch daysLeft {
        case 0:
            //RED = R: 237 G: 44 B: 52
            red = 237
            green = 44
            blue = 52
            
            red = red/255
            green = green/255
            blue = blue/255
        case 1...2:
            //ORANGE = R: 237 G: 115 B: 0
            red = 237
            green = 115
            blue = 0
            
            red = red/255
            green = green/255
            blue = blue/255
        case 3..<7:
            //Yellow = R: 230 G: 197 B: 25
            red = 230
            green = 197
            blue = 25
            
            red = red/255
            green = green/255
            blue = blue/255
        case 7...Int.max:
            //Any other so GREEN = R: 51 G: 153 B: 51
            red = 51/255
            green = 153/255
            blue = 51/255
        default:
            red = 255
            green = 0
            blue = 0
            
            red = red/255
            green = green/255
            blue = blue/255
        }
        cell.DaysLeftView.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let dFormat = DateFormatter();
        dFormat.dateFormat = "MM-dd-yy";
        cell.dueDateLabel.text = dFormat.string(from: assignment.dueDate);
        cell.dueDate = assignment.dueDate;
        print("TABLE RELOADING, IS THIS CELL IMPORTANT: ", assignment.important);
        if assignment.important == 1 {
            cell.importance.isHidden = false;
        } else {
            cell.importance.isHidden = true;
        }
        // Configure the cell...
        
        //        print("Adding: \(assignment.name)   due date: \(assignment.dueDate)   midnight due date:\(midnightAssignmentDate)   assignment is due in:\(midnightAssignmentDate.timeIntervalSinceNow)")
        return cell
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
            // Delete the row from the data source
            assignments.remove(at: indexPath.row)
            saveAssignments()
            tableView.deleteRows(at: [indexPath], with: .fade)
            if #available(iOS 10.0, *) {
                updateBadgeNumber()
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 10.0, *) {
                updateAlertNotifications()
            } else {
                // Fallback on earlier versions
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        let complete = UITableViewRowAction(style: .normal, title: "Complete", handler: {(rowAction,indexPath) in print("Pressed complete")})
    //        complete.backgroundColor = UIColor.blue
    //
    //        let delete = UITableViewRowAction(style: .destructive, title: "Delete", handler: {(rowAction,indexPath) in print("Pressed delete")})
    //
    //        return [complete, delete]
    //    }
    
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
        guard let sentBy = sender as? AssignmentTableViewCell else {
            return;
        }
        editingAssignmentAt = (tableView.indexPath(for: sentBy)?.row)!;
        let editingAssignment = assignments[editingAssignmentAt];
        
        let movingTo = segue.destination as! EditExistingAssignmentViewController;
        
        movingTo.currAssignment = editingAssignment;
        movingTo.currClassImage = classes.first(where: {$0.shortName == editingAssignment.className})?.image ?? UIImage(named: "classDNE")!
        
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
        let class3 = Class(name: "Art", image: UIImage(named: "Brushes")!, shortName: "Art 123", notes: "")
        classes += [class1, class2, class3]
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
    private func loadAlerts() -> [Alert]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Alert.ArchiveURL.path) as? [Alert]
    }
    private func saveAlerts(){
        NSKeyedArchiver.archiveRootObject(alerts, toFile: Alert.ArchiveURL.path)
    }
}





















