//
//  EvryViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-04-21.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import Cocoa

class EvryViewController: NSViewController, NSSharingServiceDelegate
{
    let contactEmail = "servicedesk@vellinge.se"
    
    @IBOutlet weak var emailButton: NSButton!
    @IBOutlet weak var referensceID: NSTextField!
    @IBOutlet weak var emailInformation: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        emailInformation.stringValue = "When you press the above button an email wll be sent to servicedesk@vellinge.se containing information about your hardware and software status."
    }
    
    override var representedObject: AnyObject?
    {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
    
    
    @IBAction func sysinfoTapped(sender: AnyObject) {
        
        print("klickade på system info file")
        
        let str = "Super long string here"
        let filename = getDocumentsDirectory().stringByAppendingPathComponent("output.txt")
        
        do {
            try str.writeToFile(filename, atomically: true, encoding: NSUTF8StringEncoding)
            print("sparade fil")
        } catch {
            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
            print("funkade inte")
        }
      
        
    }
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @IBAction func emailTapped(sender: AnyObject) {
        
        
        let body = "my body"
        
        let shareItems = [body] as NSArray
        
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)
        
        service?.delegate = self
        service?.recipients = [contactEmail]
        
        
        let subject = "This is my subject"
        service?.subject = subject
        
        service?.performWithItems(shareItems as [AnyObject])
    }
    
    
}