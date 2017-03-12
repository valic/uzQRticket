//
//  CellViewController.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 09.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit
import CoreData

class CellViewController: UITableViewController {
    
    //  @IBOutlet var tableView: UITableView!
    
    var tickets = [NSManagedObject]()
    let textCellIdentifier = "TextCell" // func tableView
    
    var stringTicket = ""
    var train = ""
    var departure = ""
    var destination = ""
    var coach = ""
    var seat = ""
    var surnameAndName = ""
    var cost:Float = 0.0
    var dateTimeDep = Date()
    var dateTimeDes = Date()
    var ticketID = ""
    
    let moc = DataController().managedObjectContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         // create the delete request for the specified entity
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tickets")
         let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         
         // get reference to the persistent container
         let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
         
         // perform the delete
         do {
         try persistentContainer.viewContext.execute(deleteRequest)
         } catch let error as NSError {
         print(error)
         }
         */
        // tableView.delegate = self
        //tableView.dataSource = self
        //   fetch()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        fetch()
        //  fetchingFromCoreData ()
        
    }
    
    
    // MARK:  UITextFieldDelegate Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! TicketTableViewCell
        
        let person = tickets[(indexPath as NSIndexPath).row]
        
        cell.train?.text =  person.value(forKey: "train") as? String
        cell.railroadCar?.text = person.value(forKey: "coach") as? String
        cell.seatLabel?.text =  person.value(forKey: "seat") as? String
        
        let dateTimeDep  = person.value(forKey: "dateTimeDep") as? Date
        let dateTimeDes  = person.value(forKey: "dateTimeDes") as? Date
        
        if dateTimeDep != nil && dateTimeDes != nil {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            //  dateFormatter.locale = Locale.init(identifier: "en_GB")
            
            cell.timeDepLabel?.text = dateFormatter.string(from: dateTimeDep!)
            cell.timeDesLabel?.text = dateFormatter.string(from: dateTimeDes!)
            
            dateFormatter.dateFormat = "dd.MM"
            cell.dateDepLabel?.text = dateFormatter.string(from: dateTimeDep!)
            cell.dateDesLabel?.text = dateFormatter.string(from: dateTimeDes!)
        }
        
            cell.departureLabel!.text = stringRemoveRange10((person.value(forKey: "departure") as? String)!)
            cell.destinationLabel!.text = stringRemoveRange10((person.value(forKey: "destination") as? String)!)
        
        
        
        //print(dateTimeDes)
        // cell.dateTimeDepLabel!.text = dateToString(dateTimeDep)
        // cell.userInteractionEnabled = true
        
        /*
         if (dateEnd(dateTimeDes!) == true) {
         cell.contentView.alpha = 1.00
         }
         else {
         print("Дата в билете актуальна")
         }
         */
        return cell
    }
    
    
    func fetch() {
        
        do {
            let context = getContext ()
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tickets")
            tickets = try context.fetch(request) as! [Tickets]
            
          //  print(tickets)
            
        } catch let error as NSError {
            // failure
            print("Fetch failed: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let context = getContext ()
            
            context.delete(tickets[(indexPath as NSIndexPath).row])
            
            do {
                try context.save()
            } catch {
                print("failed to clear core data")
            }
        }
        self.tickets.remove(at: (indexPath as NSIndexPath).row)
        self.tableView.reloadData()
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ticket = tickets[(indexPath as NSIndexPath).row]
        
        seat = ticket.value(forKey: "seat") as! String
        surnameAndName = ticket.value(forKey: "surnameAndName") as! String
        ticketID = ticket.value(forKey: "ticketID") as! String
        
        self.performSegue(withIdentifier: "segueID", sender: nil)
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "segueID" {
            if let destinationVC = segue.destination as? TicketInfoViewController {
                
                destinationVC.ticketID = ticketID
                destinationVC.seat = seat
                destinationVC.surnameAndName = surnameAndName
                
            }
        }        
    }
    
    func stringRemoveRange10 (_ string: String) -> String {
        let range  = string.characters.index(string.startIndex, offsetBy: 10)..<string.endIndex
        return string[range]
    }
    
    func dateToString (_ date: Date) -> String  {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    func isBetweenMyTwoDates(_ start: Date, end: Date ) -> Bool {
        if start.compare(Date()) == .orderedAscending && end.compare(Date()) == .orderedDescending {
            return true
        }
        return false
    }
    
    func dateEnd(_ end: Date ) -> Bool {
        //    var dateComparisionResult:NSComparisonResult = currentDate.compare(end)
        if Date().compare(end) == ComparisonResult.orderedDescending {
            
            return true
        }
        return false
    }
    
    
    
    
    
}

