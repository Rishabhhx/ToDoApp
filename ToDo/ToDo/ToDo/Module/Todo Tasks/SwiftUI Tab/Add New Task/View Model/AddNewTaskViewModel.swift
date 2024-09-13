//
//  AddNewTaskViewModel.swift
//  ToDo
//
//  Created by Rishabh Sharma on 13/09/24.
//

import SwiftUI
import CoreData

@Observable
class AddNewTaskViewModel {
    
    //MARK: Properties
    var titleText: String = ""
    var descriptionText: String = ""
    var date: Date = Date()
    var manager = CoreDataManager.shared
    
    //MARK: Methods
    func confimButtonAction(screenType: ScreenType, task: TaskEntity?) {
        switch screenType {
        case .create:
            let data = TaskEntity(context: manager.context)
            data.titleText = titleText
            data.descriptionText = descriptionText
            data.dateText = date
            data.isCompleted = false
        case .edit:
            task?.titleText = titleText
            task?.descriptionText = descriptionText
            task?.dateText = date
        }
        manager.saveItem()
    }
}
