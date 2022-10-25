//swiftlint:disable all
//  MemoryService.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 14.03.2022.
//

import Foundation

class FileService: CasheDataSource {
    
    var storage: StorageHelper<Group>

    init() {
        self.storage = StorageHelper(folderName: "ToDoList", fileName: "Data")
    }
    
    func fetch(_ completionHandler: @escaping FetchCompletionHandler) {

        guard let model: [Group] = storage.getData() else {
            print("Group empty")
            completionHandler(Result.failure(CasheDataSourceError.emptyData))
            return
        }
        
        completionHandler(Result.success(model))
    }
    
    func save(_ task: [Group], completionHandler: @escaping (Error?) -> ()) {
        
        // save all tasks from cash in local file
        storage.saveJsonToFile(task) {
            completionHandler($0)
        }
    }
    
    func removeAll(_ task: [Group], completionHandler: @escaping CompletionHandler) {
        //
    }
}
