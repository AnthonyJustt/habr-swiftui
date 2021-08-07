//
//  FeedDetailView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 30.03.2021.
//

import SwiftUI
import WebKit

func checkingLocal(fileName: String) -> (html: String, isLocal: Bool) {
    let htmlString: String
    if isFileHere(fileName: fileName) {
        print("webview: file is here_")
        print(link)
        htmlString = readTagsFromFile(fileName: fileName)
        return (htmlString, true)
    } else {
        print("webview: files not here_")
        print(link)
        saveToFile(fileName: fileName)
        print("webview: file was saved_")
        print(link)
        htmlString = readTagsFromFile(fileName: fileName)
        return(htmlString, false)
    }
}

struct FeedDetailView: View {
    
    private func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    // 2
    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        
        // Image was pulled down
        if offset > 0 {
            return -offset
        }
        
        return 0
    }
    
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        
        if offset > 0 {
            return imageHeight + offset
        }
        
        return imageHeight
    }
    
    private func getBlurRadiusForImage(_ geometry: GeometryProxy) -> CGFloat {
        // 2
        let offset = geometry.frame(in: .global).maxY
        
        let height = geometry.size.height
        let blur = (height - max(offset, 0)) / height // 3 (values will range from 0 - 1)
        return blur * 6 // Values will range from 0 - 6
    }
    
    var title: String
    var link: String
    var comments: String
    @State private var webViewHeight: CGFloat = .zero
    @State private var isLocal: Bool = true
    
    @State private var hubArray: [feedTagsItem] = []
    @State private var tagArray: [feedTagsItem] = []
    @State private var labelArray: [feedTagsItem] = []
    @State private var originalArray: [feedTagsItem] = []
    
    @State var isHidden: Bool = true
    
    //    private func checking() -> Bool {
    //        if isFileHere(fileName: link) {
    //            print("checking: file is here_")
    //            //isLocal = true
    //            return true
    //        } else {
    //            print("checking: files not here_")
    //            //isLocal = false
    //            return false
    //        }
    //    }
    
    var body: some View {
        // NavigationView {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                //            GeometryReader { geometry in
                //                Image("Placeholder")
                //                    .resizable()
                //                    .scaledToFill()
                //                    .frame(width: geometry.size.width, height: self.getHeightForHeaderImage(geometry)) // 2
                //                    .blur(radius: self.getBlurRadiusForImage(geometry)) // 4
                //                    .clipped()
                //                    .offset(x: 0, y: self.getOffsetForHeaderImage(geometry)) // 3
                //            }.frame(height: 200)
                VStack {
                    Text(title)
                        .font(.system(.title2))
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding([.horizontal, .top], 20)
                    
                    Webview(dynamicHeight: $webViewHeight, linkwv: link, stringwv: "")
                        .frame(height: webViewHeight)
                    
                    //                    WebView_(request: readArticleFromFile(fileName: link))
                    //                        .frame(height: 500)
                    //
                    //                    WebViewT(request: URLRequest(url: URL(string: "https://m.habr.com"+link)!))
                    //                        .frame(height: 500)
                    //
                    //
                    //                    let fileNameFinal = link.replacingOccurrences(of: "/", with: "-")
                    //                    //                        let url = getDocumentsDirectory().appendingPathComponent(fileNameFinal)
                    //
                    //                    let documentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    //                    let indexFileUrl = documentDirUrl.appendingPathComponent(fileNameFinal)
                    //                    WebViewF(request: indexFileUrl, request2: documentDirUrl)
                    //                        .frame(height: 500)
                    
                    
                    
                    
                    
                    VStack(alignment: .leading) {
                        Text("Хабы: ").bold()
                        ForEach(hubArray, id: \.id) {
                            item in tagView(title: item.title)
                        }
                        Text("Теги: ").bold()
                        ForEach(tagArray, id: \.id) {
                            item in tagView(title: item.title)
                        }
                        Divider()
                        ForEach(labelArray, id: \.id) {
                            item in labelView(title: item.title)
                        }
                        ForEach(originalArray, id: \.id) {
                            item in buttonOriginalView(author: item.title)
                        }
                    }
                    .padding()
                    
                    NavigationLink (destination: CommentsView(farray: [commentsItem(
                        content: "content_",
                        indent: "content_",
                        author: "content_",
                        author_link: "content_",
                        date: "content_",
                        link: "content_",
                        rate: "content_"
                    )], title: title, link: link)) {
                        CommentsButtonView(comments: comments)
                            .padding()
                    }
                    
                }
                //.navigationBarTitle("", displayMode: .inline)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                
                .toolbar(content: {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                        }) {
                            Image(systemName: "bubble.right").font(.title3)
                        }
                        Button(action: {
                            if isLocal { isLocal.toggle() }
                        }) {
                            Image(systemName: checkingLocal(fileName: link).isLocal ? "externaldrive.fill.badge.checkmark" : "cloud.fill").font(.title3)
                        }
                    }
                })
                //  .navigationBarHidden(true)
            }
            .opacity(isHidden ? 0 : 1)
            
            ProgressView()
                .opacity(isHidden ? 1 : 0)
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear(perform: {
                    DispatchQueue.global(qos: .userInitiated).async {
                        (hubArray, tagArray, labelArray, originalArray) = fparseTags(fhtml: checkingLocal(fileName: link).html)
                        isHidden = false
                    }
                })
        }
        //  .edgesIgnoringSafeArea(.top)
        //  }
        //  .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WebViewT : UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}

struct WebViewF : UIViewRepresentable {
    
    let request: URL
    let request2: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadFileURL(request, allowingReadAccessTo: request2)
    }
}

struct FeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FeedDetailView(title: "Заголовок_", link: "", comments: "000_")
    }
}
