//
//  TestWebViewController.swift
//  CollectionView
//
//  Created by orca on 2020/06/19.
//  Copyright © 2020 example. All rights reserved.
//

import UIKit
import WebKit

class TestWebViewController: UIViewController {

    @IBOutlet var webview: WKWebView!
    var newWebviewPopupWindow: WKWebView?
    var popupWebView: WKWebView?
    var urlPath: String = ""
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "https://api.imgur.com/oauth2/authorize?client_id=f29012231aa7bc8&response_type=token")
//        let url = URL(string: "https://www.googleapis.com/auth/blogger")
        //let url = URL(string: "https://www.daum.net/")
        let urlRequest = URLRequest(url: url!)
//        urlRequest.addValue("", forHTTPHeaderField: <#T##String#>)
        
        //self.webview.snapshotView(afterScreenUpdates: true)
        
        self.webview.load(urlRequest)
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        urlPath = "https://api.imgur.com/oauth2/authorize?client_id=\(RequestToImgur.shared.clientID)&response_type=token"
        setupWebView()
        loadWebView()
    }
    //MARK: Setting up webView
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true

        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences

        webview = WKWebView(frame: view.bounds, configuration: configuration)
        webview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webview.uiDelegate = self
        webview.navigationDelegate = self

        view.addSubview(webview)
    }

    func loadWebView() {
        if let url = URL(string: urlPath) {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue("Client-ID \(RequestToImgur.shared.clientID)", forHTTPHeaderField: "Authorization")
            webview.load(urlRequest)
        }
    }

}


// MARK:- WKUIDelegate, WKNavigationDelegate
extension TestWebViewController: WKUIDelegate, WKNavigationDelegate
{
    // test!
    /*
    override func loadView() {
        webview = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        self.webview.uiDelegate = self
        self.webview.navigationDelegate = self
        
        view = webview
    }
 */
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        /*
        self.webview.load(navigationAction.request)
        return nil
        */
        
        /*
        newWebviewPopupWindow = WKWebView(frame: view.bounds, configuration: configuration)
        newWebviewPopupWindow!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newWebviewPopupWindow!.navigationDelegate = self
        newWebviewPopupWindow!.uiDelegate = self
        view.addSubview(newWebviewPopupWindow!)
        return newWebviewPopupWindow!
        */
        
        popupWebView = WKWebView(frame: view.bounds, configuration: configuration)
        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
        view.addSubview(popupWebView!)
        return popupWebView!
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        let response = navigationResponse.response as? HTTPURLResponse
        let headers = response?.allHeaderFields
        decisionHandler(.allow)
            
        
        
    }
    

    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("---- didFinish ---")
//        RequestToImgur.shared.requestGallery(section: "hot", sort: "viral", window: "day")
        RequestToImgur.shared.authenticate()
    }
    
    
    /*
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration,
             for navigationAction: WKNavigationAction,
             windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
        let newView = WKWebView(frame: webview.frame, configuration: configuration)

        newView.customUserAgent = webView.customUserAgent
        newView.navigationDelegate = self
        newView.uiDelegate = self

        self.view.addSubview(newView)
//        newView.fit(newView.superview!)

        newView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        newView.configuration.preferences.javaScriptEnabled = true
        newView.configuration.preferences.plugInsEnabled = true
        newView.load(navigationAction.request)

        return newView
        }
        
        return nil
    }
 */
    
   
    
    
    func webViewDidClose(_ webView: WKWebView) {
    //    webview.removeFromSuperview()
    //    newWebviewPopupWindow = nil
        
        if webView == popupWebView {
            popupWebView?.removeFromSuperview()
            popupWebView = nil
        }
    }
    
}



