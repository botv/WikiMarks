//
//  ViewController.swift
//  LandmarkHistory
//
//  Created by Ben Botvinick on 7/16/18.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var testSegueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {return}
        
        if identifier == "toLandmarkInfo" {
            print("Transitioning to info page")
            let destination = segue.destination as! LandmarkInfoViewController
            destination.landmark = "Golden Gate Bridge"
        }
    }
    
    
    @IBAction func testSegueButtonTapped(_ sender: UIButton) {
        
    }
    

}

