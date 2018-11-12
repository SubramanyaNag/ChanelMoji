//
//  BaseRequest.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import Foundation
import Alamofire

//This is a base request struct
struct BaseRequest {
    
    var baseURL : URL
    var endpoint: String?
    var method: Alamofire.HTTPMethod
    var parameterEncoding : ParameterEncoding
    
    var parameters: [String: AnyObject]?
    var headers : [String : String]?
    var fileURL : String?
    
    init() {
        let userDefaults = UserDefaults.standard
        if let baseUrl = userDefaults.string(forKey: "hostUrl") {
            if let unwrappedBaseURL = URL(string : baseUrl) {
                baseURL = unwrappedBaseURL
            }
            else {
                baseURL = URL(string: "http://10.9.110.228/VMAPIHK_V0_2_5_0")!
            }
        } else {
            baseURL = URL(string: "http://10.9.110.228/VMAPIHK_V0_2_5_0")!
        }
        self.method = .get
        self.parameterEncoding = URLEncoding.default

        if self.headers != nil {
            self.headers!["X-ADC-Request-Id"] = UUID().uuidString
        }
        else{
            self.headers = ["X-ADC-Request-Id" : UUID().uuidString]
        }
        fileURL = nil
    }
}

protocol ModifiableBaseRequest {
    var baseRequest : BaseRequest { set get }
}

extension ModifiableBaseRequest {
    var baseURL : URL {
        get { return baseRequest.baseURL }
        set { baseRequest.baseURL = newValue }
    }
    
    var endpoint : String? {
        get { return baseRequest.endpoint }
        set { baseRequest.endpoint = newValue }
    }
    
    var method : Alamofire.HTTPMethod {
        get { return baseRequest.method }
        set { baseRequest.method = newValue }
    }
    
    var parameterEncoding : ParameterEncoding {
        get { return baseRequest.parameterEncoding }
        set { baseRequest.parameterEncoding = newValue }
    }
    
    var headers : [String : String]? {
        get { return baseRequest.headers }
        set {
            for (key,value) in newValue! {
                baseRequest.headers![key] = value
            }
        }
    }
    
    var parameters: [String: AnyObject]? {
        get { return baseRequest.parameters }
        set { baseRequest.parameters = newValue }
    }
    
    var fileURL : String? {
        get { return baseRequest.fileURL }
        set { baseRequest.fileURL = newValue }
    }
}

