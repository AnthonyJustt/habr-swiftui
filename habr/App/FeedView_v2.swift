//
//  FeedView_v2.swift
//  FeedView_v2
//
//  Created by Anton Krivonozhenkov on 20.08.2021.
//

import SwiftUI

struct FeedView_v2: View {
    @Binding var HArray: [FeedListItem]
    @Binding var HArrayEmbedNews: [FeedNewsItem]
    @State var showToast: Bool =  false
    var viewName: String
    var showingNews: Bool
    @Binding var tabSelection: Int
    @State private var firstLoad = true
    @State private var pageNumber: Int = 1
    var httpsAddress: String = "https://m.habr.com/ru/all/"
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                
                RefreshControl(coordinateSpace: .named("RefreshControl")) {
                    print("refreshing")
                    firstLoad = true
                    pageNumber = 1
                    HArray = []
                    HArrayEmbedNews = []
                }
                
                //            Button(action: {
                //                HArray = HArray + [FeedListItem(title: "title_test", author: "", author_link: "", date: "", rate: "", rate_detail: "", view: "", bookmark: "", comments: "", link: "", article_snippet: "", offset: 0, isSwiped: false)]
                //            }) {
                //                Text("button")
                //            }
                
                ScrollViewReader { proxy in
                    
                    LazyVStack(alignment: .center, spacing: 0) {
                        ForEach(HArray.indices, id: \.self) { index in
                            NavigationLink(destination: FeedDetailView(
                                title: HArray[index].title,
                                link: HArray[index].link,
                                comments: HArray[index].comments
                            )) {
                            FeedListItemView(feedListItem: HArray[index], showToast: $showToast).id(index)
                            }
                            if index == 0 && showingNews == true {
                                EmbedNewsView(farrayNews: $HArrayEmbedNews, tabSelection: $tabSelection)
                                    .frame(height: 200)
                                    .padding()
                            }
                        }
                        HStack(alignment: .center) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .onAppear(perform: {
                                    pageNumber += 1
                                    print("load more - page \(pageNumber)")
                                    DispatchQueue.global(qos: .userInitiated).async {
                                        HArray += fparse(fhtml: fname(furl: "\(httpsAddress)page\(pageNumber)/"))
                                    }
                                })
                        }
                    }
                }
            }
            .coordinateSpace(name: "RefreshControl")
            .navigationTitle(LocalizedStringKey(viewName))
        }
        .toast(isPresenting: $showToast){
            AlertToast(displayMode: .hud, type: .systemImage("checkmark.circle", .green), title: "Список чтения", subTitle: "Статья добавлена в список")
    }
    }
}

struct FeedView_v2_Previews: PreviewProvider {
    @State static var ddd = [FeedListItem(title: "title0", author: "", author_link: "", date: "", rate: "", rate_detail: "", view: "", bookmark: "", comments: "", link: "", article_snippet: "", offset: 0, isSwiped: false)]
    @State static var nnn = [FeedNewsItem(title: "news", date: "", comments: "", link: "")]
    @State static var previewTabSelection = 3
    static var previews: some View {
        FeedView_v2(HArray: $ddd, HArrayEmbedNews: $nnn, showToast: false, viewName: "Content.NewsTitle", showingNews: true, tabSelection: $previewTabSelection)
    }
}
