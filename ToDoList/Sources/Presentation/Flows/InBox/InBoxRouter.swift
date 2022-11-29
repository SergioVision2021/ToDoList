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
    func navigationToAddTask(sender: InBoxViewController, repository: TaskRepository)
    func navigationToDetailTask(task: Task, nameSection: String, sender: InBoxViewController)
}

class InBoxRouter: InBoxRoutingLogic {

    public weak var viewController: UIViewController?

    public init(view: UIViewController) {
        viewController = view
    }

    public func navigationToAddTask(sender: InBoxViewController, repository: TaskRepository) {
        let vc = AddTaskModuleBuilder(repository: repository).build()
        viewController?.show(vc, sender: sender)
    }

    public func navigationToDetailTask(task: Task, nameSection: String, sender: InBoxViewController) {
        let vc = DetailTaskModuleBuilder(task: task, nameSection: nameSection, delegate: sender).build()
        viewController?.show(vc, sender: sender)
    }
}
