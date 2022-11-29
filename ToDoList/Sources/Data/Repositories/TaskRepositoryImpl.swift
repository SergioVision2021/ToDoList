//  swiftlint:disable all
//  TaskRepositoryImpl.swift
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

    func fetch(force: Bool, _ completionHandler: @escaping FetchCompletionHandler) {
        
        guard !force else {
            fetchFromLocal { completionHandler($0) }
            return
        }
        
        fetchFromRemote { completionHandler($0) }
    }

    func update(_ operation: Operations, _ task: Task, completionHandler: @escaping UpdateCompletionHandler) {

        remoteDataSource.update(operation: operation, task) { [weak self] result in
            guard let self = self else { return }

            guard result == nil else {
                completionHandler(result)
                return
            }
            
            self.fetch(force: true) { result in
                switch result {
                case .success(_):
                    completionHandler(nil)
                case .failure(let error):
                    completionHandler(error)
                }
            }
        }
    }
}

private extension TaskRepositoryImpl {
    func fetchFromLocal(completionHandler: @escaping FetchCompletionHandler) {
    
        localDataSource.fetch { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                print(error.localizedDescription)
                self.fetchFromRemote { completionHandler($0) }
            }
        }
    }
    
    func fetchFromRemote(completionHandler: @escaping FetchCompletionHandler) {
    
        remoteDataSource.fetch { (result) in
            switch result {
            case .success(let dataModel):
                
                self.localDataSource.saveAll(dataModel) { (result) in
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
