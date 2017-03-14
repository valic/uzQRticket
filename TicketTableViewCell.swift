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

    @IBOutlet weak var backGroundCardView: UIView!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor = UIColor.white
       // contentView.backgroundColor = UIColor(red: 217/255.0, green: 217/255.0, blue: 217/255.0, alpha: 1.0)
        backGroundCardView.backgroundColor = UIColor.white
        backGroundCardView.layer.cornerRadius = 3.0
        backGroundCardView.layer.masksToBounds = false
        
        backGroundCardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        backGroundCardView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backGroundCardView.layer.shadowOpacity = 0.8
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
