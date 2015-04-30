//
//  ActionListViewController.swift
//  Baby Connected
//
//  Created by Thomas on 4/7/15.
//  Copyright (c) 2015 thomasl. All rights reserved.
//

import UIKit
import CoreData

class ActionListViewController: UITableViewController {

    var notes = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedConext = delegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Action")
        var error:NSError?
        let fetchedResults = managedConext?.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if let results = fetchedResults {
            notes = results
        } else {
            println(error)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        println(notes.count)
        return notes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell!

        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCellStyle.Value1 , reuseIdentifier: "cell")
        }
        // Configure the cell...
        let type = notes[indexPath.row].valueForKey("type") as! String
        cell.textLabel?.text = type
        
        let babyVC = BabyActionViewController()
        if(type == babyVC.cellTitles[0]) {
        
            var breastside = notes[indexPath.row].valueForKey("breastside") as? Int
            var duration = notes[indexPath.row].valueForKey("duration") as? Double
            let minutes = UInt8(duration! / 60.0)
            let strMinutes = String(minutes)
            let strSide = (breastside == 0) ? "左邊" : "右邊"
            cell.textLabel?.text = "\(type) \(strSide) \(strMinutes)分鐘"
        }
        
        let format = NSDateFormatter()
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.ShortStyle
        let date = notes[indexPath.row].valueForKey("time") as! NSDate?
        if (date != nil){
            cell.detailTextLabel?.text = format.stringFromDate(date!)
        }

        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedConext = delegate.managedObjectContext
            managedConext?.deleteObject(notes[indexPath.row] as NSManagedObject)
            
            var error : NSError?
            if((managedConext?.save(&error)) != nil){
                println(error)
            }
            
            notes.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
