//
//  WebResponseVerifier.swift
//  ChanelEmoji
//
//  Created by subramanya on 23/06/18.
//  Copyright © 2018 Subramanya. All rights reserved.
//

import Foundation

// swiftlint complains that type names should not have _ in them - I disagree.
// swiftlint:disable type_name
enum WebResponseError: Error {
    case unknownError
    case connectionError
    case invalidCredentials
    case invalidRequest
    case notFound
    case invalidResponse
    case serverError
    case serverUnavailable
    case timeOut
    case invalidAuthorization
    case storeIDNotFound
    case floorIDNotFound
    case displayIDNotFound
    case imageNotFound
    case inputTooLarge
    case itemNotAvailable
    case noInternet
    case unsuppotedURL
    
    static func check(response: HTTPURLResponse?, request: URLRequest?, error: NSError?) -> WebResponseError? {
        if let error = error {
            // TODO: If you pass an invalid username/password, flow comes here. It should be going to http 401?
            print(error)
            return mapError(error)
        }
        if let response = response {
            // TODO: Remove magic numbers and use an http status codes enum
            if response.statusCode != 200 && response.statusCode != 207 {
                self.logError("Invalid response status code", request: request, response: response)
                let dataStoreError = WebResponseError.checkErrorCode(response.statusCode)
                return dataStoreError
            }
        } else {
            return .invalidResponse
        }
        return nil
    }
    
    static func checkErrorCode(_ errorCode: Int) -> WebResponseError {
        switch errorCode {
        case 400:
            return .invalidRequest
        case 401:
            return .invalidCredentials
        case 404:
            return .notFound
        case 405:
            return .imageNotFound
        case 406:
            return .inputTooLarge
        case 410:
            return .invalidAuthorization
        case 420:
            return .storeIDNotFound
        case 421:
            return .floorIDNotFound
        case 422:
            return .displayIDNotFound
        case 500:
            return .serverError
        case 503:
            return .serverUnavailable
        case 506:
            return .itemNotAvailable
        case -1001:
            return .timeOut
        case -1002:
            return .unsuppotedURL
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        default:
            return .unknownError
        }
    }
    
    static fileprivate func mapError(_ error: NSError) -> WebResponseError {
        // TODO: Implement this for real
        return self.checkErrorCode(error.code)
    }
    
    static func description(for error: WebResponseError) -> String {
        switch error {
        case .invalidCredentials:
            return "Credentials have expired"
        case .invalidResponse:
            return "Invalid response from server"
        case .serverError:
            return "Server error"
        case .serverUnavailable:
            return "Server unavailable"
        case .connectionError:
            return "Unable to connect to server"
        case .invalidRequest:
            return "Invalid request was made"
        case .imageNotFound:
            return "Image Not Found"
        case .notFound:
            return "Not Found"
        case .inputTooLarge:
            return "Value is too large "
        case .invalidAuthorization:
            return "Unauthorised"
        case .storeIDNotFound:
            return "Invalid Store Id"
        case .floorIDNotFound:
            return "Invalid Floor Id"
        case .displayIDNotFound:
            return "Invalid Display Id"
        case .timeOut:
            return "Request timed out"
        case .unknownError:
            return "Encountered an unknown error"
        case .itemNotAvailable:
            return "VM and POS are out of sync\nPlease contact IT for support"
        case .unsuppotedURL:
            return "Unsupported URL, Please verify the base url specified"
        case .noInternet:
            return "No Internet Connection. Please connect your device to internet to proceed"
        }
    }
    
    static func logError(_ errorMessage: String, request: URLRequest?, response: HTTPURLResponse?) {
        print("\(errorMessage) requestUrl=\(String(describing: request?.url?.absoluteString)) responseStatusCode=\(String(describing: response?.statusCode)) requestId=\(String(describing: response?.allHeaderFields["X-ADC-Request-Id"])) serverVersion=\(String(describing: response?.allHeaderFields["X-ADC-Server-Version"]))")
    }
}
