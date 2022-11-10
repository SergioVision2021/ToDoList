//swiftlint:disable all
//  DataBaseTasks.swift
//  ToDoList
//
//  Created by Sergey Vysotsky on 01.04.2022.
//

import Foundation

enum NetworkServiceError: Error {
    case requestFailed
}

class NetworkService {

    var component: URLComponents
    
    init() {
        component = URLComponents()
        configureComponent()
    }
    
    func configureComponent() {
        component.scheme = Constants.SHEME
        component.host = Constants.HOST
        component.port = Constants.PORT
    }
    
    func fetch(_ completionHandler: @escaping (Result<[Group], Error>) -> ()) {
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

                completionHandler(Result.success(decodedResponse))

            case .failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(Result.failure(NetworkServiceError.requestFailed))
            }
        }
    }
    
    
    func update(operation: Operations, _ task: Task, _ completionHandler: @escaping (Error?) -> ()) {
        
        let dispatcher = NetworkDispatcher()
        var baseURL = component
        
        guard let url = baseURL.url else { return }
        
        var request = URLRequest(url: url)
        
        switch operation {
        case .add:
            baseURL.path = "/" + Constants.TASKS
            
            guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }

            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.POST, uploadData) else { return }
            request = req
        case .edit:
            guard let id = task.id else { return }

            baseURL.path = "/\(Constants.TASKS)/\(id)"
            
            guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }

            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.PUT, uploadData) else { return }
            request = req
        case .delete:
            guard let id = task.id else { return }

            baseURL.path = "/\(Constants.TASKS)/\(id)"
            
            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.DELETE, nil) else { return }
            request = req
        case .def:
            break
        }
        
        dispatcher.sendRequest(request) { result in
            switch result {
            case .success(_):
                print("Request success: \(request.httpMethod)")
                completionHandler(nil)
            case .failure(let error):
                print("Request \(request.httpMethod) failed with error: \(error)")
                completionHandler(error)
            }
        }
    }
}
