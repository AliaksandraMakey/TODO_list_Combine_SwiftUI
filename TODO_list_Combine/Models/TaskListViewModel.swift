//
//  TaskListViewModel.swift
//  TODO_list_Combine
//
//  Created by Александра Макей on 03.01.2024.
//

import SwiftUI
import Combine

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    private var cancellables: Set<AnyCancellable> = []

    func addTask(task: Task) {
        tasks.append(task)
        saveTasksToUserDefaults()
    }

    func removeTask(at index: Int) {
        guard tasks.indices.contains(index) else {
            return
        }
        let removedTask = tasks.remove(at: index)

        removedTaskFromUserDefaults(task: removedTask)
    }

    func saveTasksToUserDefaults() {
        let encodedTasks = try? JSONEncoder().encode(tasks)
        UserDefaults.standard.set(encodedTasks, forKey: "tasks")
    }

    func removedTaskFromUserDefaults(task: Task) {
        $tasks
            .sink { [weak self] updatedTasks in
                self?.updateTasksInUserDefaults(updatedTasks)
            }
            .store(in: &cancellables)
    }

    private func updateTasksInUserDefaults(_ updatedTasks: [Task]) {
        let updatedEncodedTasks = try? JSONEncoder().encode(updatedTasks)
        UserDefaults.standard.set(updatedEncodedTasks, forKey: "tasks")
    }

    func loadTasksFromUserDefaults() {
        if let encodedTasks = UserDefaults.standard.data(forKey: "tasks") {
            Just(encodedTasks)
                .decode(type: [Task].self, decoder: JSONDecoder())
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error decoding tasks: \(error)")
                    }
                } receiveValue: { [weak self] decodedTasks in
                    self?.tasks = decodedTasks
                }
                .store(in: &cancellables)
        }
    }
}
