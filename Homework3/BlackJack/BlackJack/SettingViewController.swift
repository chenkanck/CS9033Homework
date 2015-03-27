//
//  SettingViewController.swift
//  BlackJack
//
//  Created by Kan Chen on 2/27/15.
//  Copyright (c) 2015 KanChen. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        DecksNum.resignFirstResponder()
        PlayerNumber.resignFirstResponder()
    }
    
    @IBOutlet weak var DecksNum: UITextField!
    @IBOutlet weak var PlayerNumber: UITextField!
    let minDeck = 1
    let maxDeck = 5
    let minPlayer = 1
    let maxPlayer = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        self.DecksNum.text = "3"
        self.PlayerNumber.text = "2"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickStart(sender: AnyObject) {
        if DecksNum.text.toInt() == nil || PlayerNumber.text.toInt()==nil {
            messageBox()
            return
        }
        if DecksNum.text.toInt() <= maxDeck && DecksNum.text.toInt() >= minDeck &&
            PlayerNumber.text.toInt() <= maxPlayer && PlayerNumber.text.toInt() >= minPlayer {
            performSegueWithIdentifier("forward", sender: self)
        }else {
            messageBox()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "forward" {
            let controller = segue.destinationViewController as ViewController
            controller.playerNum = PlayerNumber.text
            controller.deckNum = DecksNum.text
        }
    
    }
    
    func messageBox() {
        let alertController = UIAlertController(title: "Game Setting", message:
            "Invalid Input", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
