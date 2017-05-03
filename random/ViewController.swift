//
//  ViewController.swift
//  random
//
//  Created by Chris Chadillon on 2017-04-30.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var theCount: UITextField!
    @IBOutlet var rangeSwitch: UISwitch!
    @IBOutlet var theMin: UITextField!
    @IBOutlet var theMax: UITextField!
    
    // We will store the array of random ints from the API here
    var randomNumberArray:[Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doGenerate(_ sender: UIButton) {
        // An array to keep track of the errors found in the input from
        // the user
        var errors = [String]()
        
        // The user enters Ints but, since they are text fields, they start
        // out as Strings.  We typecast them.  We make the int optional since
        // the typecast might not work
        
        let countInt:Int? = Int(self.theCount.text!)
        let minInt:Int? = Int(self.theMin.text!)
        let maxInt:Int? = Int(self.theMax.text!)
        
        // Setup all the conditions needed to find errors.
        // We track 3 errors:
        //
        //  1 - Are fields blank
        //  2 - Are fields actually ints
        //  3 - Is min <= max
        
        if self.theCount.text == "" {
            errors.append("Number of Ints is blank")
        }
        else if countInt == nil {
            errors.append("Number of Ints is not an Integer")
        }
        
        if self.rangeSwitch.isOn {
            let minIsValid = true
            if self.theMin.text == "" {
                errors.append("Minimum is blank")
            }
            else if minInt == nil {
                errors.append("Minimum is not an Integer")
            }
            
            if self.theMax.text == "" {
                errors.append("Maximum is blank")
            }
            else if maxInt == nil {
                errors.append("Maximum is not an Integer")
            } else {
                if minIsValid {
                    if minInt! > maxInt! {
                        errors.append("Minimum is bigger than maximum")
                    }
                }
            }
        }
        
        // We have done our error checking...
        
        if errors.count != 0 {
            // If there are errors in the errors array, call a methods to show an alert
            // with the error.
            showAlert(errorMessage: "Please correct the following error(s): \(errors.joined(separator: ", "))")
        } else {
            // There are no errors, time to use the API
            
            // The API call is a little different depeding on if we specify the range
            if self.rangeSwitch.isOn {
                // Call our method to use the API.  Send the proper URL to the method uding the
                // buildURLForAPICall method
                APIInteractions.getRandomNumbers(theURL: URL(string:buildURLForAPICall(count: countInt!, asRange: true, min:minInt!, max: maxInt!))!, onCompletion: { (theResult: [String:Any]?) -> () in
                    
                    // When the API call is complete, check if we have 1 or more than 1 random number.
                    // In both cases populate the randomNumber array, then switch back to the main thread
                    // and, trigger a segue to the next View
                    if countInt! == 1 {
                        self.randomNumberArray = [theResult!["number"]! as! Int]
                    } else {
                        self.randomNumberArray = theResult!["numbers"]! as! [Int]
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.performSegue(withIdentifier: "RandomNumberSeg", sender: self)
                    })})
                
            } else {
                // Call our method to use the API.  Send the proper URL to the method uding the
                // buildURLForAPICall method
                APIInteractions.getRandomNumbers(theURL: URL(string:buildURLForAPICall(count: countInt!, asRange: false))!, onCompletion: { (theResult: [String:Any]?) -> () in
                    
                    // When the API call is complete, check if we have 1 or more than 1 random number.
                    // In both cases populate the randomNumber array, then switch back to the main thread
                    // and, trigger a segue to the next View
                    if countInt! == 1 {
                        self.randomNumberArray = [theResult!["number"]! as! Int]
                    } else {
                        self.randomNumberArray = theResult!["numbers"]! as! [Int]
                    }

                    DispatchQueue.main.async(execute: { () -> Void in
                        self.performSegue(withIdentifier: "RandomNumberSeg", sender: self)
                    })})
            }
        }
    }
    
    // Little function to show an alert
    func showAlert(errorMessage:String, title:String = "Error") {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // Based on the given parameters, create the for the call to the API
    func buildURLForAPICall(count:Int, asRange:Bool, min:Int = 0, max:Int = 0) -> String {
        var theURL = "http://localhost:8080/json/"
        
        if asRange {
            theURL += "range/\(min)/\(max)"
            if count > 1 {
                theURL += "/\(count)"
            }
        } else {
            theURL += "default"
            if count > 1 {
                theURL += "/\(count)"
            }
        }
        
        return theURL
    }
    
    // When the segue is triggered, be sure to send the random numbers
    // to the next view, so, they can be shown in a table
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RandomNumberSeg" {
            let nextVC = segue.destination as! NumbersViewController
            nextVC.randomNumberArray = self.randomNumberArray
        }
    }
}
