//swiftlint:disable all
//  DataBaseTasks.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 01.04.2022.
//

import Foundation
import UIKit
import Pods_ToDoList

enum JSONObject: String {
    case groups, tasks
}

class BackendService: TaskService {

    var task: Task?

    var component = URLComponents()
    
    override init() {
        component.scheme = Constants.SHEME
        component.host = Constants.HOST
        component.port = Constants.PORT

        super.init()
    }

    override func fetch(_ data: [Group]?, _ callback: @escaping (Error?) -> Void) {
    
        var baseURL = component
        baseURL.path = "/\(Constants.GROUPS)/"
        baseURL.queryItems = [.init(name: "_embed", value: "tasks")]
    
        let dispatcher = NetworkDispatcher()
        guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.GET, nil) else { return }

        dispatcher.sendRequest(request) { result in
            switch result {
            case .success(let data):
                //Data -> Swift object
                guard let decodedResponse: [Group] = CoderJSON().decoderJSON(data) else { return }

                super.fetch(decodedResponse) { callback($0) }
                
                callback(nil)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
                callback(error)
            }
        }
    }

    override func add(_ task: Task, _ callback: @escaping (Error?) -> Void) {
        
        super.add(task) { result in
            
            //var test = Task(id: 10, groupId: 0, name: "task10", taskScheduledDate: Date(), notes: "text", status: false)

            guard let result = result else {

                var baseURL = self.component
                baseURL.path = "/" + Constants.TASKS

                let dispatcher = NetworkDispatcher()

                guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }
                guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.POST, uploadData) else { return }

                self.sendRequest(request, dispatcher) { callback($0) }

                return
            }
            
            callback(result)
        }
    }

    override func edit(_ task: Task, _ callback: @escaping (Result<Task?, Error>) -> Void) {

        super.edit(task) { result in

            switch result {
            case .success(let data):
                
                guard let data = data else { return }
                
                guard let id = data.id else { return }

                var baseURL = self.component
                baseURL.path = "/\(Constants.TASKS)/\(id)"

                let dispatcher = NetworkDispatcher()

                guard let uploadData: Data = CoderJSON().encoderJSON(data) else { return }
                guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.PUT, uploadData) else { return }

                self.sendRequest(request, dispatcher) { result in
                    guard let result = result else {
                        callback(.success(nil))
                        return
                    }
                    callback(.failure(result))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }

    override func delete(_ task: Task, _ callback: @escaping (Error?) -> Void) {

        super.delete(task) { result in

            guard let result = result else {
            
                guard let id = task.id else { return }

                var baseURL = self.component
                baseURL.path = "/\(Constants.TASKS)/\(id)"

                let dispatcher = NetworkDispatcher()

                guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.DELETE, nil) else { return }

                self.sendRequest(request, dispatcher) { callback($0) }
                
                return
            }
            callback(result)
        }
    }

    private func sendRequest(_ request: URLRequest, _ inDispatcher: NetworkDispatcher, _ callback: @escaping (Error?) -> Void) {
        inDispatcher.sendRequest(request) { result in
            switch result {
            case .success(_):
                print("Request success: \(request.httpMethod)")
                callback(nil)
            case .failure(let error):
                print("Request failed with error: \(error)")
                callback(error)
            }
        }
    }
}
