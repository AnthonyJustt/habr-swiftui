//
//  FeedListItemView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 29.03.2021.
//

// swipe:
// https://www.youtube.com/watch?v=jXVQDmeNb8A
// https://kavsoft.dev/SwiftUI_2.0/Cart_UI/

import SwiftUI

struct FeedListItemView: View {
    
    @State private var swipeVisible: Bool = false
    
    @State private var isShowingComments: Bool = false
    @State private var isShowingAuthor: Bool = false
    @State private var showingPopover: Bool = false
    
    let pasteboard = UIPasteboard.general
    
    // persistence
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Entity.title, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Entity>
    
    private func addItemToPersistence() {
        withAnimation {
            let newItem = Entity(context: viewContext)
            newItem.title = feedListItem.title
            newItem.link = feedListItem.link
            newItem.comments = feedListItem.comments
            newItem.id = UUID()
            newItem.dateAdded = Date()
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // persistence
    
    @State var feedListItem: FeedListItem
    @Binding var showToast: Bool
    
    var hapticImpact = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ZStack {
            
            // swipe
            swipeVisible ? Color("AccentColor") : Color("FeedListItem")
            HStack{
                Spacer()
                Button(action: {
                    withAnimation(.easeIn) { addItemToReadingList() }
                }) {
                    Image(systemName: "eyeglasses")
                        .renderingMode(.original)
                        .font(.title)
                        .foregroundColor(Color("FeedListItem"))
                        .frame(width: 90, height: 100)
                }
            }
            // swipe
            
            VStack(alignment: .leading, spacing: 16) {
                Divider()
                HStack(alignment: .center, spacing: 2) {
                    Text(feedListItem.author)
                        .font(.system(.body))
                        .foregroundColor(.gray)
                        .onTapGesture {
                            print("author")
                            isShowingAuthor = true
                        }
                        .sheet(isPresented: $isShowingAuthor, content: {
                            AuthorView(farray: AuthorItem(card_name: "", card_nickname: "", short_info: "", karma: "", rating: ""), title: feedListItem.author, link: feedListItem.author_link)
                        })
                    Spacer()
                    Text(feedListItem.date)
                        .font(.system(.body))
                        .foregroundColor(.gray)
                }
                Text(feedListItem.title)
                    .font(.system(.title2))
                    .foregroundColor(Color("FeedListFont"))
                    .fontWeight(.bold)
                    //.foregroundColor(Color("ColorGreenMedium"))
                    .multilineTextAlignment(.leading)
                //.padding()
                HStack(alignment: .center, spacing: 2) {
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "rhombus")
                        // Text(feedListItem.rate) // рейтинг
                        
                        if feedListItem.rate == "0" {
                            Text(feedListItem.rate)
                        }
                        if (Int(feedListItem.rate) ?? 0) > 0 {
                            Text(feedListItem.rate)
                                .foregroundColor(.green)
                        }
                        if (Int(feedListItem.rate) ?? 0) < 0 {
                            Text(feedListItem.rate)
                                .foregroundColor(.red)
                        }
                    }
                    .onTapGesture {
                        showingPopover = true
                    }
                    .alert(isPresented: $showingPopover) {
                        Alert(title: feedListItem.rate_detail.isEmpty ? Text("Голосов нет") : Text(feedListItem.rate_detail), message: Text(""), dismissButton: .default(Text("OK")))
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "eye")
                        Text(feedListItem.view) // просмотры
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "bookmark")
                        Text(feedListItem.bookmark) // закладки
                    }
                    Spacer()
                    HStack(alignment: .center, spacing: 2) {
                        Image(systemName: "bubble.right")
                        Text(feedListItem.comments) // комментарии
                    }
                    .sheet(isPresented: $isShowingComments){
                        CommentsView(farray: [], title: feedListItem.title, link: feedListItem.link)
                    }
                    .onTapGesture {
                        print("comments")
                        isShowingComments = true
                    }
                }
                // .font(.footnote)
                .foregroundColor(.gray)
            }
            //.padding([.top, .leading, .trailing])
            .padding()
            .background(Color("FeedListItem"))
            .contentShape(Rectangle())
            .offset(x: feedListItem.offset)
            .gesture(DragGesture().onChanged(onChanged(value:)) .onEnded(onEnd(value:)))
        }
        
        .previewContextMenu(
            //   destination: ArticlePreviewView(articlePreview: feedListItem.article_snippet),
            preview: ArticlePreviewView(articlePreview: feedListItem.article_snippet),
            //  preferredContentSize: .init(width: 300, height: 150),
            actions: {[
                PreviewContextAction(
                    title: "FeedListItem.CopyLink",
                    systemImage: "doc.on.doc",
                    action: {
                        print("Скопировать ссылку")
                        pasteboard.string = "https://m.habr.com\(feedListItem.link)"
                    }),
                PreviewContextAction(
                    title: "FeedListItem.OpenBrowser",
                    systemImage: "safari",
                    action: {
                        print("Открыть в браузере")
                        UIApplication.shared.open(URL(string: "https://m.habr.com\(feedListItem.link)")!)
                    }),
                PreviewContextAction(
                    title: "FeedListItem.OpenComments",
                    systemImage: "safari",
                    action: {
                        print("Открыть комментарии в браузере")
                        UIApplication.shared.open(URL(string: "https://m.habr.com\(feedListItem.link)comments")!)
                    }),
                PreviewContextAction(
                    title: "FeedListItem.AddtoReading",
                    systemImage: "eyeglasses",
                    action: {
                        print("Добавить в список чтения")
                        addItemToPersistence()
                        showToast.toggle()
                        hapticImpact.impactOccurred()
                    })
            ]})
    }
    
    func onChanged(value: DragGesture.Value) {
        if value.translation.width < 0{
            if feedListItem.isSwiped{
                feedListItem.offset = value.translation.width - 90
                
                print("1")
                swipeVisible = false
                
            }
            else{
                feedListItem.offset = value.translation.width
                
                print("2")
                swipeVisible = true
            }
        }
    }
    
    func onEnd(value: DragGesture.Value) {
        withAnimation(.easeOut) {
            if value.translation.width < 0 {
                if -value.translation.width > UIScreen.main.bounds.width / 2 {
                    feedListItem.offset = -1000
                    addItemToReadingList()
                    print("3")
                    swipeVisible = false
                }
                else if -feedListItem.offset > 50 {
                    feedListItem.isSwiped = true
                    feedListItem.offset = -90
                    print("4")
                    swipeVisible = true
                }
                else{
                    feedListItem.isSwiped = false
                    feedListItem.offset = 0
                    print("5")
                    swipeVisible = false
                }
            }
            else{
                feedListItem.isSwiped = false
                feedListItem.offset = 0
                print("6")
                swipeVisible = false
            }
        }
    }
    
    func addItemToReadingList() {
        addItemToPersistence()
        showToast.toggle()
        hapticImpact.impactOccurred()
        feedListItem.isSwiped = false
        feedListItem.offset = 0
    }
}

struct FeedListItemView_Previews: PreviewProvider {
    
    static let fli: [ FeedListItem ] = [FeedListItem(
        title: "Заголовок_",
        author: "Автор_",
        author_link: "",
        date: "сегодня в 00:00_",
        rate: "0",
        rate_detail: "",
        view: "1234_",
        bookmark: "5678_",
        comments: "9999_",
        link: "",
        article_snippet: "",
        offset: 0,
        isSwiped: false
    ) ]
    
    @State static var show: Bool = false
    
    static var previews: some View {
        FeedListItemView(feedListItem: fli[0], showToast: $show)
            .previewLayout(.fixed(width: 400, height: 170))
            .padding()
    }
}
