//
//  TodoLostView.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 04.01.2024.
//

import SwiftUI
import Combine

struct TodoListView: View {
    @ObservedObject var viewModel = TaskListViewModel()
    @State private var isTaskDetailPresented = false
    @State private var selectedTask: Task?
    @State private var tasks: [Task] = []
    @State private var cancellables: Set<AnyCancellable> = []
    
    var body: some View {
        NavigationView {
            List {
                ForEach(tasks) { task in
                    ZStack {
                        HStack {
                            Text(task.title)
                                .foregroundColor(task.isCompleted ? .gray : .primary)
                                .onTapGesture {
                                    selectedTask = task
                                    navigateToDetailView(task: task)
                                }
                        }
                    }
                    .frame(width: 200, height: 40)
                }
                .onDelete(perform: { indexSet in
                    if let firstIndex = indexSet.first {
                        viewModel.removeTask(at: firstIndex)
                    }
                })
            }
            
            .navigationBarTitle("TODO List")
            
            .navigationBarItems(trailing: NavigationLink(destination: AddTaskView(viewModel: viewModel)) {
                Text("Add Task")
            })
        }
        .onAppear {
            viewModel.loadTasksFromUserDefaults()
            viewModel.$tasks
                .receive(on: DispatchQueue.main)
                .sink { updatedTasks in
                    tasks = updatedTasks
                }
                .store(in: &cancellables)
        }
    }
    
    func navigateToDetailView(task: Task) {
        selectedTask = task
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            let destinationView = TaskDetailView(task: task)
            let hostingController = UIHostingController(rootView: destinationView)
            hostingController.modalPresentationStyle = .fullScreen
            UIApplication.shared.windows.first?.rootViewController?.present(hostingController, animated: true, completion: nil)
        }
    }
}
