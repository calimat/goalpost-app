//
//  GoalCell.swift
//  goalpost-app
//
//  Created by Ricardo Herrera Petit on 2/18/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    
    func configureCell(description: String, type: GoalType, goalProgressAmount:Int) {
        self.goalProgressLbl.text = description
        self.goalTypeLbl.text = type.rawValue
        self.goalProgressLbl.text = String(describing: goalProgressAmount)
        
    }

}
