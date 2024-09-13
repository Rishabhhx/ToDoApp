//
//  HomeViewModel.swift
//  ToDo
//
//  Created by Rishabh Sharma on 13/09/24.
//

import SwiftUI
import CoreData

@Observable
class HomeViewModel {
    
    // MARK: Properties
    var tasks : [TaskEntity] = []
    var manager = CoreDataManager.shared
    var moveToAddNewTask = false
    var moveToEditTask = false
    
    // MARK: Methods
    func getTasks() {
        do {
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            tasks = try manager.context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    func deleteTask(task: TaskEntity) {
        manager.context.delete(task)
        tasks.removeAll(where: {$0 == task})
        manager.saveItem()
    }
    
    func completeTask(task: TaskEntity) {
        task.isCompleted.toggle()
        self.manager.saveItem()
    }
}
