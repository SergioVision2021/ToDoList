//  swiftlint:disable all
//  CacheShoesRepository.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 19.10.22.
//

import Foundation

struct ManagerRepository: Repository {

    init(remoteDataSource: RemoteDataSource, casheDataSource: CasheDataSource) {
        self.remoteDataSource = remoteDataSource
        self.casheDataSource = casheDataSource
    }

    func fetch(_ completionHandler: @escaping FetchCompletionHandler) {

        remoteDataSource.fetch { (result) in
        //casheDataSource.fetch { (result) in
            switch result {
            case .success(let dataModel):
                completionHandler(Result.success(dataModel))
            case .failure(let error):
                completionHandler(Result.failure(error))
            }
        }
    }

//        remoteDataSource.fetch { (result) in
//            switch result {
//            case .success(let dataModel):
//                self.casheDataSource.save(dataModel) { (result) in
//                    switch result {
//                    case.success(_): break
//                    case.failure(_): break
//                    }
//
//                }
//                completionHandler(result)
//            case .failure(_):
//                self.casheDataSource.fetch(completionHandler)
//            }
//        }

    func update(_ operation: Operations, _ task: Task, _ data: [Group], completionHandler: @escaping (Error?) -> ()) {
 
//        casheDataSource.save(data) {
//            completionHandler($0)
//        }

        remoteDataSource.update(operation: operation, task) {
            completionHandler($0)
        }
    }

    private var remoteDataSource: RemoteDataSource
    private var casheDataSource: CasheDataSource
}
