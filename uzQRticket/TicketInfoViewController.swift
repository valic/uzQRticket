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
    @IBOutlet weak var imageQRCode: UIImageView!
    
    var qrcodeImage: CIImage!
    
    var ticketID = ""
    var seat = ""
    var surnameAndName = ""
    var stringTicket = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ticketIdLabel.text = ticketID
        seatLabel.text = seat
        surnameNameLabel.text = surnameAndName
        
        generationQR(stringTicket)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generationQR (_ textQR: String) {
        
        let data = textQR.data(using: String.Encoding.utf8, allowLossyConversion: false)
        if data != nil {
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("L", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter!.outputImage
            
            displayQRCodeImage()
        }
            
        else {
            qrcodeImage = nil
        }
    }
    
    func displayQRCodeImage() {
        let scaleX = imageQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imageQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imageQRCode.image = UIImage(ciImage: transformedImage)
        
    }
    

}
