//swiftlint:disable all
//  TabBarController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//
import UIKit

extension TabBarController {
    enum Image: String {
        case calendar, flame, triangle, magnifyingglass }
}

class TabBarController: UITabBarController {

    private lazy var taskService = TaskService()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [makeInboxView(), makeTodayView(), makeTaskListController(), makeSearchController()]
    }
}

private extension TabBarController {
    func makeNavController(vc: UIViewController, title: String, image: UIImage?, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
    
    func makeInboxView() -> UIViewController {
        let vc = InBoxModuleBuilder().build(service: taskService)
        return makeNavController(vc: vc, title: vc.title ?? "", image: UIImage(systemName: Image.calendar.rawValue), tag: 0)
    }

    func makeTodayView() -> UIViewController {
        let vc = ToDayModuleBuilder().build(service: taskService)
        return makeNavController(vc: vc, title: vc.title ?? "", image: UIImage(systemName: Image.flame.rawValue), tag: 1)
    }

    func makeTaskListController() -> UIViewController {
        let vc = TaskListModuleBuilder().build(service: taskService)
        return makeNavController(vc: vc, title: vc.title ?? "", image: UIImage(systemName: Image.triangle.rawValue), tag: 2)
    }

    func makeSearchController() -> UIViewController {
        let vc = SearchModuleBuilder().build(service: taskService)
        return makeNavController(vc: vc, title: vc.title ?? "", image: UIImage(systemName: Image.magnifyingglass.rawValue), tag: 3)
    }
}
