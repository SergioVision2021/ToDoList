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

    func makeInBoxModule() -> UINavigationController{
        makeNavController(title: "InBox", image: UIImage(systemName: "calendar"), tag: 0)
    }

    func makeToDayModule(vc: UIViewController) -> UINavigationController {
        let navController =  makeNavController(title: "ToDay", image: UIImage(systemName: "flame"), tag: 1)
        navController.setViewControllers([vc], animated: true)
        return navController
    }

    func makeGroupModule(vc: UIViewController) -> UINavigationController {
        let navController = makeNavController(title: "Group", image: UIImage(systemName: "list.bullet.circle"), tag: 2)
        navController.setViewControllers([vc], animated: true)
        return navController
    }

    func makeSearchModule(vc: UIViewController) -> UINavigationController {
        let navController = makeNavController(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
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
