//
//  AppCoordinatorImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

class AppCoordinatorImpl: Coordinator {

    public let tabBarController: UITabBarController

    private var childCoordinators = [Coordinator]()
    private var dependencies: AppRootDependency

    init(tabBarController: UITabBarController = UITabBarController(), dependencies: AppRootDependency) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }

    public func start() {

        let service = dependencies.makeTaskService()
        var controllers: [UIViewController] = []

        let inBoxCoordinator = dependencies.makeInBoxModule(service: service)
        inBoxCoordinator.parentCoordinator = self
        childCoordinators.append(inBoxCoordinator)
        inBoxCoordinator.start()

        controllers.append(inBoxCoordinator.navigationController)
        controllers.append(dependencies.makeToDayModule(service: service))
        controllers.append(dependencies.makeTaskListModule(service: service))
        controllers.append(dependencies.makeSearchModule(service: service))

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
