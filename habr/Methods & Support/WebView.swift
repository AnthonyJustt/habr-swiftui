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
            webView.evaluateJavaScript("""
                document.getElementsByClassName('tm-feature')[0].remove();
                document.getElementsByClassName('tm-header')[0].remove();
                document.getElementsByClassName('tm-page__header')[0].remove();
                document.getElementsByClassName('pull-down__header')[0].remove();
                document.getElementsByClassName('tm-page-article__head-wrapper')[0].remove();
                document.getElementsByClassName('tm-article-body__tags')[0].remove();
                document.getElementsByClassName('tm-article__icons-wrapper')[0].remove();
                document.getElementsByClassName('tm-page-article__additional-blocks')[0].remove();
                document.getElementsByClassName('tm-footer')[0].remove();
                """, completionHandler: nil)
            
            webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    if height != nil {
                        self.parent.dynamicHeight = height as! CGFloat
                        print("dynamicHeight - \(height as! CGFloat)")
                    } else {
                        print("Doesn’t contain a value.")
                    }
                }
            })
            // turning web page dark by inverting colors for dark mode
            let css = "@media (prefers-color-scheme: dark) { html{ filter: invert(1)  hue-rotate(.5turn); } img { filter: invert(1)  hue-rotate(.5turn); } }"
            let js = "var style = document.createElement('style'); style.innerHTML = '\(css)'; document.head.appendChild(style);"
            webView.evaluateJavaScript(js, completionHandler: nil)
            // end of turning
            
            //webView.exportAsPdfFromWebView()
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
        print("https://m.habr.com"+linkwv)
        webview.load(URLRequest(url: URL(string: "https://m.habr.com"+linkwv)!))
        
        //   DispatchQueue.global(qos: .userInitiated).async {
        // let htmlString = fparseArticle(fhtml: fname(furl: linkwv))
        // webview.loadHTMLString(htmlString, baseURL:  nil)
        
        //        if !linkwv.isEmpty {
        //            if isFileHere(fileName: linkwv) {
        //                print("webview: file is here_")
        //                print(link)
        //                let htmlString = readArticleFromFile(fileName: linkwv)
        //                webview.loadHTMLString(htmlString, baseURL:  nil)
        //            } else {
        //                print("webview: files not here_")
        //                print(link)
        //                saveToFile(fileName: linkwv)
        //                print("webview: file was saved_")
        //                print(link)
        //                let htmlString = readArticleFromFile(fileName: linkwv)
        //                webview.loadHTMLString(htmlString, baseURL:  nil)
        //    //            let fileNameFinal = linkwv.replacingOccurrences(of: "/", with: "-")
        //    //            let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
        //    //            webview.loadFileURL(url, allowingReadAccessTo: getDocumentsDirectory())
        //            }
        //        } else {
        //            webview.loadHTMLString(stringwv, baseURL: nil)
        //        }
        
        // }
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

extension WKWebView {
    
    // Call this function when WKWebView finish loading
    func exportAsPdfFromWebView() -> String {
        let pdfData = createPdfFile(printFormatter: self.viewPrintFormatter())
        return self.saveWebViewPdf(data: pdfData)
    }
    
    func createPdfFile(printFormatter: UIViewPrintFormatter) -> NSMutableData {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x: originalBounds.origin.x, y: bounds.origin.y, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.scrollView.contentSize.height)
        let printPageRenderer = UIPrintPageRenderer()
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        printPageRenderer.setValue(NSValue(cgRect: UIScreen.main.bounds), forKey: "paperRect")
        printPageRenderer.setValue(NSValue(cgRect: pdfPageFrame), forKey: "printableRect")
        self.bounds = originalBounds
        return printPageRenderer.generatePdfData()
    }
    
    // Save pdf file in document directory
    func saveWebViewPdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("webViewPdf.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}

extension UIPrintPageRenderer {
    
    func generatePdfData() -> NSMutableData {
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, self.paperRect, nil)
        self.prepare(forDrawingPages: NSMakeRange(0, self.numberOfPages))
        let printRect = UIGraphicsGetPDFContextBounds()
        for pdfPage in 0..<self.numberOfPages {
            UIGraphicsBeginPDFPage()
            self.drawPage(at: pdfPage, in: printRect)
        }
        UIGraphicsEndPDFContext();
        return pdfData
    }
}
