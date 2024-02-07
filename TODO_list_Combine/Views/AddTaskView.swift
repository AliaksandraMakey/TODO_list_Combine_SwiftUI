//
//  AddTaskView.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 03.01.2024.
//

import SwiftUI
import Combine

struct AddTaskView: View {
    @ObservedObject var viewModel: TaskListViewModel
    @State private var taskTitle: String = ""
    @State private var taskDescription: String = ""
    @State private var subtaskTitle: String = ""
    @State private var subtasks: [Subtask] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    TextField("Enter task title", text: $taskTitle)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    TextField("Enter task description", text: $taskDescription)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    ForEach(subtasks.indices, id: \.self) { index in
                        HStack {
                            TextField("Enter subtask", text: $subtasks[index].title)
                                .padding()
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                subtasks.remove(at: index)
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    Button(action: {
                        subtasks.append(Subtask(title: ""))
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.blue)
                            Text("Add Subtask")
                        }
                    }
                    .padding()

                    Button("Add Task") {
                        let newTask = Task(title: taskTitle, description: taskDescription, subtasks: subtasks)
                        viewModel.addTask(task: newTask)
                        taskTitle = ""
                        taskDescription = ""
                        subtasks = []
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Add Task")
        }
    }
}
