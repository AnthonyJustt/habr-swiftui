//
//  webView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 26.04.2021.
//

import SwiftUI
import WebKit

struct Webview : UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat
    var webview: WKWebView = WKWebView()
    var linkwv: String
    var stringwv: String
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview
        
        init(_ parent: Webview) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                    print("dynamicHeight - \(height as! CGFloat)")
                }
            })
// turning web page dark by inverting colors for dark mode
            let css = "@media (prefers-color-scheme: dark) { html{ filter: invert(1)  hue-rotate(.5turn); } img { filter: invert(1)  hue-rotate(.5turn); } }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            webView.evaluateJavaScript(js, completionHandler: nil)
// end of turning
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        //  let htmlStart = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>"
        //webview.loadHTMLString(htmlString, baseURL:  nil)
        //webview.load(URLRequest(url: URL(string: "https://m.habr.com/ru/post/553586/")!))
        
        //   DispatchQueue.global(qos: .userInitiated).async {
        // let htmlString = fparseArticle(fhtml: fname(furl: linkwv))
        // webview.loadHTMLString(htmlString, baseURL:  nil)
        
        if !linkwv.isEmpty {
            if isFileHere(fileName: linkwv) {
                print("webview: file is here_")
                print(link)
                let htmlString = readArticleFromFile(fileName: linkwv)
                webview.loadHTMLString(htmlString, baseURL:  nil)
            } else {
                print("webview: files not here_")
                print(link)
                saveToFile(fileName: linkwv)
                print("webview: file was saved_")
                print(link)
                let htmlString = readArticleFromFile(fileName: linkwv)
                webview.loadHTMLString(htmlString, baseURL:  nil)
    //            let fileNameFinal = linkwv.replacingOccurrences(of: "/", with: "-")
    //            let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
    //            webview.loadFileURL(url, allowingReadAccessTo: getDocumentsDirectory())
            }
        } else {
            webview.loadHTMLString(stringwv, baseURL: nil)
        }

        // }
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}
