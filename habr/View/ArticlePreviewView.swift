//
//  ArticlePreviewView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 06.05.2021.
//

import SwiftUI
import WebKit

struct ArticlePreviewView: View {
    @State private var webViewHeight: CGFloat = .zero
    var articlePreview: String
    let end = """
        </div></article>
        </div></div></main></div></div></body></html>
        """
    let start2 = """
                <html lang="ru" data-vue-meta="lang">
                <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width,user-scalable=0,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
                <link rel="stylesheet" href="https://dr.habracdn.net/habr-web/css/chunk-vendors.4e008149.css">
                <link rel="stylesheet" href="https://assets.habr.com/habr-web/css/app.60d4ef5b.css">
                </head>
                <body>
                <div class="tm-layout__wrapper tm-fira-loaded">
                <div class="tm-layout">
                <main class="tm-layout__container">
                <div class="tm-page__wrapper">
                <div class="tm-page-article__body">
                <article class="tm-page-article__content tm-page-article__content_inner">
                <div class="tm-article-body__content tm-article-body__content_formatted tm-article-body__content_formatted-v1">
                """
    var body: some View {
//        WebView_(request: start2 + articlePreview + end)

   //         Webview(dynamicHeight: $webViewHeight, linkwv: "", stringwv: start2 + articlePreview + end)
        //Text(articlePreview)
        
        Text("text")
        
    }
    
}

struct WebView_ : UIViewRepresentable {
    let request: String
    var webview: WKWebView = WKWebView()
    
    let requestURL: URLRequest
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView_
        
        init(_ parent: WebView_) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
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
        webview.navigationDelegate = context.coordinator
        webview.loadHTMLString(request, baseURL: nil)
        return webview
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
      //  uiView.loadHTMLString(request, baseURL: nil) 
    }
}

struct ArticlePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePreviewView(articlePreview: "article preview content")
    }
}
