//
//  ContentView_v2.swift
//  ContentView_v2
//
//  Created by Anton Krivonozhenkov on 20.08.2021.
//

import SwiftUI
import CoreData

struct ContentView_v2: View {
    
    @EnvironmentObject var quickActionObservable: QuickActionObservable
    
    @State private var tabSelection = 0
    
    @State var HArray: [FeedListItem] = []
    @State var HArrayNews: [FeedListItem] = []
    @State var HArrayEmbedNews: [FeedNewsItem] = []
    @State private var hString: String = ""
    @State private var hStringNews: String = ""
    var httpsAddress: String = "https://m.habr.com/ru/all/"
    var httpsAddressNews: String = "https://m.habr.com/ru/news/"
    
    //    @State var timeIsUp: String = ""
    
    let concurrentQueue = DispatchQueue(label: "content_v2.loading.data", attributes: .concurrent)
    @State private var workItemFeed: DispatchWorkItem = DispatchWorkItem { }
    @State private var workItemNews: DispatchWorkItem = DispatchWorkItem { }
    
    var body: some View {
        
        ZStack {
            TabView(selection: $tabSelection) {
                
           //     NavigationView {
                    FeedView_v2(HArray: $HArray, HArrayEmbedNews: $HArrayEmbedNews, showToast: false, viewName: "Content.FeedTitle", showingNews: true, tabSelection: $tabSelection)
           //     }
                .tabItem {
                    Image(systemName: "house")
                    Text(LocalizedStringKey("Content.Feed"))
                }.tag(0)
                
                ReadingListView()
                    .tabItem {
                        Image(systemName: "eyeglasses")
                        Text(LocalizedStringKey("Content.ReadingList"))
                    }.tag(1)
                
                SearchView(farray: [])
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text(LocalizedStringKey("Content.Search"))
                    }.tag(2)
                
            //    NavigationView {
                    FeedView_v2(HArray: $HArrayNews, HArrayEmbedNews: $HArrayEmbedNews, showToast: false, viewName: "Content.NewsTitle", showingNews: false, tabSelection: $tabSelection)
              //  }
                .tabItem {
                    Image(systemName: "newspaper")
                    Text(LocalizedStringKey("Content.News"))
                }.tag(3)
                
                moreView()
                    .tabItem {
                        Image(systemName: "ellipsis")
                        Text(LocalizedStringKey("Content.More"))
                    }  .tag(4)
            }.onAppear(perform: {
                
                DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 30) {
                    workItemNews.cancel()
                    print("news - cancelled")
                    workItemFeed.cancel()
                    print("feed - cancelled")
                }
                
                workItemFeed = DispatchWorkItem {
                    print("Task 1 started")
                    hString = fname(furl: httpsAddress)
                    HArray = fparse(fhtml: hString)
                    print("Task 1 finished")
                }
                
                workItemNews = DispatchWorkItem {
                    print("Task 2 started")
                    hStringNews = fname(furl: httpsAddressNews)
                    HArrayNews = fparse(fhtml: hStringNews)
                    print("Task 2 finished")
                    
                    for i in 0 ..< 5 {
                        HArrayEmbedNews.append(FeedNewsItem(title: HArrayNews[i].title, date: HArrayNews[i].date, comments: HArrayNews[i].date, link: HArrayNews[i].link))
                    }
                }
                
                concurrentQueue.async(execute: workItemFeed)
                concurrentQueue.async(execute: workItemNews)
            })
            
            //            Text(timeIsUp)
            
            if quickActionObservable.selectedAction?.title != nil {
                Text(quickActionObservable.selectedAction!.title)
                    .onAppear(perform: {tabSelection = 1})
                //tabSelection = 1
            }
        }
    }
}

struct ContentView_v2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView_v2()
//            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
