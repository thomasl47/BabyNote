//
//  AddActionViewController.swift
//  Baby Connected
//
//  Created by Thomas on 4/1/15.
//  Copyright (c) 2015 thomasl. All rights reserved.
//

import UIKit
import CoreData

class AddActionViewController: UIViewController {

    var timerbtnTitle: [String] = ["計時", "停止" ]
    enum timerOption : Int {
        case Start, Stop
    }
    
    var labelTitle: String = ""
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var timerBtn: UIButton!
    

    var timer:NSTimer = NSTimer()
    var startTime = NSDate()
    var stopTime = NSDate()
    
    enum breastSide : Int {
        case Left, Right
    }
    var side : breastSide = .Left
    
    var needResetTimmer = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let format = NSDateFormatter()
        format.timeStyle = NSDateFormatterStyle.ShortStyle
        format.dateStyle = NSDateFormatterStyle.NoStyle
        let date = NSDate()
        self.label.text = "\(format.stringFromDate(NSDate())) \(labelTitle)"
        
        timerBtn.hidden = true //Hide timer toggle
        
        self.toggleTimerBtn()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        if (!timer.valid) {
            let aSelector : Selector = "updateTime"
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: aSelector, userInfo: nil, repeats: true)
            if(needResetTimmer) {
                startTime = NSDate()
            }
        }
        
    }
    
    func stopTimer() {
        stopTime = NSDate()
        timer.invalidate()
    }
    
    func resetTimer() {
        needResetTimmer = true
        displayTimeLabel.text = "00:00"
        
    }
    
    @IBAction func timerPressed(sender: AnyObject) {
        self.toggleTimerBtn()
    }
    
    @IBAction func resetTimer(sender: AnyObject) {
        startTime = NSDate()
    }
    
    func toggleTimerBtn()
    {
        if(timer.valid)
        {
            self.stopTimer()
        } else {
            self.startTimer()
        }
        self.refreshTimerBtnTitle()
    }
    
    func refreshTimerBtnTitle ()
    {
        if(timer.valid)
        {
            timerBtn.setTitle(timerbtnTitle[timerOption.Stop.rawValue], forState:.Normal )
        } else {
            timerBtn.setTitle(timerbtnTitle[timerOption.Start.rawValue], forState:.Normal )
        }
        
    }
    
    
    func updateTime() {
        var currentTime = NSDate()
        
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime.timeIntervalSinceDate(startTime)
        
        //calculate the hours in elapsed time.
        let hours = UInt8(elapsedTime / 3600.0)
        elapsedTime -= (NSTimeInterval(hours) * 3600)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strHours   = String(hours)
        let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
        let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
//        let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
//        displayTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        if(hours>0) {
            displayTimeLabel.text = "\(strHours):\(strMinutes):\(strSeconds)"
        } else {
            displayTimeLabel.text = "\(strMinutes):\(strSeconds)"
        }
    }
    
    @IBAction func sideChanged(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case breastSide.Left.rawValue:
            side = .Left
        case breastSide.Right.rawValue:
            side = .Right
        default:
            return
        }
        
    }
    
    func managedContext() -> NSManagedObjectContext {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedConext = delegate.managedObjectContext
        return managedConext!
    }
    
    func addAction(type:String)
    {
        let entity = NSEntityDescription.entityForName("Action", inManagedObjectContext: self.managedContext())
        let action = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: self.managedContext())
        action.setValue(type, forKey: "type")
        action.setValue(startTime, forKey: "time")
        
        var duration = startTime.timeIntervalSinceNow as Double
        action.setValue(duration, forKey: "duration")

        action.setValue(side.rawValue, forKey: "breastside")
        
        var error : NSError?
        if(self.managedContext().save(&error)){
            println(error)
        }
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        self.addAction(self.labelTitle)
        self.navigationController?.popViewControllerAnimated(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
