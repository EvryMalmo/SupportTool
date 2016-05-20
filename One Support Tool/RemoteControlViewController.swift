//
//  RemoteControlViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-12.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Foundation
import Cocoa


class RemoteControlViewController: NSViewController
{
    @IBAction func startTeamViewer(sender: AnyObject)
    {
        //NSWorkspace.sharedWorkspace().launchApplication("/Applications/TeamViewerQS.app")
        NSWorkspace.sharedWorkspace().launchApplication("/Applications/TeamViewerQS.app")

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