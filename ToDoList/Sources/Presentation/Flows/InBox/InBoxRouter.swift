//  swiftlint:disable all
//  InBoxRouter.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.11.22.
//

import Foundation
import UIKit

protocol InBoxRoutingLogic {
    var coordinator: InBoxCoordinator? { get set }
    func navigationToAddTask(repository: TaskRepository)
    func navigationToDetailTask(task: Task, nameSection: String,
                                repository: TaskRepository, sender: InBoxViewController)
}

class InBoxRouter: InBoxRoutingLogic {

    public weak var coordinator: InBoxCoordinator?

    init(coordinator: InBoxCoordinator) {
        self.coordinator = coordinator
    }

    public func navigationToAddTask(repository: TaskRepository) {
        coordinator?.showAddTaskView(repository: repository)
    }

    public func navigationToDetailTask(task: Task, nameSection: String, repository: TaskRepository, sender: InBoxViewController) {
        let vc = DetailTaskModuleBuilder(task: task, nameSection: nameSection, repository: repository).build()

        coordinator?.showDetailTaskView(vc: vc)
    }
}
