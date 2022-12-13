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

    func fetch(id: Int?, type: Tables, _ completionHandler: @escaping (Result<Data, Error>) -> ()) {
        var baseURL = component
       
        if let id = id {
            baseURL.path = "/\(type)/"
            baseURL.queryItems = [.init(name: "id", value: "\(id)")]
        } else {
            baseURL.path = "/\(type)/"
        }
        
        let dispatcher = NetworkDispatcher()
        guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.GET, nil) else { return }
        
        dispatcher.sendRequest(request) { result in
            switch result {
            case .success(let data):
                //Data -> Swift object
                //guard let decodedResponse: [Task] = CoderJSON().decoderJSON(data) else { return }
                completionHandler(Result.success(data))
            case .failure(let error):
                print("Request failed with error: \(error)")
                completionHandler(Result.failure(NetworkServiceError.requestFailed))
            }
        }
    }
    
    func update(operation: Operations, _ task: Task?, _ id: Int?, _ completionHandler: @escaping (Error?) -> ()) {
        
        let dispatcher = NetworkDispatcher()
        var baseURL = component
        
        guard let url = baseURL.url else { return }
        
        var request = URLRequest(url: url)
        
        switch operation {
        case .add:
            baseURL.path = "/\(Tables.tasks)"
            
            guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }

            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.POST, uploadData) else { return }
            request = req
        case .edit:
            guard let id = task?.id else { return }

            baseURL.path = "/\(Tables.tasks)/\(id)"
            
            guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }

            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.PUT, uploadData) else { return }
            request = req
        case .delete:
            guard let id = id else { return }

            baseURL.path = "/\(Tables.tasks)/\(id)"
            
            guard let req = dispatcher.prepareRequest(baseURL, HTTPMethod.DELETE, nil) else { return }
            request = req
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

extension NetworkService {
    func mock() -> Group {
        return Group.init(id: 0, name: "Inbox")
    }
}
