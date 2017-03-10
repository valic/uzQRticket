//
//  QRscanViewController.swift
//  uzQRticket
//
//  Created by Mialin Valentin on 06.03.17.
//  Copyright © 2017 Mialin Valentin. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class QRscanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var textQR: String?
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        if status == AVAuthorizationStatus.authorized {
            // Show camera
            self.initializationCaptureSession ()
        } else if status == AVAuthorizationStatus.notDetermined {
            // Request permission
            print("Request permission")
            
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) -> Void in
                if granted {
                    // Show camera
                    self.initializationCaptureSession ()
                }
            })
        } else {
            print("нет доступа к камере")
            // User rejected permission. Ask user to switch it on in the Settings app manually
            //open the settings to allow the user to select if they want to allow for location settings.
            
            let alert = UIAlertController(title: "Невозможно получить доступ к камере", message: "Сканеру требуется доступ к вашей камере для сканирования кодов. Перейдите в настройки приватности вашего устройства для включения камеры.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler:nil))
            alert.addAction(UIAlertAction(title: "Настройки", style: UIAlertActionStyle.default, handler: {
                (alert: UIAlertAction!) in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
            
        }
    }
    
    func initializationCaptureSession () {
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            
            // Start video capture
            captureSession?.startRunning()
            
            // let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(_:)))
            // self.view.addGestureRecognizer(gesture)
            
            
            // Move the message label to the top view
            // view.bringSubviewToFront(messageLabel)
            // view.bringSubview(toFront: flashlight)
            
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    func deleteCaptureSession () {
        
        if captureSession != nil {
            self.captureSession!.stopRunning()
            captureSession = nil
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            print("No barcode/QR code is detected")
            return
        }

        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        
        if supportedBarCodes.contains(metadataObj.type) {
            
            if metadataObj.stringValue != nil {
                textQR = metadataObj.stringValue!
                
                if let textQR = textQR {
                       print(textQR)
                    
                    let arrayScanCode = textQR.components(separatedBy: "\n")
                    
                    if arrayScanCode.count == 20 /*&& arrayScanCode[15] == arrayScanCode[19] */{
                        
                        // create an instance of our managedObjectContext
                        let context = getContext ()
                        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tickets")
                        
                        // we set up our entity by selecting the entity and context that we're targeting
                        let entity = NSEntityDescription.insertNewObject(forEntityName: "Tickets", into: context) as! Tickets
                        
                        let predicate = NSPredicate(format: "ticketID == %@", arrayScanCode[15])
                        request.predicate = predicate
                        do {
                            let results = try context.fetch(request) as! [Tickets]
                            
                            
                            if (results.count > 0) {
                                
                                self.deleteCaptureSession ()
                                alertCaptureSession("Билет уже добавлен")
                                
                                
                            } else {
                                // билета нету в Core Data, добавляем
                                
                                entity.setValue(textQR, forKey: "stringTicket") // сохраняем всю строку, для создания QR кода
                                entity.setValue(arrayScanCode[1], forKey: "train") // поїзд
                                entity.setValue(arrayScanCode[2], forKey: "departure") // відправлення
                                entity.setValue(arrayScanCode[3], forKey: "destination") // призначення
                                entity.setValue(stringToDate(arrayScanCode[4]), forKey: "dateTimeDep") // датаЧасВідпр
                                entity.setValue(stringToDate(arrayScanCode[5]), forKey: "dateTimeDes") // датаЧасПриб
                                entity.setValue(arrayScanCode[6], forKey: "coach") // вагон
                                entity.setValue(arrayScanCode[7], forKey: "seat") // місце
                                entity.setValue(arrayScanCode[9], forKey: "surnameAndName") // прізвищеІмя
                                entity.setValue(NSString(string: arrayScanCode[12]).floatValue, forKey: "cost") // вартість
                                entity.setValue(arrayScanCode[15], forKey: "ticketID")
                                
                                // we save our entity
                                do {
                                    try context.save()
                                } catch {
                                    fatalError("Failure to save context: \(error)")
                                }
                                
                                deleteCaptureSession ()
                                videoPreviewLayer!.removeFromSuperlayer()
                                
                                // вернутся на Ticket View Controller
                                returnToTicketViewController()
                                
                            }
                        } catch let error as NSError {
                            // failure
                            print("Fetch failed: \(error.localizedDescription)")
                        }
                        
                        
                    }
                    else{
                        if arrayScanCode.count == 1 && arrayScanCode[0].characters.count == 19 {
                            
                            self.alertCaptureSession("возможно шрих код")
                            print(arrayScanCode[0]) //19
                        }
                        else {
                            self.alertCaptureSession("в QR code нету билета")
                         //   captureSession!.stopRunning()
                        }
                        
                    }
                }
              //  captureSession!.stopRunning()
              //  videoPreviewLayer!.removeFromSuperlayer()
                
                // вернутся на Ticket View Controller
               // returnToTicketViewController()
                
                
                
            }
        }
    }
    
    func returnToTicketViewController() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Ticket")
        self.present(controller, animated: false, completion: nil)
    }
    
    
    func stringToDate (_ stringData: String) -> Date  {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat  = "dd.MM HH:mm" //21.11 20:01
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Kiev")
        dateFormatter.defaultDate = Date()
        let date = dateFormatter.date(from: stringData)
        
        var dayComponenet = DateComponents()
        dayComponenet.day = 30
        
        let theCalendar = Calendar.current
        let nextDate = (theCalendar as NSCalendar).date(byAdding: dayComponenet, to: Date(), options: [])
        // print(nextDate)
        
        if date!.compare(nextDate!) == .orderedDescending {
            // Текущая дата больше конечной даты
            
            var dayComponenet = DateComponents()
            dayComponenet.year = -1
            
            let theCalendar = Calendar.current
            dateFormatter.defaultDate = (theCalendar as NSCalendar).date(byAdding: dayComponenet, to: Date(), options: [])
            // print(dateFormatter.dateFromString(stringData)!)
            return dateFormatter.date(from: stringData)!
        }
        else {
            return date!
        }
    }
    func alertCaptureSession(_ messageText: String)
    {
        let alertController = UIAlertController(title: title, message: messageText, preferredStyle:UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        { action -> Void in
            // Put your code here
            self.initializationCaptureSession()
        })
        //self.captureSession!.startRunning()
        self.present(alertController, animated: true, completion: nil)
    }
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

