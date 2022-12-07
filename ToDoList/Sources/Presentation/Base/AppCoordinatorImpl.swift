//
//  AppCoordinatorImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

class AppCoordinatorImpl: Coordinator {

    public var tabBarController: UITabBarController

    private var childCoordinators = [Coordinator]()
    private var dependencies: AppRootDependency

    init(tabBarController: UITabBarController = UITabBarController(), dependencies: AppRootDependency) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }

    public func start() {

        let service = dependencies.makeTaskService()
        var controllers: [UIViewController] = []

        let child = InBoxCoordinator(navigationController: UINavigationController(), service: service)
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()

        controllers.append(dependencies.makeInBoxModule(coordinator: child))
        controllers.append(dependencies.makeToDayModule(service: service))
        controllers.append(dependencies.makeTaskListModule(service: service))
        controllers.append(dependencies.makeSearchModule(service: service))

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
