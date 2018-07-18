//
//  LandmarkInfoViewController.swift
//  LandmarkHistory
//
//  Created by Daniel Harris on 16/07/2018.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import Foundation

import UIKit
import Kingfisher

class LandmarkInfoViewController: UIViewController {
    
    
    @IBOutlet weak var landmarkImage: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var landmarkTitle: UILabel!
    var info: [String: Any]?
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let info = info,
            let url = info["image"],
            let title = info["Official name"],
            let titleText = title as? String {
            landmarkTitle.text = titleText
            let imageURL = URL(string: url as! String)
            print(url)
            landmarkImage.kf.setImage(with: imageURL)
        }
        infoTableView.reloadData()
    }
    

}

extension LandmarkInfoViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let info = info else { return 0 }
        
        return info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            print("image window cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageWindowCell") as! ImageWindowCell
            
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
            
            if let info = info {
                cell.infoTitle.text = Array(info)[indexPath.row].key
                if let value = Array(info)[indexPath.row].value as? String {
                    cell.infoLabel.text = value
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 77
        }
    }
}


