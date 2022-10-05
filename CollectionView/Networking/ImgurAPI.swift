//
//  ImgurAPI.swift
//  CollectionView
//
//  Created by orca on 2020/06/16.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

class ImgurAPI {
    
    /*
     lazy var accessToken: String = {
     return getAccessToken()
     }()
     */
    
    var semaphore = DispatchSemaphore (value: 0)
    
    let parameters = [
        [
            "key": "refresh_token",
            "value": "bd8f8a17d340d053aae724663abf04f69a738824",
            "type": "text"
        ],
        [
            "key": "client_id",
            "value": "0078dd924520584",
            "type": "text"
        ],
        [
            "key": "client_secret",
            "value": "2c2429798080a55fa67ad17c87fbbe8e74c3c224",
            "type": "text"
        ],
        [
            "key": "grant_type",
            "value": "refresh_token",
            "type": "text"
        ]] as [[String : Any]]
    
    func athenticate() {
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        //var error: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let fileData = try! NSData(contentsOfFile:paramSrc, options:[]) as Data
                    let fileContent = String(data: fileData, encoding: .utf8)!
                    body += "; filename=\"\(paramSrc)\"\r\n"
                        + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://api.imgur.com/oauth2/token")!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        
        //https://api.imgur.com/oauth2/authorize?client_id=0078dd924520584&response_type=token&state=APPLICATION_STATE
        
    }
    
    
    func authorization() {
        DispatchQueue.main.async {
            // https://www.getpostman.com/oauth2/callback
            let url: URL! = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=f29012231aa7bc8&response_type=token")
            let data = try! Data(contentsOf: url)
            let log = NSString(data: data, encoding: String.Encoding.utf8.rawValue) ?? "data not exist.."
            NSLog("\n\n ## imgur API - Authorization ##\n\(log)\n\n")
        }
        
    }
 
}
