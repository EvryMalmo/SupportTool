//
//  UserViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-15.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import Cocoa


class UserViewController: NSViewController
{
    @IBOutlet weak var userName: NSTextField!
    @IBOutlet weak var domain: NSTextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userName.stringValue = NSProcessInfo.processInfo().hostName
        
    }
    
    override var representedObject: AnyObject?
        {
        didSet
        {
            // Update the view, if already loaded.
        }
    }
}