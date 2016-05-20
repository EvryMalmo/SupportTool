//
//  SystemViewController.swift
//  One Support Tool
//
//  Created by Admin on 2016-02-12.
//  Copyright © 2016 EVRY. All rights reserved.
//

import Cocoa
import Foundation

class SystemViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var computerName: NSTextField!
    @IBOutlet weak var osName: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    @IBOutlet weak var osVersion: NSTextField!
    @IBOutlet weak var computerManufacturer: NSTextField! // Hardcoded for Apple
    @IBOutlet weak var model: NSTextField!
    @IBOutlet weak var systemType: NSTextField!
    @IBOutlet weak var processor: NSTextField!
    @IBOutlet weak var installedPhysicalMemory: NSTextField!
    @IBOutlet weak var totalPhysicalMemory: NSTextField!
    @IBOutlet weak var availablePhysicalMemory: NSTextField!
    @IBOutlet weak var totalVirtualMemory: NSTextField!
    @IBOutlet weak var availableVirtualMemory: NSTextField!
    @IBOutlet weak var timezone: NSTextField!
    @IBOutlet weak var bootMode: NSTextField!
    
    var objects: NSMutableArray! = NSMutableArray()
    var systemInfo: NSMutableArray! = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize_cutils()
        computerName.stringValue = NSHost.currentHost().localizedName!
        osName.stringValue = (String.fromCString(get_os_name()))! + " " + NSProcessInfo.processInfo().operatingSystemVersionString
        computerManufacturer.stringValue = "Apple"
        model.stringValue = (String.fromCString(get_model_name()))!

        processor.stringValue = String(NSProcessInfo.processInfo().processorCount)
        totalPhysicalMemory.stringValue = String(NSProcessInfo.processInfo().physicalMemory)
        computerName.stringValue = NSProcessInfo.processInfo().hostName
        report_memory()
        
        self.systemInfo.addObject("Computer Name:")
        self.systemInfo.addObject("OS Name and Version:")
        self.systemInfo.addObject("Computer Manufacturer:")
        self.systemInfo.addObject("Model:")
        self.systemInfo.addObject("System Type:")
        self.systemInfo.addObject("Processor Count:")
        self.systemInfo.addObject("Installed Physical Memory:")
        self.systemInfo.addObject("Total Physical Memory:")
        self.systemInfo.addObject("Available Physical Memory:")
        
        //Computer Name
        //self.objects.addObject(NSHost.currentHost().localizedName!)
        self.objects.addObject(NSProcessInfo.processInfo().hostName)
        //OS Name and version
        self.objects.addObject((String.fromCString(get_os_name()))! + " " + NSProcessInfo.processInfo().operatingSystemVersionString)
        
        //Computer Manufacturer
        self.objects.addObject("Apple")
        
        //Model
        self.objects.addObject((String.fromCString(get_model_name()))!)
        
        //System Type
        self.objects.addObject("")
        
        //Processor Count
        self.objects.addObject(String(NSProcessInfo.processInfo().processorCount))
        
        //Installed Physical Memory
        self.objects.addObject("")
        
        //Total Physical Memory
        self.objects.addObject(String(NSProcessInfo.processInfo().physicalMemory))
        
        //"Available Physical Memory:"
        self.objects.addObject(availablePhysicalMemory.stringValue)
        
        self.tableView.reloadData()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
   
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return self.objects.count
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        
        var identifierStr = ""
        
        identifierStr = tableColumn!.identifier
        
        if(identifierStr == "Col1"){
            let cellView = tableView.makeViewWithIdentifier("cell", owner: self) as! NSTableCellView
            cellView.textField!.stringValue = self.systemInfo.objectAtIndex(row) as! String
            return cellView
        }
        
        if(identifierStr == "Col2"){
            
            let cellView = tableView.makeViewWithIdentifier("cell2", owner: self) as! NSTableCellView
            cellView.textField!.stringValue = self.objects.objectAtIndex(row) as! String
            return cellView
        }
       
        return nil
    }
    
    
    func report_memory() {
        // constant
        let MACH_TASK_BASIC_INFO_COUNT = (sizeof(mach_task_basic_info_data_t) / sizeof(natural_t))
        
        // prepare parameters
        let name   = mach_task_self_
        let flavor = task_flavor_t(MACH_TASK_BASIC_INFO)
        var size   = mach_msg_type_number_t(MACH_TASK_BASIC_INFO_COUNT)
        
        // allocate pointer to mach_task_basic_info
        let infoPointer = UnsafeMutablePointer<mach_task_basic_info>.alloc(1)
        
        // call task_info - note extra UnsafeMutablePointer(...) call
        let kerr = task_info(name, flavor, UnsafeMutablePointer(infoPointer), &size)
        
        // get mach_task_basic_info struct out of pointer
        let info = infoPointer.move()
        
        // deallocate pointer
        infoPointer.dealloc(1)
        
        // check return value for success / failure
        if kerr == KERN_SUCCESS {
            availablePhysicalMemory.stringValue = "\(NSProcessInfo.processInfo().physicalMemory - info.resident_size)"
            
        }
    }
    
    
}