//
//  TaskTableViewCell.swift
//  ToDo
//
//  Created by Rishabh Sharma on 12/09/24.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var dueDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(task: TaskEntity) {
        titleLabel.text = task.titleText
        descriptionLabel.text = task.descriptionText
        dueDate.text =  task.dateText?.formatted(date: .numeric, time: .omitted)
    }
}
