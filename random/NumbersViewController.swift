//
//  NumbersViewController.swift
//  random
//
//  Created by Chris Chadillon on 2017-05-03.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import UIKit

class NumbersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var randomNumberArray:[Int]!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.randomNumberArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theCell = self.tableView.dequeueReusableCell(withIdentifier: "TheCell")
        theCell?.textLabel?.text = String(self.randomNumberArray[indexPath.row])
        return theCell!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.randomNumberArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
