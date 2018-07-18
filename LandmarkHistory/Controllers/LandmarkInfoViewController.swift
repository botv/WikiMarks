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
    var cellTypes = [String]()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if var info = info,
            let url = info["image"],
            let title = info["Official name"],
            let titleText = title as? String {
            landmarkTitle.text = titleText
            let imageURL = URL(string: url as! String)
            print(url)
            landmarkImage.kf.setImage(with: imageURL)
        }
    }
    

}

extension LandmarkInfoViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard var newInfo = info else { return 0 }
        newInfo.removeValue(forKey: "image")
        newInfo.removeValue(forKey: "Official name")
        return newInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageWindowCell") as! ImageWindowCell
            cellTypes.append("image")
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
            
            if var newInfo = info {
                newInfo.removeValue(forKey: "image")
                newInfo.removeValue(forKey: "Official name")
                if let value = Array(newInfo)[indexPath.row].value as? String {
                    if value.count <= 20 {
                        cell.infoTitle.text = Array(newInfo)[indexPath.row].key
                        cell.infoLabel.text = value
                        cellTypes.append("short")
                    } else {
                        let longCell = tableView.dequeueReusableCell(withIdentifier: "LongInfoCell") as! LongInfoCell
                        longCell.infoTitle.text = Array(newInfo)[indexPath.row].key
                        longCell.infoLabel.text = value
                        cellTypes.append("long")
                        return longCell
                    }
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            if cellTypes[indexPath.row] == "long" {
                return 120
            } else {
                return 77
            }
        }
    }
}


