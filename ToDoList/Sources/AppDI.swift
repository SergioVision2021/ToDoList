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
    //    static func makeDetailScene() -> DetailTaskViewController {
    //        guard let vc = storyBoard.instantiateViewController(withIdentifier: "IdDetailTask") as? DetailTaskViewController else { fatalError("Unexpected Index Path") }
    //        return vc
    //    }

    // MARK: - Data
    static func makeTaskStorageService() -> LocalStorage  {
        FileService()
    }

    //  static func makeTaskNetworkService() {}

    // MARK: - Repository
    static func makeTaskRepository() -> Repository {
        ManagerRepository(remoteDataSource: NetworkService(), localDataSource: makeTaskStorageService())
    }
}
