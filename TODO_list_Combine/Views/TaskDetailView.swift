//
//  TaskDetailView.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 04.01.2024.
//

import SwiftUI
import Combine

struct TaskDetailView: View {
    @ObservedObject var task: Task
    @State private var taskCompleted: Bool
    @State private var cancellables: Set<AnyCancellable> = []
    @Environment(\.presentationMode) var presentationMode
    
    init(task: Task) {
        self.task = task
        _taskCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        VStack {
            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .foregroundColor(.black)
            .padding(.top, -200)
            .padding(.trailing, 290)
            
            Text(task.title)
                .font(.title)

            Text(task.description)
                .padding()

            Toggle("Completed", isOn: $taskCompleted)
                .padding()
                .onReceive(task.$isCompleted) { newValue in
                    taskCompleted = newValue
                }

            ForEach(task.subtasks) { subtask in
                HStack {
                    Text(subtask.title)
                        .strikethrough(subtask.isCompleted)
                        .foregroundColor(subtask.isCompleted ? .gray : .primary)
                    Spacer()
                    Button(action: {
                        subtask.isCompleted.toggle()
                    }, label: {
                        Image(systemName: subtask.isCompleted ? "checkmark.square" : "square")
                            .foregroundColor(subtask.isCompleted ? .green : .primary)
                    })
                }
                .padding()
            }
        }
        .navigationBarTitle("Task Detail")
    }
}

#if DEBUG
#Preview {
    TaskDetailView(task: Task(title: "test 1", description: "miy", subtasks: [Subtask(title: "test a"), Subtask(title: "test b"), Subtask(title: "test c")]))
}
#endif
