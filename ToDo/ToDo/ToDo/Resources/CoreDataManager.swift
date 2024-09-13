//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Rishabh Sharma on 12/09/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ToDoDataModel")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print(error)
            } else {
                print("Success")
            }
        }
        context = container.viewContext
    }
    
    func saveItem() {
        do {
            print("SAVED DATA")
            try context.save()
        } catch {
            print(error)
        }
    }
}
