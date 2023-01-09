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

    func fetch(id: Int? = nil, type: Tables, force: Bool, _ completionHandler: @escaping FetchCompletionHandler) {

        guard !force else {
            fetchFromLocal(type: type) { completionHandler($0) }
            return
        }

        fetchFromRemote(type: type, id: id) { completionHandler($0) }
    }

    func update(type: Tables, _ operation: Operations, _ task: Task?, _ id: Int?, completionHandler: @escaping UpdateCompletionHandler) {

        remoteDataSource.update(operation: operation, task, id) { [weak self] result in
            guard let self = self else { return }

            guard result == nil else {
                completionHandler(result)
                return
            }

            self.fetch(type: type, force: true) { result in
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
    func fetchFromLocal(type: Tables, completionHandler: @escaping FetchCompletionHandler) {
    
        localDataSource.fetch { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                print(error.localizedDescription)
                self.fetchFromRemote(type: type, id: nil) { completionHandler($0) }
            }
        }
    }
    
    func fetchFromRemote(type: Tables, id: Int?, completionHandler: @escaping FetchCompletionHandler) {

        remoteDataSource.fetch(id: id, type: type) { (result) in
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
