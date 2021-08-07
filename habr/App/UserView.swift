//
//  UserView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI
import WebKit

struct UserView: View {
    var body: some View {
        WebViewURL(request: URLRequest(url: URL(string: "https://account.habr.com/login/")!))
    }
}

struct WebViewURL : UIViewRepresentable {
    let request: URLRequest
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView()
    }
}
