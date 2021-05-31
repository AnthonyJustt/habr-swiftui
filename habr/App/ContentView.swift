//
//  ContentView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 22.03.2021.
//

import SwiftUI

struct ContentView: View {
    //   @State var showT: Bool = false
    //   @ObservedObject var state = ExampleState()
    @State private var tabSelection = 0
    var body: some View {
        //        Button(action: {
        //            //      state.update()
        //        }, label: {
        //            Text("false")
        //        })
        //   ZStack {
        TabView(selection: $tabSelection) {
            NavigationView {
                FeedView(farray: [], fNewsArray: [], viewName: "Habr  —  Лента", showingNews: true, httpsAddress: "https://m.habr.com/ru/all/", tabSelection: $tabSelection)
            } .tabItem {
                Image(systemName: "house")
                Text("Лента")
            }.tag(0)
            
            ReadingListView()
                .tabItem {
                    Image(systemName: "eyeglasses")
                    Text("Чтение")
                }.tag(1)
            
            SearchView(farray: [])
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Поиск")
                }.tag(2)
            
            NavigationView {
                FeedView(farray: [], fNewsArray: [], viewName: "Habr  —  Новости", showingNews: false, httpsAddress: "https://m.habr.com/ru/news/", tabSelection: $tabSelection)
            }
            .tabItem {
                Image(systemName: "newspaper")
                Text("Новости")
            }.tag(3)
            
            moreView()
                .tabItem {
                    Image(systemName: "square.grid.3x2.fill")
                    Text("Больше")
                }  .tag(4)
        }
        //                Text("ggg").bold()
        //                    .modifier(ConditionalModifier(isBold: false))
        // }
    }
}

/* class ExampleState: ObservableObject {
 @Published var message: Bool = false {
 didSet {
 print("didSet")
 }
 }
 func update() {
 print("before toggle")
 message.toggle()
 print("after toggle")
 }
 } */



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
