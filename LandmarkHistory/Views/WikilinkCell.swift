//
//  WikilinkCell.swift
//  LandmarkHistory
//
//  Created by Robert May on 7/19/18.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import UIKit

class WikilinkCell: UITableViewCell {
    
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var wikiLinkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.myView.addGestureRecognizer(gesture)
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        if let urlString = wikiLinkLabel.text,
            urlString != "Not found",
            let url = NSURL(string: urlString){
            UIApplication.shared.open(url as URL)
        }
    }
}
