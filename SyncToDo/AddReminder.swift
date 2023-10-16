//
//  AddReminderViewController.swift
//  SyncToDo
//
//  Created by Nandan R on 09/10/23.
//

import UIKit

class AddReminder: UIViewController {
    
    
    @IBOutlet weak var titleTF: UITextField!
    
    
    @IBOutlet weak var descriptionTF: UITextView!
    
    
    @IBOutlet weak var dateDP: UIDatePicker!
    
    
    @IBOutlet weak var typeSC: UISegmentedControl!
    
    
    @IBOutlet weak var notifySw: UISwitch!
    
    let notUtility = NotificationUtility()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTF.becomeFirstResponder()
        notUtility.notificationCenter.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

            view.endEditing(true)

        }
    

    @IBAction func addClick(_ sender: Any) {
        
        let titleAdd = titleTF.text ?? ""
        let descriptAdd = descriptionTF.text ?? ""
        let dateAdd = dateDP.date
        let typeAdd = typeSC.titleForSegment(at: typeSC.selectedSegmentIndex) ?? ""
        let notifyAdd = notifySw.isOn
        
        
//        let selectedDate = dateDP.date
//        let formatingDate = DateFormatter()
//        
//        
//        formatingDate.dateFormat = "dd/MM/yyyy HH:mm:ss"
//        dateAdd = formatingDate.string(from: selectedDate)
        
        do{
            try ReminderUtility.instance.addRem(remtitle: titleAdd, description: descriptAdd, dateTime: dateAdd, type: typeAdd, notify: notifyAdd)
            
            
            
        }
        catch{
            print("Error \(error.localizedDescription)")
        }
        
        if notifyAdd{
            notUtility.addNotification(notTitle: titleAdd, notType: typeAdd, notDate: dateAdd)
        }
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AddReminder: UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("did receive: app not in foreground and user selected notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("will present: app is in foreground")
        
    
        completionHandler([.banner, .sound])
    }
}

