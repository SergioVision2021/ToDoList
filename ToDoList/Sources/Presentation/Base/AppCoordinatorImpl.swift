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

        let service = AppDI.makeTaskService()
        var controllers: [UIViewController] = []

        controllers.append(AppDI.makeInBoxModule(service: service))
        controllers.append(AppDI.makeToDayModule(service: service))
        controllers.append(AppDI.makeTaskListModule(service: service))
        controllers.append(AppDI.makeSearchModule(service: service))

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
