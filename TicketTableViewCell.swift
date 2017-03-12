//
//  TicketTableViewCell.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 09.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit

class TicketTableViewCell: UITableViewCell {


    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var timeDepLabel: UILabel!
    @IBOutlet weak var dateDepLabel: UILabel!



    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timeDesLabel: UILabel!
    @IBOutlet weak var dateDesLabel: UILabel!
    
    @IBOutlet weak var train: UILabel!
    @IBOutlet weak var railroadCar: UILabel!
    @IBOutlet weak var seatLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
