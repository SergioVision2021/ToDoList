//
//  ModuleDependencyImpl.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 23.11.22.
//

import UIKit

protocol ModuleDependencyProtocol {
    func makeInBoxModule() -> UINavigationController
    func makeToDayModule() -> UINavigationController
    func makeTaskListModule() -> UINavigationController
    func makeSearchModule() -> UINavigationController
}

class ModuleDependencyImpl: ModuleDependencyProtocol {

    private var service: TaskService

    init(service: TaskService) {
        self.service = service
    }

    func makeInBoxModule() -> UINavigationController {
        makeNavController(vc: InBoxModuleBuilder(service: service).build(),
                            image: UIImage(systemName: Image.calendar.rawValue),
                            tag: 0)
    }

    func makeToDayModule() -> UINavigationController {
        makeNavController(vc: ToDayModuleBuilder(service: service).build(),
                            image: UIImage(systemName: Image.flame.rawValue),
                            tag: 1)
    }

    func makeTaskListModule() -> UINavigationController {
        makeNavController(vc: TaskListModuleBuilder(service: service).build(),
                            image: UIImage(systemName: Image.triangle.rawValue),
                            tag: 2)
    }

    func makeSearchModule() -> UINavigationController {
        makeNavController(vc: SearchModuleBuilder(service: service).build(),
                            image: UIImage(systemName: Image.magnifyingglass.rawValue),
                            tag: 3)
    }
}

private extension ModuleDependencyImpl {
    enum Image: String {
        case calendar, flame, triangle, magnifyingglass }

    func makeNavController(vc: UIViewController, image: UIImage?, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = UITabBarItem(title: vc.title, image: image, tag: tag)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
