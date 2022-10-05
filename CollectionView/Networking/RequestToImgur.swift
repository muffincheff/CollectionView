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
    
    let clientID: String = "724ddc8a36019fa"
    let clientSecret: String = "66273c1f40e37b7d50d257a9355bb370388913da"
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
        /*
        //let url = "https://api.imgur.com/oauth2/authorize?client_id=0078dd924520584&response_type=token"
        let url = "https://api.imgur.com/oauth2/authorize?client_id=\(clientID)&response_type=token"
        //let url = "https://api.imgur.com/oauth2/addclient"
        let apiURI: URL! = URL(string: url)
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? ""
        print (" ## authenticate result .. \n\n\(log) \n\n")
        */
        
        
        //let url = "https://api.imgur.com/oauth2/authorize?client_id=\(clientID)&response_type=token"
        let url = "https://api.imgur.com/oauth2/token"
        var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
        request.addValue("Client-ID \(clientID)", forHTTPHeaderField: "Authorization")
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
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
        let url: String = "https://api.imgur.com/3/gallery/\(section)/\(sort)/\(window)/\(galleryPage)?showViral=\(String(showViral))&mature=\(String(mature))&album_previews=\(String(albumPreview))"
        
        //let url = "https://api.imgur.com/3/gallery/hot/viral/day/1?showViral=false&mature=false&album_previews=true"
        //let url = "https://api.imgur.com/oauth2/secret"
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
    
    
    // Blizzard auth
    func requestBlizzardAuth()
    {
        let url = URL(string: "https://kr.battle.net/oauth/token")!
        let params = [
               "grant_type" : "client_credentials",
               "client_id" : "46cb94c1b4a94a4fb71e8fe03035314a",
               "client_secret" : "ANYjYtg0jgw1nxsaIwUaB6NL46AxmEr7"
        ]
        let paramString = params.map {"\($0)=\($1)"}.joined(separator: "&") // for clarity and debugging

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = paramString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   print("empty data")
                   return
               }

               let dataString = String(data: data, encoding: .utf8)
               print(dataString)
        }.resume()
    }
    
    func getCards() {
        let url = URL(string: "https://kr.api.blizzard.com/hearthstone/cards?locale=ko_KR")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer KRqKqjFpemqHdowwNhTpwluxoJJz3DUoRi", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
               guard let data = data else {
                   print("empty data")
                   return
               }

               let dataString = String(data: data, encoding: .utf8)
               print(dataString)
        }.resume()
    }
    
}


