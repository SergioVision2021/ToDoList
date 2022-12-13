//  swiftlint:disable all
//  AppDI.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 8.11.22.
//

import Foundation
import UIKit

class AppDI {
    // MARK: - Scene
    static func makeAddTaskScene() -> AddTaskViewController {
        return AddTaskViewController(nibName: Constants.addTaskVCIdentifier, bundle: nil)
    }

    static func makeSelectDateScene() -> SelectDateViewController {
        return SelectDateViewController(nibName: Constants.selectDataVCIdentifier, bundle: nil)
    }
    
    static func makeDetailTaskScene() -> DetailTaskViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let view = storyBoard.instantiateViewController(withIdentifier: Constants.detailTaskVCIdentifier) as? DetailTaskViewController else {
            fatalError("Unexpected Index Path")
        }

        return view
    }

    // MARK: - Data
    static func makeTaskStorageService() -> LocalStorage  {
        FileService()
    }

    //  static func makeTaskNetworkService() {}

    // MARK: - Repository
    static func makeTaskRepository() -> TaskRepository {
        TaskRepositoryImpl(remoteDataSource: NetworkService(), localDataSource: makeTaskStorageService())
    }
}

// MARK: - AppRootDependency
extension AppDI: AppRootDependency {

    func makeInBoxModule() -> InBoxCoordinator{
        let navController = makeNavController(title: "InBox", image: UIImage(systemName: "calendar"), tag: 0)
        return InBoxCoordinator(navigationController: navController)
    }

    func makeToDayModule() -> UINavigationController {
        let navController = makeNavController(title: "ToDay", image: UIImage(systemName: "flame"), tag: 1)
        let vc = ToDayModuleBuilder().build()
        navController.setViewControllers([vc], animated: true)
        
        return navController
    }

    func makeTaskListModule() -> UINavigationController {
        let navController = makeNavController(title: "TaskList", image: UIImage(systemName: "triangle"), tag: 2)
        let vc = TaskListModuleBuilder().build()
        navController.setViewControllers([vc], animated: true)
        return navController
    }

    func makeSearchModule() -> UINavigationController {
        let navController = makeNavController(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        let vc = SearchModuleBuilder().build()
        navController.setViewControllers([vc], animated: true)
        return navController
    }

    func makeNavController(title: String?, image: UIImage?, tag: Int) -> UINavigationController {
        let navController = UINavigationController()
        navController.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
