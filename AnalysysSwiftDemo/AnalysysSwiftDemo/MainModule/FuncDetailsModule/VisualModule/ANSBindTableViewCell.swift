//
//  ANSBindTableViewCell.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/27.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class ANSBindTableViewCell: UITableViewCell {

    @IBOutlet weak var ans_titleLab: UILabel!
    @IBOutlet weak var ans_clickBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func zan_click(_ sender: Any) {
    }
    
}
