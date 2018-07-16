//
//  LandmarkInfoViewController.swift
//  LandmarkHistory
//
//  Created by Daniel Harris on 16/07/2018.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import Foundation

import UIKit

class LandmarkInfoViewController: UIViewController {
    
    
    @IBOutlet weak var infoTableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    

}

extension LandmarkInfoViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell")
        cell?.textLabel?.text = "tester"
        
        return cell!
    }
}


