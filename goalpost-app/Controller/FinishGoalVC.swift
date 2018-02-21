//
//  FinishGoalVC.swift
//  goalpost-app
//
//  Created by Ricardo Herrera Petit on 2/19/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription:String!
    var goalType: GoalType!
    
    
    func initData(description:String , type:GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
        pointsTextField.delegate = self 
    }

    @IBAction func createGoalBtnWasPressed(_ sender: Any) {
        if pointsTextField.text != "" {
           
            GoalDataService.instance.save(goalDescription: self.goalDescription, goalType: self.goalType, goalCompletionValue: Int32(pointsTextField.text!)!, progress: 0, completion: { (complete) in
                if complete {
                    dismiss(animated: true, completion: nil)
                }
            })
           
        }
        
        
    }
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismissDetail()
    }
    
   
}
