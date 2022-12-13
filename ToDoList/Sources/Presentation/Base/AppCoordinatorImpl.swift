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

        var controllers: [UIViewController] = []

        let inBoxCoordinator = dependencies.makeInBoxModule()
        inBoxCoordinator.parentCoordinator = self
        childCoordinators.append(inBoxCoordinator)
        inBoxCoordinator.start()

        controllers.append(inBoxCoordinator.navigationController)
        controllers.append(dependencies.makeToDayModule())
        controllers.append(dependencies.makeTaskListModule())
        controllers.append(dependencies.makeSearchModule())

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
