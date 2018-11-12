//
//  WebServiceManager.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceManager {
    
    fileprivate let alamofireManager :Alamofire.SessionManager
    
    init() {
        alamofireManager = Alamofire.SessionManager.default
        let userDefaults = UserDefaults.standard
        if let timeoutValue = userDefaults.string(forKey: "timeout"), let timeout = Double(timeoutValue) {
            alamofireManager.session.configuration.timeoutIntervalForRequest = timeout
            alamofireManager.session.configuration.timeoutIntervalForResource = timeout
        } else {
            let appDefaults = ["timeout": "30"]
            UserDefaults.standard.register(defaults: appDefaults)
            userDefaults.synchronize()
            alamofireManager.session.configuration.timeoutIntervalForRequest = 30
            alamofireManager.session.configuration.timeoutIntervalForResource = 30
        }
    }
    
    fileprivate func createAlamofireDataRequest(_ request: ModifiableBaseRequest) -> Alamofire.DataRequest {
        return self.alamofireManager.request(request.baseURL.appendingPathComponent(request.endpoint!), method: request.method, parameters: request.parameters, encoding: request.parameterEncoding, headers: request.headers)
    }
    
    func createAlamofireUploadRequest(_ request : ModifiableBaseRequest) -> Alamofire.UploadRequest {
        let alamofireRequest = self.createAlamofireDataRequest(request)
        let data = try! Data(contentsOf: URL(fileURLWithPath:request.fileURL!))
        return self.alamofireManager.upload(data, to: alamofireRequest.request!.url!, method: request.method, headers: request.headers)
    }
    
    func getResponse(for request : ModifiableBaseRequest, completion: @escaping (URLRequest?, HTTPURLResponse?, Data?, NSError?) -> Void) {
//        if self.hasConnectivity(){
            let alamofireRequest = createAlamofireDataRequest(request)
            
            alamofireRequest.responseData(completionHandler: { (dataResponse) in
                //                let referenceDate = "2001-01-01 00:00:00 +0000"
                //                let dateFormatter = DateFormatter()
                //                dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss ZZZZZ"
                //                dateFormatter.timeZone = NSTimeZone.local
                //                let requestStartTime = dateFormatter.string(from: Date(timeInterval: dataResponse.timeline.requestStartTime, since: dateFormatter.date(from: referenceDate)!))
                //                let requestCompletionTime = dateFormatter.string(from: Date(timeInterval: dataResponse.timeline.requestCompletedTime, since: dateFormatter.date(from: referenceDate)!))
                //                let latency = dataResponse.timeline.latency
                //                let url = dataResponse.request!.url!
                
                switch dataResponse.result {
                case .success:
                    completion(dataResponse.request, dataResponse.response, dataResponse.data, nil)
                case .failure(let error):
                    completion(dataResponse.request, dataResponse.response, dataResponse.data, error as NSError?)
                }
            })
//        }
//        else{
//            let noInernetError = NSError(domain: "NO_INTERNET", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
//            completion(nil, nil, nil, noInernetError)
//        }
    }
    
    func uploadImageFromRequest(_ request : ModifiableBaseRequest, responseHandler: @escaping (URLRequest?, HTTPURLResponse?, Data?, NSError?) -> Void) {
//        if self.hasConnectivity() {
            let alamofireRequest = createAlamofireUploadRequest(request)
            alamofireRequest.responseData(completionHandler: { (dataResponse) in
                switch dataResponse.result {
                case .success:
                    responseHandler(dataResponse.request, dataResponse.response, dataResponse.data, nil)
                case .failure(let error):
                    responseHandler(dataResponse.request, dataResponse.response, dataResponse.data, error as NSError?)
                }
            })
//        }
//        else {
//            let noInernetError = NSError(domain: "NO_INTERNET", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
//            responseHandler(nil, nil, nil, noInernetError)
//        }
    }
    
//    func hasConnectivity() -> Bool {
//        let reachability: Reachability = Reachability.forInternetConnection()
//        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
//        return networkStatus == 1
//    }
}
