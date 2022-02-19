//
//  TabBarController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TabBarController: UITabBarController {

    private let vc = [InBoxViewController(), ToDayViewController(), TaskListViewController(), SearchViewController()]
    private let name = ["InBox", "ToDay", "TaskList", "Search"]
    private let image = ["calendar", "flame", "list.dash", "magnifyingglass"]
    private var vcTabBar: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar(){
        for i in 0..<vc.count{
            vc[i].title = name[i]
            vcTabBar.append(createNavController(vc: vc[i], itemName: name[i], ItemImage: UIImage(systemName:image[i])!))
        }
        
        viewControllers = vcTabBar
    }
    
    private func createNavController(vc: UIViewController, itemName: String, ItemImage: UIImage) -> UINavigationController{
        let item = UITabBarItem(title: itemName,
                                image: ItemImage,
                                tag: 0)
        
        vc.view.backgroundColor = .white
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
