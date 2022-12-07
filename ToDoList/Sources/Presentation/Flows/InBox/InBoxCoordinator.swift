//
//  InBoxCoordinator.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 6.12.22.
//

import Foundation
import UIKit

class InBoxCoordinator: Coordinator {

    public var navigationController: UINavigationController
    public weak var parentCoordinator: AppCoordinatorImpl?

    private var childCoordinators = [Coordinator]()
    private var service: TaskServiceLogic

    init(navigationController: UINavigationController,
         service: TaskServiceLogic) {
        self.navigationController = navigationController
        self.service = service
    }

    public func start() {
        let vc = InBoxModuleBuilder(coordinator: self, service: service).build()
        navigationController.pushViewController(vc, animated: true)
    }

    public func showAddTaskView(repository: TaskRepository) {
        let child = AddTaskCoordinator(navigationController: navigationController, repository: repository)
        child.parentCoordinator = self
        child.start()
        childCoordinators.append(child)
    }

    public func showDetailTaskView(vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
}
