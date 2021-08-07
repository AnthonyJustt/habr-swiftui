//
//  FeedView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct FeedView: View {
    
    @State var farray: [FeedListItem]
    @State var fNewsArray: [FeedNewsItem]
    @State private var firstLoad = true
    @State private var pageNumber: Int = 1
    @State private var fString: String = ""
    
    @State var showToast: Bool =  false
    
    var viewName: String
    var showingNews: Bool
    var httpsAddress: String
    
    @Binding var tabSelection: Int
    
    @State var timeRemaining = 20
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            RefreshControl(coordinateSpace: .named("RefreshControl")) {
                print("refreshing")
                firstLoad = true
                pageNumber = 1
                farray = []
                fNewsArray = []
            }
            
            ScrollViewReader { proxy in
                
                //                Text("scroll").onTapGesture(perform: {
                //                    proxy.scrollTo(9)
                //                })
                
//                Text("\(timeRemaining)")
//                    .onReceive(timer) { _ in
//                        if timeRemaining > 0 {
//                            timeRemaining -= 1
//                            if timeRemaining == 5 {
//                                self.timer.upstream.connect().cancel()
//                            }
//                        }
//                    }
                
                
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(farray.indices, id: \.self) { index in
                        NavigationLink (destination: FeedDetailView(
                            title: farray[index].title,
                            link: farray[index].link,
                            comments: farray[index].comments
                        )) {
                            FeedListItemView(feedListItem: farray[index], showToast: $showToast)
                                
                                .id(index)
                            
                        }
                        if index == 0 && showingNews == true {
                            EmbedNewsView(farrayNews: fNewsArray, tabSelection: $tabSelection)
                                .frame(height: 200)
                                .padding()
                        }
                    }
                    HStack(alignment: .center) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .onAppear(perform: {
                                if firstLoad {
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        fString = fname(furl: httpsAddress)
                                        fNewsArray = fparseNews(fhtml: fString)
                                        farray = fparse(fhtml: fString)

                                        firstLoad = false
                                        
//                                             DispatchQueue(label: viewName).async {
//                                                fString = fname(furl: httpsAddress)
//                                                DispatchQueue.main.async {
//                                                fNewsArray = fparseNews(fhtml: fString)
//                                                farray = fparse(fhtml: fString)
//                                                }
//                                                firstLoad = false
                                    }
                                    
                                    //                                        }
                                } else {
                                    pageNumber += 1
                                    print("load more - page \(pageNumber)")
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        farray += fparse(fhtml: fname(furl: "\(httpsAddress)page\(pageNumber)/"))
                                    }
                                }
                            })
                    }
                    .padding()
                }
                
            }
        }
        .navigationTitle(LocalizedStringKey(viewName))
        .coordinateSpace(name: "RefreshControl")
        //   .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: {
        })
        .toast(isPresenting: $showToast){
            AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle", .green), title: "Список чтения", subTitle: "Статья добавлена в список")
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static let fli: [ FeedListItem ] = [FeedListItem(
                                            title: "Заголовок_",
                                            author: "Автор_",
                                            author_link: "",
                                            date: "сегодня в 00:00_",
                                            rate: "3",
                                            rate_detail: "",
                                            view: "1234_",
                                            bookmark: "5678_",
                                            comments: "9999",
                                            link: "",
                                            article_snippet: "",
                                            offset: 0,
                                            isSwiped: false) ]
    static let fna: [ FeedNewsItem ] = [FeedNewsItem(
                                            title: "",
                                            date: "",
                                            comments: "",
                                            link: "") ]
    @State static var previewTabSelection = 3
    static var previews: some View {
        FeedView(farray: fli, fNewsArray: fna, viewName: "Content.NewsTitle", showingNews: true, httpsAddress: "https://m.habr.com/ru/all/", tabSelection: $previewTabSelection)
    }
}
