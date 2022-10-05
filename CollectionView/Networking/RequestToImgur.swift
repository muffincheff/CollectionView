//
//  RequestToImgur.swift
//  meme-moa
//
//  Created by orca on 2020/06/23.
//  Copyright © 2020 example. All rights reserved.
//

import Foundation

class RequestToImgur {
    static let shared: RequestToImgur = RequestToImgur()
    
    let clientID: String = "f29012231aa7bc8"
    let clientSecret: String = "645c54a568e3fdd4fa82d0b07c1e8c296b9fdba7"
    var semaphore = DispatchSemaphore (value: 0)
    let parameters = [] as [[String : Any]]
    let boundary = "Boundary-\(UUID().uuidString)"
    var body = ""
    var error: Error? = nil
    var galleryPage: Int = 0
    
    private init() { }
    
    func setBody() {
        for param in parameters {
            if param["disabled"] != nil { continue }
            
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
        
        body += "--\(boundary)--\r\n";
    }
    
    
    func authenticate() {
        let url = "https://api.imgur.com/oauth2/authorize?client_id=0078dd924520584&response_type=token"
        //let url = "https://api.imgur.com/oauth2/addclient"
        let apiURI: URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        print (" ## authenticate result .. \n\n\(log) \n\n")
        
    }
    
    
    /*
     
     ## Gallery ##
     
     Key        Required    Value
     
     section    optional    hot | top | user
     sort       optional    viral | top | time
     page       optional    integer
     window     optional    day | week | month | year | all
     
     */
    func requestGallery(section: String, sort: String, window: String, showViral: Bool = true, mature: Bool = false, albumPreview: Bool = false) {
        
        setBody()
        galleryPage += 1
        
        let postData = body.data(using: .utf8)
        //let url: String = "https://api.imgur.com/3/gallery/\(section)/\(sort)/\(window)/\(galleryPage)?showViral=\(String(showViral))&mature=\(String(mature))&album_previews=\(String(albumPreview))"
        let url = "https://api.imgur.com/3/gallery/hot/viral/day/1?showViral=false&mature=false&album_previews=true"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(" ## request err .. \n\n \(String(describing: error)) \n\n")
                return
            }
            
            print(" ## request result .. \n\n \(String(data: data, encoding: .utf8)!) \n\n ")
            self.semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
}


