//
//  TabBarController.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.02.2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    func setupTabBar(){
        let vc1 = createNavController(vc: InBoxViewController(), itemName: "InBox", ItemImage: UIImage(systemName: "calendar")!)
        let vc2 = createNavController(vc: ToDayViewController(), itemName: "ToDay", ItemImage: UIImage(systemName: "flame")!)
        let vc3 = createNavController(vc: TaskListViewController(), itemName: "TaskList", ItemImage: UIImage(systemName: "list.dash")!)
        let vc4 = createNavController(vc: SearchViewController(), itemName: "Search", ItemImage: UIImage(systemName: "magnifyingglass")!)
        
        viewControllers = [vc1,vc2,vc3,vc4]
    }
    
    func createNavController(vc: UIViewController, itemName: String, ItemImage: UIImage) -> UINavigationController{
        let item = UITabBarItem(title: itemName,
                                image: ItemImage,
                                tag: 0)
        
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = item
        return navController
    }
}
