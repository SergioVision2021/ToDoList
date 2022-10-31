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

class ManagerRepository: Repository {

    private var currentType = TypeRepository.remote
    private var currentRepository: Repository
    private var remoteDataSource: RemoteDataSource
    private var casheDataSource: CasheDataSource
    
    init(remoteDataSource: RemoteDataSource, casheDataSource: CasheDataSource) {
        self.remoteDataSource = remoteDataSource
        self.casheDataSource = casheDataSource
        self.currentRepository = remoteDataSource
    }

    func fetch(_ completionHandler: @escaping FetchCompletionHandler) {

        currentRepository.fetch { (result) in
            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                
                self.currentType = .cache
                self.currentRepository = self.casheDataSource
                
                self.currentRepository.fetch { (result) in
                    switch result {
                    case .success(let dataModel):
                        completionHandler(Result.success(dataModel))
                    case .failure(let error):
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
            casheDataSource.save(data) {
                completionHandler($0)
            }
        }
    }
}
