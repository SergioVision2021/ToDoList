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
    static func makeModule() -> ModuleDependencyProtocol {
        ModuleDependencyImpl(service: TaskService())
    }

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
