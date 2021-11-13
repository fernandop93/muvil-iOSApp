//
//  Client.swift
//  MuvilApp
//
//  Created by Fernando Pérez on 10/16/21.
//

import Foundation
import Alamofire

class Client {
    
    let baseURL: String = "http://ec2-174-129-52-23.compute-1.amazonaws.com:8080/api/"
    
    func login(_ username: String,
               _ password: String,
               success: @escaping ((LoginResponse) -> Void),
               failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "parent/login"
        
        let payload = LoginPayload(mail: username, password: password)
        
        AF
            .request(url, method: .post, parameters: payload, encoder: JSONParameterEncoder.default)
            .validate()
            .responseDecodable(of: LoginResponse.self) { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            }
    }
    
    func getOperatorByID(_ id: Int, success: @escaping ((OperatorResponse) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "operator/" + String(id)
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: OperatorResponse.self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
    func getSchoolByID(_ id: Int, success: @escaping ((SchoolResponse) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "school/" + String(id)
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: SchoolResponse.self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
    func getCurrentCourseByOperatorId(_ id: Int, success: @escaping ((CourseResponse) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "course/currentcourseforoperator/" + String(id)
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: CourseResponse.self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
    func getLocationsByCourseId(_ id: Int, success: @escaping (([VehiculeLocationResponse]) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "vehiculelocation/forcourse/" + String(id)
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: [VehiculeLocationResponse].self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
    func getNotifications(_ id: Int, success: @escaping (([NotificationResponse]) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "notification"
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: [NotificationResponse].self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
    func getCoursesForOperator(_ id: Int, success: @escaping (([CourseWithDetailResponse]) -> Void),
                 failure: @escaping ((Error) -> Void)) {
        
        let url = baseURL + "course/foroperator/" +  String(id)
        
        AF
            .request(url, method: .get)
            .validate()
            .responseDecodable(of: [CourseWithDetailResponse].self, completionHandler: { response in
                DispatchQueue.main.async {
                    if let error = response.error {
                        failure(error)
                        return
                    }
                    guard let value = response.value else {
                        fatalError("This shouldn't happen")
                    }
                    success(value)
                }
            })
    }
}

private struct LoginPayload: Encodable {
    let mail: String
    let password: String
}

struct LoginResponse: Decodable {
    let idParent: Int
    let mail: String
    let password: String
    let parentName: String
    let childName: String
    let latitude: Double
    let longitude: Double
    let status: Int
    let adress: String
    let district: String
    let phone: String
    let operator_idOperator: Int
    let school_idSchool: Int
}

struct OperatorResponse: Decodable {
    let idOperator: Int
    let name: String
    let password: String
    let mail: String
    let createdDate: String
    let status: Int
    let phone: String
    let driverName: String?
    let driverDNI: String?
    let driverNumber: String?
    let vehicleBrand: String?
    let vehicleColor: String?
    let vehicleModel: String?
    let vehiclePlate: String?
    let serviceStart: String?
    let serviceEnd: String?
    let iotURL: String?
}

struct SchoolResponse: Decodable {
    let idSchool: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let adress: String
    let district: String
    let operator_idOperator: Int
}

struct CourseResponse: Decodable {
    let idCourse: Int
    let date: String
    let lastGpsStatus: Int
    let lastCamaraStatus: Int
    let videoFeedURL: String
    let operator_idOperator: Int
}

struct VehiculeLocationResponse: Decodable {
    let idVehiculeLocation: Int
    let timestamp: String
    let latitude: Double
    let longitude: Double
    let course_idCourse: Int
}

struct NotificationResponse: Decodable {
    let idNotification: Int
    let content: String
    let date: String
    let type: Int
    let parent_idParent: Int
}

struct CourseWithDetailResponse: Decodable {
    let idCourse: Int
    let date: String
    let lastGpsStatus: Int
    let lastCamaraStatus: Int
    let videoFeedURL: String
    let operator_idOperator: Int
    let todaysLocations: [VehiculeLocationResponse]
}

