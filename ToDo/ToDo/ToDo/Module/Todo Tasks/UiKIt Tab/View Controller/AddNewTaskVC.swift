//
//  AddNewTaskVC.swift
//  ToDo
//
//  Created by Rishabh Sharma on 12/09/24.
//

import UIKit
import CoreData

enum ScreenType {
    case create
    case edit
}

protocol AddNewTaskProtocol: AnyObject {
    func reloadTaskOnHome()
}

class AddNewTaskVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet private weak var headingLable: UILabel!
    @IBOutlet private weak var titleTextfield: UITextField!
    @IBOutlet private weak var descTextview: UITextView!
    @IBOutlet private weak var dueDatePicker: UIDatePicker!
    @IBOutlet private weak var confirmButton: UIButton!
    
    // MARK: Properties
    var manager = CoreDataManager.shared
    weak var delegate: AddNewTaskProtocol?
    var screenType : ScreenType = .create
    var task : TaskEntity?
    
    // MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialzeSetup()
    }
    
    // MARK: Private Functions
    private func initialzeSetup() {
        titleTextfield.delegate = self
        descTextview.delegate = self
        dueDatePicker.minimumDate = Date()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tapGesture)
        switch screenType {
        case .create:
            headingLable.text = "Create Task"
        case .edit:
            headingLable.text = "Edit Task"
        }
        titleTextfield.text = task?.titleText
        descTextview.text = task?.descriptionText
        dueDatePicker.date = task?.dateText ?? Date()
        updateConfirmButtonState()
    }
    @objc private func endEditing() {
        view.endEditing(true)
    }
    
    private func updateConfirmButtonState () {
        if titleTextfield.text == "" || descTextview.text == "" {
            confirmButton.isEnabled = false
        } else {
            confirmButton.isEnabled = true
        }
    }
    
    // MARK: Actions
    @IBAction func confirmButton(_ sender: Any) {
        switch screenType {
        case .create:
            let data = TaskEntity(context: manager.context)
            data.titleText = titleTextfield.text
            data.descriptionText = descTextview.text
            data.dateText = dueDatePicker.date
            data.isCompleted = false
        case .edit:
            task?.titleText = titleTextfield.text
            task?.descriptionText = descTextview.text
            task?.dateText = dueDatePicker.date
        }
        manager.saveItem()
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.reloadTaskOnHome()
        }
    }
}

// MARK: Textfield Delegate
extension AddNewTaskVC: UITextFieldDelegate {
    @IBAction func titleTextfieldEditing(_ sender: Any) {
        updateConfirmButtonState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Textview Delegate
extension AddNewTaskVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateConfirmButtonState()
    }
}
