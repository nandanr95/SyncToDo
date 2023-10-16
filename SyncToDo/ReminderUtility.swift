//
//  ReminderUtility.swift
//  SyncToDo
//
//  Created by Nandan R on 09/10/23.
//

import Foundation
import UIKit

struct ReminderUtility{
    private init () {}
    
    static var instance = ReminderUtility()
    var dbContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addRem(remtitle: String, description: String, dateTime: Date, type: String, notify: Bool) throws{
        
        let rem = Reminder(context: dbContext)
        rem.title = remtitle
        rem.descript = description
        rem.datetime = dateTime
        rem.typeofrem = type
        rem.notification = notify
        
        try dbContext.save()
        
    }
    
    func deleteRem(remToDelete: Reminder) throws{
        dbContext.delete(remToDelete)
        try dbContext.save()
    }
    
    func getRemList() throws -> [Reminder]{
        
        let fRequest = Reminder.fetchRequest()
        let result = try dbContext.fetch(fRequest)
        
        return result
    }
}

extension UIViewController{
    func showAlert(title: String?, msg: String?){
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alertVC.addAction(okAction)
        present(alertVC, animated: false)
    }
}
