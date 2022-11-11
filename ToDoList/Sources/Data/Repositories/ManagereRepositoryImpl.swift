//  swiftlint:disable all
//  CacheShoesRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

class TaskRepositoryImpl: TaskRepository {

    private var remoteDataSource: NetworkService
    private var localDataSource: LocalStorage

    init(remoteDataSource: NetworkService, localDataSource: LocalStorage) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetch(_ completionHandler: @escaping FetchCompletionHandler) {

        localDataSource.fetch { (result) in
            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                print(error.localizedDescription)

                self.remoteDataSource.fetch { (result) in
                    switch result {
                    case .success(let dataModel):
                        
                        self.save(dataModel) { result in
                            guard result == nil else {
                                completionHandler(Result.failure(result!))
                                return
                            }
                        }
                        
                        completionHandler(Result.success(dataModel))
                    case .failure(let error):
                        completionHandler(Result.failure(error))
                    }
                }
            }
        }
    }

    func update(_ operation: Operations, _ task: Task, completionHandler: @escaping (Error?) -> ()) {
        remoteDataSource.update(operation: operation, task) {
            completionHandler($0)
        }
    }

    func save( _ data: [Group], completionHandler: @escaping (Error?) -> ()) {
        localDataSource.save(data) {
            completionHandler($0)
        }
    }
}
