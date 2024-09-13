//
//  AddNewTaskView.swift
//  ToDo
//
//  Created by Rishabh Sharma on 13/09/24.
//

import SwiftUI
import CoreData

struct AddNewTaskView: View {
    
    // MARK: Properties
    var task : TaskEntity?
    @State private var viewModel = AddNewTaskViewModel()
    var screenType : ScreenType = .create

    // MARK: View
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            Text(screenType == .create ? "Create Task" : "Edit Task")
                .font(.system(size: 33))
                .fontWeight(.black)
            VStack(alignment: .leading, spacing: 20) {
                Text("Title")
                TextField("", text: $viewModel.titleText)
                    .textFieldStyle(.roundedBorder)
                Text("Description")
                TextEditor(text: $viewModel.descriptionText)
                    .frame(height: 70)
                DatePicker("", selection: $viewModel.date, in: Date.now..., displayedComponents: .date)
                    .frame(width: 120)
            }
            Spacer()
            ConfirmButtonView(task: task, screenType: screenType)
        }
        .environment(viewModel)
        .onAppear() {
            viewModel.titleText = task?.titleText ?? ""
            viewModel.descriptionText = task?.descriptionText ?? ""
            viewModel.date = task?.dateText ?? Date()
        }
        .padding([.top,.horizontal], 20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(UIColor.systemGroupedBackground))
    }
}

#Preview {
    AddNewTaskView()
}

struct ConfirmButtonView: View {
    
    // MARK: Properties
    @Environment(AddNewTaskViewModel.self) private var viewModel
    @Environment(\.dismiss) private var dismiss
    var task : TaskEntity?
    var screenType : ScreenType
    
    // MARK: View
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.confimButtonAction(screenType: screenType, task: task)
                dismiss()
            }, label: {
                Text("Confirm")
            })
            .disabled(viewModel.titleText == "" || viewModel.descriptionText == "")
            .buttonStyle(BorderedProminentButtonStyle())
            Spacer()
        }
    }
}
