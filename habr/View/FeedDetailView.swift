//
//  FeedDetailView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 30.03.2021.
//

import SwiftUI

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
                        .padding(20)
                    
                    Webview(dynamicHeight: $webViewHeight, linkwv: link, stringwv: "")
                        .frame(height: webViewHeight)
                    
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
                .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(trailing:
                                        Button (action:{
                                            if isLocal { isLocal.toggle() }
                                        }){
                                            Image(systemName: checkingLocal(fileName: link).isLocal ? "externaldrive.fill.badge.checkmark" : "cloud.fill").font(.title3)
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

struct FeedDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FeedDetailView(title: "Заголовок_", link: "", comments: "000_")
    }
}
