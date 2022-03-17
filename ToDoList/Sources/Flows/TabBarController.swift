//
//  TabBarController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TabBarController: UITabBarController {

    private let inBoxVC = InBoxViewController()
    private let toDayVC = ToDayViewController()
    private let taskListVC = TaskListViewController()
    private let searchVC = SearchViewController()

    private var vc = [UIViewController]()

    private let name = ["InBox", "ToDay", "TaskList", "Search"]
    private let image = ["calendar", "flame", "list.dash", "magnifyingglass"]
    private var vcTabBar: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let fileService = FileService()
        fileService.load()
        inBoxVC.service = fileService
        toDayVC.service = fileService
        taskListVC.service = fileService
        searchVC.service = fileService

        vc.insert(inBoxVC, at: 0)
        vc.insert(toDayVC, at: 1)
        vc.insert(taskListVC, at: 2)
        vc.insert(searchVC, at: 3)

        setupTabBar()
    }

    private func setupTabBar() {

        for idx in 0..<vc.count {
            vc[idx].title = name[idx]

            vcTabBar.append(createNavController(vc: vc[idx], itemName: name[idx], itemImage: UIImage(systemName: image[idx])!))
        }

        viewControllers = vcTabBar
    }

    private func createNavController(vc: UIViewController, itemName: String, itemImage: UIImage) -> UINavigationController {
        let item = UITabBarItem(title: itemName,
                                image: itemImage,
                                tag: 0)

        vc.view.backgroundColor = .white

        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
