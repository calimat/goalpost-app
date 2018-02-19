//
//  GoalsVC.swift
//  goalpost-app
//
//  Created by Ricardo Herrera Petit on 2/18/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import CoreData

class GoalsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        print("btn was pressed")
    }
    
}

