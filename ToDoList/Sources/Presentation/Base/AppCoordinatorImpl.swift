//
//  AppCoordinatorImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

class AppCoordinatorImpl: Coordinator {

    var tabBarController: UITabBarController
    private var module = AppDI.makeModule()

    init(tabBarController: UITabBarController = UITabBarController()) {
        self.tabBarController = tabBarController
    }

    func start() {
        var controllers: [UIViewController] = []

        controllers.append(module.makeInBoxModule())
        controllers.append(module.makeToDayModule())
        controllers.append(module.makeTaskListModule())
        controllers.append(module.makeSearchModule())

        tabBarController.setViewControllers(controllers, animated: true)
    }
}
