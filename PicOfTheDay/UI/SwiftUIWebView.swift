//
//  SwiftUIWebView.swift
//  PicOfTheDay
//
//  Created by Shindalkar, Suraj Manmath on 9/24/22.
//

import SwiftUI
import WebKit

/// As of now i.e. 9/24/22, SwiftUI does not have support for WebView. This is UIViewRepresentable for WKWebView
struct WebView: UIViewRepresentable {
    
    // url WebView needs to open
    let url: URL
    
    // action for intercepting/callbacks from WKWebView
    let navigationAction: ((NavigationAction) -> Void)?
    
    enum NavigationAction {
        case decidePolicy(WKWebView, WKNavigationAction, WKNavigationActionPolicy)
        case didRecieveAuthChallenge(WKWebView, URLAuthenticationChallenge, URLSession.AuthChallengeDisposition, URLCredential?)
        case didStartProvisionalNavigation(WKWebView, WKNavigation)
        case didReceiveServerRedirectForNavigation(WKWebView, WKNavigation)
        case didCommit(WKWebView, WKNavigation)
        case didFinish(WKWebView, WKNavigation)
        case didFailProvisionalNavigation(WKWebView, WKNavigation, Error)
        case didFail(WKWebView, WKNavigation, Error)
    }
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            parent.navigationAction?(.didCommit(webView, navigation))
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.navigationAction?(.didFinish(webView, navigation))
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.navigationAction?(.didFail(webView, navigation, error))
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.navigationAction?(.didStartProvisionalNavigation(webView, navigation))
        }
    }
}
