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
        component.scheme = "http"
        component.host = "localhost"
        component.port = 3000

        super.init()
    }

    override func fetch(_ callback: @escaping ([Any], Bool) -> Void) {
    
        var baseURL = component
        baseURL.path = "/groups/"
        baseURL.queryItems = [.init(name: "_embed", value: "tasks")]
    
        let dispatcher = NetworkDispatcher()
        guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.GET, nil) else { return }

        dispatcher.sendRequest(request) { result in
            switch result {
            case .success(let data):

                //Data -> Swift object
                guard let decodedResponse: [Group] = CoderJSON().decoderJSON(data) else { return }
                self.source = decodedResponse
                callback(decodedResponse, true)
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }

    override func add(_ task: Task) {
        super.add(task)

        //var test = Task(id: 10, groupId: 0, name: "task10", taskScheduledDate: Date(), notes: "text", status: false)

        var baseURL = component
        baseURL.path = "/tasks"

        let dispatcher = NetworkDispatcher()
        
        guard let uploadData: Data = CoderJSON().encoderJSON(task) else { return }
        guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.POST, uploadData) else { return }
        
        send(dispatcher, request)
    }
    
    //delete = true | edit = false
    override func edit(_ task: Task, _ status: Bool) {
        super.edit(task, status)
        
        var editTask = task
        guard let id = editTask.id else { return }
        
        var baseURL = component
        baseURL.path = "/tasks/\(id)"
        
        let dispatcher = NetworkDispatcher()
        
        if status {
            // DELETE
            guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.DELETE, nil) else { return }
            send(dispatcher, request)
        } else {
            // EDIT = Завершить задачу
            editTask.status = true
            
            guard let uploadData: Data = CoderJSON().encoderJSON(editTask) else { return }
            guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.PUT, uploadData) else { return }
            send(dispatcher, request)
        }
    }
    
    func send(_ dispatcher: NetworkDispatcher, _ request: URLRequest) {
        dispatcher.sendRequest(request) { result in
            switch result {
            case .success(_):               //!!!!
                print("Request success: \(request.httpMethod)")
                return
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
