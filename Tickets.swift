//
//  Tickets.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 10.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import Foundation
import CoreData

@objc(Tickets)
class Tickets: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    @NSManaged var string: String?
}
