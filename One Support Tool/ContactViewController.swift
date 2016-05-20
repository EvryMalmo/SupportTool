//
//  ContactViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-16.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import Cocoa

class ContactViewController: NSViewController
{
    @IBOutlet weak var serviceDesk: NSTextField!
    @IBOutlet weak var sspButton: NSButtonCell!
    @IBOutlet weak var emailButton: NSButton!
    @IBOutlet weak var phone: NSTextFieldCell!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
                
        serviceDesk.stringValue = "Service Desk"
        sspButton.title = "Self Service Portal"
        emailButton.title = "servicedesk@vellinge.se"
        phone.stringValue = "040 - 42 53 33 (kortnummer 5333)"
    }
    
    override var representedObject: AnyObject?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
    
    //
    // Open Email Client
    //
    @IBAction func emailTapped(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "mailto:servicedesk@vellinge.se?subject=The%20subject%20of%20the%20mail&body=This%20is%20a%20message%20body")!)
    }
    
    //
    // Open URL to Self Service Portal
    //
    @IBAction func sspUrlTapped(sender: AnyObject) {
        NSWorkspace.sharedWorkspace().openURL(NSURL(string: "http://www.google.com")!)
    }
}