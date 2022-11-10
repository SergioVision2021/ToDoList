//  swiftlint:disable all
//  CacheShoesRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

enum TypeRepository {
    case remote
    case cache
}

class ManagereRepositoryImpl: TaskRepository {

    private var currentType = TypeRepository.remote
    private var remoteDataSource: NetworkService
    private var localDataSource: LocalStorage

    init(remoteDataSource: NetworkService, localDataSource: LocalStorage) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch(_ completionHandler: @escaping FetchCompletionHandler) {

        remoteDataSource.fetch { (result) in
            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                print("< Remote not access! >")
                
                self.currentType = .cache
                
                self.localDataSource.fetch { (result) in
                    switch result {
                    case .success(let dataModel):
                        completionHandler(Result.success(dataModel))
                    case .failure(let error):
                        self.currentType = .cache
                        completionHandler(Result.failure(error))
                    }
                }
            }
        }
    }

    func update(_ operation: Operations, _ task: Task, _ data: [Group], completionHandler: @escaping (Error?) -> ()) {
 
        switch currentType {
        case .remote:
            remoteDataSource.update(operation: operation, task) {
                completionHandler($0)
            }
        case .cache:
            localDataSource.save(data) {
                completionHandler($0)
            }
        }
    }
}
