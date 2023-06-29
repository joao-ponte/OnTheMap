//
//  OTMClient.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

class OTMClient {

    struct Auth {
        static var sessionId: String = ""
        static var accountKey: String? = ""
        static var firstName: String = ""
        static var lastName: String = ""
        static var objectId: String? = ""
    }
    
    enum EndPoints {

        static let base = "https://onthemap-api.udacity.com/v1"

        case getStudents
        case postStudent
        case updateStudent(String)
        case createSessionId
        case logout
        case users
        case signUp


        var stringValue: String {
            switch self {

            case .getStudents:
                return EndPoints.base + "/StudentLocation" + "?limit=100&order=-updatedAt"
            case .postStudent:
                return EndPoints.base + "/StudentLocation"
            case .updateStudent(let objectID):
                return EndPoints.base + "/StudentLocation/\(objectID)"
            case .createSessionId:
                return EndPoints.base + "/session"
            case .logout:
                return EndPoints.base + "/session"
            case .users:
                return EndPoints.base + "/users/" + Auth.sessionId
            case .signUp:
                return "https://auth.udacity.com/sign-up"
            }
        }

        var url: URL {
            return URL(string: stringValue)!
        }

    }
    class func logout(completion: @escaping (SessionResponse.Session?, Error?) -> Void) {
        let url = EndPoints.logout.url
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie?
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies!
        where cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }

        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(nil, error)
                    return
                }
                guard let data = data else {
                    completion(nil, nil)
                    return
                }

                let newData = data.dropFirst(5) // Remove the first 5 characters
                print(String(data: newData, encoding: .utf8)!)

                do {
                    let responseDict = try JSONDecoder().decode([String: SessionResponse.Session].self, from: newData)
                    let session = responseDict["session"]
                    completion(session, nil)
                } catch let decodingError {
                    let debugDescription = decodingError.localizedDescription
                    let error = NSError(domain: "",
                                        code: 0,
                                        userInfo: [
                                            NSLocalizedDescriptionKey: "Error decoding JSON: \(debugDescription)"
                                        ])
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }

    class func loginUser(username: String,
                         password: String,
                         completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: LoginRequest.Udacity(username: username, password: password))
        OTMHttpClient.taskForPostRequest(udacityAPI: true, url: EndPoints.createSessionId.url, responseType: SessionResponse.self, body: body) { (response, error) in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.accountKey = response.account.key
                
                completion(true, nil)
                getPublicUserData()
            } else {
               completion(false, error)
            }
        }
    }
    
    class func getStudents(completion: @escaping ([Student], Error?) -> Void) {
        OTMHttpClient.taskForGetRequest(udacityAPI: false, url: EndPoints.getStudents.url,
                                        response: StudentsResult.self) { (response, error) in
            if let response = response {
                completion(response.results, nil)
                print(response)
            } else {
                completion([], error)
            }
        }
    }

    class func addStudent(mapString: String,
                          mediaURL: String,
                          latitude: Float,
                          longitude: Float,
                          completion: @escaping (Bool, Error?) -> Void) {
       
        let body = PostStudent(firstName: Auth.firstName,
                               lastName: Auth.lastName,
                               latitude: latitude,
                               longitude: longitude,
                               mapString: mapString,
                               mediaURL: mediaURL,
                               uniqueKey: Auth.accountKey)
        
        OTMHttpClient.taskForPostRequest(udacityAPI: false,
                                         url: EndPoints.postStudent.url,
                                         responseType: OTMPostResponse.self, body: body) { response, error in
            if response != nil {
                Auth.objectId = response?.objectId ?? ""
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func updateStudent(mapString: String,
                             mediaURL: String,
                             latitude: Float,
                             longitude: Float,
                             completion: @escaping (Bool, Error?) -> Void) {
        
        let body = PostStudent(firstName: Auth.firstName,
                               lastName: Auth.lastName,
                               latitude: latitude,
                               longitude: longitude,
                               mapString: mapString,
                               mediaURL: mediaURL,
                               uniqueKey: Auth.accountKey)
        
        OTMHttpClient.taskForPutRequest(udacityAPI: false, url: EndPoints.updateStudent(Auth.objectId ?? "").url, responseType: OTMPutResponse.self, body: body) { response, error in
            if response != nil {
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func getPublicUserData() {
        OTMHttpClient.taskForGetRequest(udacityAPI: true, url: EndPoints.users.url, response: User.self) { response, error in
            if let response = response {
                Auth.firstName = response.firstName
                Auth.lastName = response.lastName
            }
        }
    }
}
