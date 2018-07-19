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
    var landmark: String?
    
    @IBOutlet weak var landmarkImage: UIImageView!
    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var landmarkTitle: UILabel!
    var info: [String: Any]?
    var cellLengths = [Int]()
    var cellWidth: Int?
    
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
        newInfo.removeValue(forKey: "Coordinates")
        return newInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageWindowCell") as! ImageWindowCell
            cellLengths.append(0)
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
            
            if var newInfo = info {
                newInfo.removeValue(forKey: "image")
                newInfo.removeValue(forKey: "Coordinates")
                newInfo.removeValue(forKey: "Official name")
                if let value = Array(newInfo)[indexPath.row].value as? String {
                    cell.infoTitle.text = Array(newInfo)[indexPath.row].key
                    cell.infoLabel.text = value
                    cell.infoLabel.lineBreakMode = .byWordWrapping
                    let pixels = measureText(value, font: cell.infoLabel.font)
                    cellWidth = cellWidth ?? Int(cell.infoLabel.frame.size.width)
                    cell.infoLabel.numberOfLines = Int(ceil(Double(pixels) / Double(cellWidth!)))
                    cellLengths.append(Int(pixels))
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return CGFloat(67 + ceil(Double(cellLengths[indexPath.row]) / Double(cellWidth!)) * 20)
        }
    }
    
    private func measureText(_ text: String, font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = (text as NSString).size(withAttributes: fontAttributes)
        return size.width
    }
}


