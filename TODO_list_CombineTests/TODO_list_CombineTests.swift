//
//  TODO_list_CombineTests.swift
//  TODO_list_CombineTests
//
//  Created by Александра Макей on 05.02.2024.
//

import XCTest
import Combine
@testable import TODO_list_Combine

final class TODO_list_CombineTests: XCTestCase {
    var viewModel: TaskListViewModel?
    var subscriptions: Set<AnyCancellable>?
    
    override func setUpWithError() throws {
        viewModel = TaskListViewModel()
        subscriptions = Set<AnyCancellable>()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        subscriptions = []
    }

    func testAddTask() throws {
        let expectation = XCTestExpectation(description: "Task added")
        
        // Given
        let task = Task(title: "Test Task", description: "Test Description")
        
        // When
        viewModel?.addTask(task: task)
        
        // Then
        viewModel?.$tasks.sink { tasks in
            XCTAssertTrue(tasks.contains(task))
            expectation.fulfill()
        }.store(in: &subscriptions!)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testRemoveTask() throws {
        let expectation = XCTestExpectation(description: "Task removed")
        
        // Given
        let task = Task(title: "Test Task", description: "Test Description")
        viewModel?.addTask(task: task)
        
        // When
        viewModel?.removeTask(at: 0)
        
        // Then
        viewModel?.$tasks.sink { tasks in
            XCTAssertFalse(tasks.contains(task))
            expectation.fulfill()
        }.store(in: &subscriptions!)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testLoadTasksFromUserDefaults() throws {
        let expectation = XCTestExpectation(description: "Tasks loaded from UserDefaults")
        
        // Given
        let task = Task(title: "Test Task", description: "Test Description")
        let encodedTasks = try! JSONEncoder().encode([task])
        UserDefaults.standard.set(encodedTasks, forKey: "tasks")
        
        // When
        viewModel?.loadTasksFromUserDefaults()
        
        // Then
        viewModel?.$tasks.sink { tasks in
            XCTAssertTrue(tasks.contains(task))
            expectation.fulfill()
        }.store(in: &subscriptions!)
        
        wait(for: [expectation], timeout: 1)
    }
}
