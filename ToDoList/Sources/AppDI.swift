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
    
    static func makeTaskService() -> TaskServiceLogic {
        TaskService()
    }

    //  static func makeTaskNetworkService() {}

    // MARK: - Repository
    static func makeTaskRepository() -> TaskRepository {
        TaskRepositoryImpl(remoteDataSource: NetworkService(), localDataSource: makeTaskStorageService())
    }
}

// MARK: - AppRootDependency
extension AppDI: AppRootDependency {

    static func makeInBoxModule(service: TaskServiceLogic) -> UINavigationController {
        makeNavController(vc: InBoxModuleBuilder(service: service).build(),
                          image: UIImage(systemName: "calendar"),
                            tag: 0)
    }

    static func makeToDayModule(service: TaskServiceLogic) -> UINavigationController {
        makeNavController(vc: ToDayModuleBuilder(service: service).build(),
                            image: UIImage(systemName: "flame"),
                            tag: 1)
    }

    static func makeTaskListModule(service: TaskServiceLogic) -> UINavigationController {
        makeNavController(vc: TaskListModuleBuilder(service: service).build(),
                            image: UIImage(systemName: "triangle"),
                            tag: 2)
    }

    static func makeSearchModule(service: TaskServiceLogic) -> UINavigationController {
        makeNavController(vc: SearchModuleBuilder(service: service).build(),
                            image: UIImage(systemName: "magnifyingglass"),
                            tag: 3)
    }

    static func makeNavController(vc: UIViewController, image: UIImage?, tag: Int) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem = UITabBarItem(title: vc.title, image: image, tag: tag)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
