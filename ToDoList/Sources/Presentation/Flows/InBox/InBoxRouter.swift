//
//  InBoxRouter.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 21.11.22.
//

import Foundation
import UIKit

protocol InBoxRoutingLogic {
    var viewController: UIViewController? { get set }
    func navigationToAddTask(repository: TaskRepository, sender: InBoxViewController)
    func navigationToDetailTask(task: Task, nameSection: String,
                                repository: TaskRepository, sender: InBoxViewController)
}

class InBoxRouter: InBoxRoutingLogic {

    public weak var viewController: UIViewController?

    public init(view: UIViewController) {
        viewController = view
    }

    public func navigationToAddTask(repository: TaskRepository, sender: InBoxViewController) {
        let vc = AddTaskModuleBuilder(repository: repository).build()
        viewController?.show(vc, sender: sender)
    }

    public func navigationToDetailTask(task: Task, nameSection: String, repository: TaskRepository, sender: InBoxViewController) {
        let vc = DetailTaskModuleBuilder(task: task, nameSection: nameSection, repository: repository).build()
        viewController?.show(vc, sender: sender)
    }
}
