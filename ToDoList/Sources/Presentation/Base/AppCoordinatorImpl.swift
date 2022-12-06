//
//  AppCoordinatorImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

class AppCoordinatorImpl: Coordinator {

    var tabBarController: UITabBarController

    private var dependencies: AppRootDependency

    init(tabBarController: UITabBarController = UITabBarController(), dependencies: AppRootDependency) {
        self.tabBarController = tabBarController
        self.dependencies = dependencies
    }

    func start() {

        let service = dependencies.makeTaskService()
        var controllers: [UIViewController] = []

        controllers.append(dependencies.makeInBoxModule(service: service))
        controllers.append(dependencies.makeToDayModule(service: service))
        controllers.append(dependencies.makeTaskListModule(service: service))
        controllers.append(dependencies.makeSearchModule(service: service))

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
