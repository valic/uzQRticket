//
//  Tickets+CoreDataProperties.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 10.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import Foundation
import CoreData

extension Tickets {
    
    @NSManaged var train: String?
    @NSManaged var departure: String?
    @NSManaged var destination: String?
    @NSManaged var dateTimeDep: Date?
    @NSManaged var dateTimeDes: Date?
    @NSManaged var coach: String?
    @NSManaged var seat: String?
    @NSManaged var surnameAndName: String?
    @NSManaged var cost: NSNumber?
    @NSManaged var ticketID: String?
    @NSManaged var stringTicket: String?
    
}
