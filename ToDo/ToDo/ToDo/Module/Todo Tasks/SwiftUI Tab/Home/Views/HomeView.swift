//
//  HomeView.swift
//  ToDo
//
//  Created by Rishabh Sharma on 13/09/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    // MARK: Properties
    @State private var viewModel = HomeViewModel()
    @State private var task: TaskEntity?
    
    // MARK: Views
    var body: some View {
        NavigationStack() {
            ZStack {
                if viewModel.tasks.count == 0 {
                    ContentUnavailableView("No task available", systemImage: "note.text", description: Text("Add new task to your todo list form above"))
                } else {
                    TaskListView(task: $task)
                }
            }
            .onAppear() {
                viewModel.getTasks()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("ToDo")
            .toolbar {
                AddNewTaskButton(moveToAddNewTask: $viewModel.moveToAddNewTask)
            }
            .environment(viewModel)
            .sheet(isPresented: $viewModel.moveToAddNewTask, onDismiss: {
                viewModel.getTasks()
            }, content: {
                AddNewTaskView()
            })
            .sheet(isPresented: $viewModel.moveToEditTask, onDismiss: {
                viewModel.getTasks()
            }, content: {
                AddNewTaskView(task: task, screenType: .edit)
            })
        }
    }
}

#Preview {
    HomeView()
}

struct AddNewTaskButton: View {
    
    // MARK: Properties
    @Environment(HomeViewModel.self) private var viewModel
    @Binding var moveToAddNewTask: Bool

    // MARK: View
    var body: some View {
        Button {
            moveToAddNewTask.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
}

struct TaskView: View {
    
    // MARK: Properties
    var task: TaskEntity
    
    // MARK: View
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            VStack(alignment: .leading, spacing: 0) {
                Text(task.titleText ?? "")
                    .font(.system(size: 24))
                Text(task.descriptionText ?? "")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Spacer()
                Text("Due: \(task.dateText?.formatted(date: .numeric, time: .omitted) ?? "")")
                    .font(.system(size: 13))
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
        .listRowInsets(EdgeInsets())
    }
}

struct TaskListView: View {
    
    // MARK: Properties
    @Environment(HomeViewModel.self) private var viewModel
    @Binding var task: TaskEntity?

    // MARK: View
    var body: some View {
        List {
            Section {
                ForEach(viewModel.tasks, id: \.self) { task in
                    TaskView(task: task)
                        .swipeActions(edge: .leading) {
                            if task.isCompleted {
                                undoAction(task: task)
                            } else {
                                completeAction(task: task)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            deleteAction(task: task)
                            editAction(task: task)
                        }
                }
            } header: {
                Text("List of Tasks")
            }
        }
        .listStyle(.plain)
    }
    
    private func undoAction(task: TaskEntity) -> some View {
        Button {
            viewModel.completeTask(task: task)
            viewModel.getTasks()
        } label: {
            VStack {
                Image(systemName: "checkmark.gobackward")
                Text("Undo")
            }
        }
        .tint(.pink)
    }
    
    private func completeAction(task: TaskEntity) -> some View {
        Button {
            viewModel.completeTask(task: task)
            viewModel.getTasks()
        } label: {
            VStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Mark Done")
            }
        }
        .tint(.green)
    }

    private func deleteAction(task: TaskEntity) -> some View {
        
        Button(role: .destructive) {
            withAnimation {
                viewModel.deleteTask(task: task)
            }
        } label: {
            VStack {
                Image(systemName: "wrongwaysign.fill")
                Text("Delete")
            }
        }
        .tint(.red)
    }
    
    private func editAction(task: TaskEntity) -> some View {
        Button {
            self.task = task
            viewModel.moveToEditTask.toggle()
        } label: {
            VStack {
                Image(systemName: "note.text")
                Text("Edit")
            }
        }
        .tint(Color(red: 255/255, green: 128/255, blue: 0/255))
    }
}
