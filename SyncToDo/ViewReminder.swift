//
//  ViewReminder.swift
//  SyncToDo
//
//  Created by Nandan R on 11/10/23.
//

import UIKit

class ViewReminder: UIViewController {
    
    @IBOutlet weak var tbl: UITableView!
    
    var remList: [Reminder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSHomeDirectory())
        
        tbl.dataSource = self
        tbl.delegate = self
        
        do{
            remList = try ReminderUtility.instance.getRemList()
            print("No of Reminders: \(remList.count)")
            if remList.count == 0{
                tbl.isHidden = true
            }
            self.tbl.reloadData()
        }catch{
            print("Unable to fetch: \(error.localizedDescription)")
        }
        
        

        // Do any additional setup after loading the view.
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

extension ViewReminder: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "remindercell", for: indexPath) as! ReminderCell
        
        let rem = remList[indexPath.row]
        
        cell.titleCellL.text = rem.title
        cell.descriptionCellL.text = "Description: \(rem.descript ?? "")"
        
        let selectedDate = rem.datetime!
        
        let formatingDate = DateFormatter()
        
        formatingDate.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = formatingDate.string(from: selectedDate)
        
        cell.dateTimeCellL.text = "Date & Time: \(dateString)"
        cell.typeCellL.text = "Type: \(rem.typeofrem ?? "")"
        
        cell.notificationCellL.text = String(rem.notification)
        
        cell.notificationCellL.text = (rem.notification) ? "Notificaton: Yes" : "Notification: No"

        
        return cell
    }
}

extension ViewReminder: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let rem = remList[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "delete") { _, _, _ in
            do{
                try ReminderUtility.instance.deleteRem(remToDelete: rem)
                self.remList.remove(at: indexPath.row)
                self.tbl.deleteRows(at: [indexPath], with: .automatic)
            }
            
            catch{
                self.showAlert(title: "Could not delete \(rem.title ?? "")", msg: nil)
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
}
