//
//  TicketInfoViewController.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 12.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class TicketInfoViewController: UIViewController {
    
    @IBOutlet weak var ticketIdLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var surnameNameLabel: UILabel!
    
    var ticketID = ""
    var seat = ""
    var surnameAndName = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ticketIdLabel.text = ticketID
        seatLabel.text = seat
        surnameNameLabel.text = surnameAndName
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
