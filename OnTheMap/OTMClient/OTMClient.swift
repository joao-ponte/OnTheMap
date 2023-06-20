//
//  OTMClient.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

class OTMClient {
    
    enum EndPoints {
        
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudents(Int)
        case postStudent
        case updateStudent(String)
        case createSessionId
        
        var stringValue: String {
            switch self {
                
            case .getStudents(let totalStudents):
                return EndPoints.base + "/StudentLocation?limit=\(totalStudents)"
            case .postStudent:
                return EndPoints.base + "/StudentLocation"
            case .updateStudent(let objectID):
                return EndPoints.base + "/StudentLocation/\(objectID)"
            case .createSessionId:
                return EndPoints.base + "/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForPostRequest<RequestType: Codable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func taskForPutRequest<RequestType: Codable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    class func loginUser(username: String, password: String, completion: @escaping (SessionResponse?, Error?) -> Void) {
        let url = EndPoints.createSessionId.url
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = LoginRequest(udacity: LoginRequest.Udacity(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                guard let data = data else {
                    completion(nil, nil)
                    return
                }
                
                let range = 5..<data.count
                let newData = data.subdata(in: range)
                
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(SessionResponse.self, from: newData)
                    completion(response, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func getStudents(completion: @escaping ([Student], Error?) -> Void) {
        taskForGetRequest(url: EndPoints.getStudents(100).url, response: StudentsResult.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response.results)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudents(firstname: String, lastName: String, latitude: Float, longitude: Float, mapString: String, mediaURL: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = PostStudent(firstName: firstname, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: "1234")
        taskForPostRequest(url: EndPoints.postStudent.url, responseType: OTMPostResponse.self, body: body) { (response, error) in
            if let response = response {
                print("\(response)☺️")
            } else {
                completion(false, error)
                print("\(String(describing: error))😴")
            }
        }
    }
    
    class func updateStudents(firstname: String, lastName: String, latitude: Float, longitude: Float, mapString: String, mediaURL: String, objectID: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = PostStudent(firstName: firstname, lastName: lastName, latitude: latitude, longitude: longitude, mapString: mapString, mediaURL: mediaURL, uniqueKey: "1234")
        taskForPostRequest(url: EndPoints.updateStudent(objectID).url, responseType: OTMPutResponse.self, body: body) { (response, error) in
            if let response = response {
                print("\(response)☺️")
            } else {
                completion(false, error)
                print("\(String(describing: error))😴")
            }
        }
    }
}
