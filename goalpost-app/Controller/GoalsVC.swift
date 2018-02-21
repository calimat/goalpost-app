//
//  GoalsVC.swift
//  goalpost-app
//
//  Created by Ricardo Herrera Petit on 2/18/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    @IBOutlet weak var goalRemoveLbl: UILabel!
    @IBOutlet weak var undoBtn: UIButton!
    
    var goals: [Goal] = []
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        hide(viewandItsElements: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }

    func fetchCoreDataObjects() {
        self.fetch { (complete) in
            if complete {
                if goals.count >= 1 {
                    tableView.isHidden = false
                    
                } else {
                    tableView.isHidden = true
                    
                }
            }
        }
    }
    
    @IBAction func addGoalBtnWasPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC") else { return }
        presentDetail(createGoalVC)
    }
    
    @IBAction func undoBtnWasPressed(_ sender: Any) {
        print("undo button pressed")
        guard let removedGoal = GoalDataService.instance.goalToBeRemoved else { return }
        guard  let indexPathForRemovedGoal = GoalDataService.instance.indexPathForGoalToBeDeleted  else { return }
        
      // self.goals.insert(removedGoal, at: indexPathForRemovedGoal.row)
        GoalDataService.instance.save(goalDescription: removedGoal.description, goalType: removedGoal.goalType, goalCompletionValue: removedGoal.completionValue, progress: removedGoal.progress) { (completed) in
            
        }
        fetchCoreDataObjects()
        self.tableView.reloadData()
      //  GoalDataService.instance.goalToBeRemoved = nil
      //  GoalDataService.instance.indexPathForGoalToBeDeleted = nil
        self.hide(viewandItsElements: true)
        
    }
    
}


extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as? GoalCell else { return UITableViewCell()}
        let goal = goals[indexPath.row]
        
        cell.configureCell(goal: goal)
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (rowAction, indexPath) in
            let removingGoal = self.goals[indexPath.row]
            GoalDataService.instance.goalToBeRemoved = RemoveGoal(description: removingGoal.goalDescription!, completionValue: removingGoal.goalCompletionValue, progress: removingGoal.goalProgress, goalType: GoalType(rawValue: removingGoal.goalType!)!)
            
            GoalDataService.instance.indexPathForGoalToBeDeleted = indexPath
            self.removeGoal(atIndexPath: indexPath)
            
            self.fetchCoreDataObjects()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            self.hide(viewandItsElements: false)
            
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { (rowAction, indexPath) in
            self.setprogress(atIndexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9385011792, green: 0.7164435983, blue: 0.3331357837, alpha: 1)
        
        return [deleteAction, addAction]
        
    }
    
}

extension GoalsVC {
    
    func hide(viewandItsElements ishidden: Bool) {
        self.undoView.isHidden = ishidden
        self.undoBtn.isHidden = ishidden
        self.goalRemoveLbl.isHidden = ishidden
        
    }
    
    func setprogress(atIndexPath indexPath:IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else  { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress = chosenGoal.goalProgress + 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
            print("Sucessfully set progress!")
        } catch {
            debugPrint("Could not set progress: \(error.localizedDescription)")
        }
        
    }
    
    func removeGoal(atIndexPath indexPath:IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else  { return}
        managedContext.delete(goals[indexPath.row])
        do {
            try managedContext.save()
            print("Succesfully removed goal!")
        } catch {
            debugPrint("Could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetch(completion: (_ complete:Bool) -> () ) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
           goals =  try managedContext.fetch(fetchRequest)
           completion(true)
            print("Successfully fetched data")
        } catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
            completion(false)
        }
       
    }
    

}
