//
//  InBoxCoordinator.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 6.12.22.
//

import Foundation
import UIKit

class InBoxCoordinator: Coordinator {

    public let navigationController: UINavigationController
    public weak var parentCoordinator: AppCoordinatorImpl?
    private var service: TaskServiceLogic

    init(navigationController: UINavigationController = UINavigationController(),
         service: TaskServiceLogic) {
        self.navigationController = navigationController
        self.service = service
    }

    public func start() {
        let vc = InBoxModuleBuilder(router: self, service: service).build()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension InBoxCoordinator: InBoxRouter {

    func navigationToAddTask(repository: TaskRepository) {
        let vc = AddTaskModuleBuilder(router: self, repository: repository).build()
        navigationController.pushViewController(vc, animated: true)
    }

    func navigationToDetailTask(task: Task, nameSection: String, repository: TaskRepository, sender: InBoxViewController) {
        let vc = DetailTaskModuleBuilder(task: task, nameSection: nameSection, repository: repository).build()
        navigationController.pushViewController(vc, animated: true)
    }
}

extension InBoxCoordinator: AddTaskRouter {

    func navigationToSelectDate(sender: AddTaskViewController) {
        var vc = SelectDataModuleBuilder().build()

        vc.onSelectDate = { result in
            sender.scheduleDate = result
            sender.scheduleDateButton.setTitle(ConvertDate().convert(from: result), for: .normal)
            return
        }

        navigationController.pushViewController(vc, animated: true)
    }
}
