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
 
        dispatcher.sendRequest(request) { data, success in
            guard let data = data else {
                print("Error data")
                return
            }
        
            //Data -> Swift object
            guard let decodedResponse: [Group] = CoderJSON().decoderJSON(data) else { return }
            
            self.source = decodedResponse
            
            callback(decodedResponse, true)
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
        
        dispatcher.sendRequest(request) { data, success in
            guard let data = data else {
                print("Error data")
                return
            }
            
            //guard let decodedResponse: Task = CoderJSON().decoderJSON(data) else { return }
        }  
    }
    
    override func edit(_ task: Task, _ status: Bool) {
        super.edit(task, status)
        
        var editTask = task
        guard let id = editTask.id else { return }
        
        var baseURL = component
        baseURL.path = "/tasks/\(id)"
        
        let dispatcher = NetworkDispatcher()
        
        // DELETE
        guard !status else {
 
            guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.DELETE, nil) else { return }
            
            dispatcher.sendRequest(request) { data, success in
                guard let data = data else {
                    print("Error data")
                    return
                }
            }
            
            return
        }
        
        // EDIT
        // Завершить задачу
        editTask.status = true
        
        guard let uploadData: Data = CoderJSON().encoderJSON(editTask) else { return }
        guard let request = dispatcher.prepareRequest(baseURL, HTTPMethod.PUT, uploadData) else { return }
        
        dispatcher.sendRequest(request) { data, success in
            guard let data = data else {
                print("Error data")
                return
            }
        }
    }
}
