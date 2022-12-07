//
//  AddTaskCoordinator.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 6.12.22.
//

import Foundation
import UIKit

class AddTaskCoordinator: Coordinator {

    public var navigationController: UINavigationController
    public weak var parentCoordinator: InBoxCoordinator?

    private var repository: TaskRepository

    init(navigationController: UINavigationController, repository: TaskRepository) {
        self.navigationController = navigationController
        self.repository = repository
    }

    public func start() {
        let vc = AddTaskModuleBuilder(coordinator: self, repository: repository).build()
        navigationController.pushViewController(vc, animated: true)
    }

    public func showSelectDateView(vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
}
