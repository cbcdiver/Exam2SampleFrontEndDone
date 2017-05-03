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
    
    var randomNumberArray:[Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doGenerate(_ sender: UIButton) {
        var errors = [String]()
        
        let countInt:Int? = Int(self.theCount.text!)
        let minInt:Int? = Int(self.theMin.text!)
        let maxInt:Int? = Int(self.theMax.text!)
        
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
        
        if errors.count != 0 {
            showAlert(errorMessage: "Please correct the following error(s): \(errors.joined(separator: ", "))")
        } else {
            if self.rangeSwitch.isOn {
                APIInteractions.getRandomNumbers(theURL: URL(string:buildURLForAPICall(count: countInt!, asRange: true, min:minInt!, max: maxInt!))!, onCompletion: { (theResult: [String:Any]?) -> () in
                    
                    if countInt! == 1 {
                        self.randomNumberArray = [theResult!["number"]! as! Int]
                    } else {
                        self.randomNumberArray = theResult!["numbers"]! as! [Int]
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.performSegue(withIdentifier: "RandomNumberSeg", sender: self)
                    })})
                
            } else {
                APIInteractions.getRandomNumbers(theURL: URL(string:buildURLForAPICall(count: countInt!, asRange: false))!, onCompletion: { (theResult: [String:Any]?) -> () in
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
    
    func showAlert(errorMessage:String, title:String = "Error") {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RandomNumberSeg" {
            let nextVC = segue.destination as! NumbersViewController
            nextVC.randomNumberArray = self.randomNumberArray
        }
    }
}
