//
//  NewTicketViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-12.
//  Copyright © 2016 EVRY. All rights reserved.
//


import Foundation
import Cocoa



class NewTicketViewController: NSViewController, NSSharingServiceDelegate
{
    
    /////////////////////////
    // CONTACT INFORMATION //
    /////////////////////////
    
    let contactEmail = "alexander.taavitsainen@evry.com"
    let contactPhone = "040425333"
    
    @IBOutlet weak var titleText: NSTextField!
    @IBOutlet weak var descriptionText: NSTextField!
    @IBOutlet weak var workedBeforeText: NSTextField!
    @IBOutlet weak var whenAndWhereText: NSTextField!
    @IBOutlet weak var othersAffectedText: NSTextField!
    @IBOutlet weak var locationText: NSTextField!
    @IBOutlet weak var nameText: NSTextField!
    @IBOutlet weak var phoneText: NSTextField!
    
    @IBAction func resetButton(sender: AnyObject) {
        titleText.stringValue = ""
        descriptionText.stringValue = ""
        workedBeforeText.stringValue = ""
        whenAndWhereText.stringValue = ""
        othersAffectedText.stringValue = ""
        locationText.stringValue = ""
        nameText.stringValue = ""
        phoneText.stringValue = ""
    }
    
    @IBAction func sendToServiceDesk(sender: AnyObject) {
       
        let body =
        "DESCRIPTION: " + descriptionText.stringValue + "\n" +
        "DID IT WORK BEFORE?: " + workedBeforeText.stringValue + "\n" +
        "WHERE AND WHEN DID THE PROBLEM OCCUR?: " + whenAndWhereText.stringValue + "\n" +
        "ARE THERE OTHERS AFFECTED?: " + othersAffectedText.stringValue + "\n" +
        "WHERE ARE YOU?: " + locationText.stringValue + "\n" +
        "WHAT IS YOUR NAME?: " + nameText.stringValue + "\n" +
        "WHAT IS YOUR PHONE NUMBER?: " + phoneText.stringValue + "\n" +
        "----------------------------------------------------" +
        ""
        
        let shareItems = [body] as NSArray
        
        let service = NSSharingService(named: NSSharingServiceNameComposeEmail)
        
        service?.delegate = self
        service?.recipients = [contactEmail]
        
        
        let subject = titleText.stringValue
        service?.subject = subject
        
        service?.performWithItems(shareItems as [AnyObject])
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
}