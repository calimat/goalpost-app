//
//  GoalDataService.swift
//  goalpost-app
//
//  Created by Ricardo Herrera Petit on 2/20/18.
//  Copyright © 2018 Ricardo Herrera Petit. All rights reserved.
//

import Foundation

class GoalDataService {
    static let instance = GoalDataService()
    
    
    var indexPathForGoalToBeDeleted:IndexPath?

    var goalToBeRemoved:RemoveGoal?
    
    func save(goalDescription:String, goalType:GoalType, goalCompletionValue:Int32, progress:Int32,  completion: (_ finished:Bool) ->() ) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else{ return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = goalCompletionValue
        goal.goalProgress = progress
        
        do {
            try  managedContext.save()
            print("Successfully saved data.")
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
        
        
    }
    
    func save(goal:Goal) {
        
        guard let goalDescription =  goal.goalDescription else { return }
        
        save(goalDescription: goalDescription, goalType: GoalType(rawValue: goal.goalType!)!, goalCompletionValue: goal.goalCompletionValue, progress: goal.goalProgress, completion: { (completed) in
                print("completed saving goal")
            })
    }
}
