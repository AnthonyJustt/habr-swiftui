//
//  commentListItemView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 25.04.2021.
//

import SwiftUI

struct commentListItemView: View {
    var commentsListItem: commentsItem
    let pasteboard = UIPasteboard.general
    @State private var showingActionSheet = false
    @State private var isShowingAuthor: Bool = false
    
    @Binding var toggleBottom: Bool
    
    func str(s: String) -> Bool {
        if s.contains("Комментарий был изменен") {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        HStack {
            // indent starts
            if commentsListItem.indent != "0" {
                Text("  ")
                    .background(
                        Circle()
                            .fill(Color("FeedListItem"))
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color("AccentColor"), lineWidth: 2)
                            )
                    )
                    .frame(width: 15 * CGFloat(Int(commentsListItem.indent) ?? 0))
                Spacer()
            }
            // indent ends
            
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .center, spacing: 2) {
                    Text(commentsListItem.author)
                        .font(.system(.body))
                        .foregroundColor(.gray)
                        .onTapGesture {
                            print("author")
                            isShowingAuthor = true
                        }
                        .sheet(isPresented: $isShowingAuthor, content: {
                            AuthorView(farray: AuthorItem(card_name: "", card_nickname: "", short_info: "", karma: "", rating: ""), title: commentsListItem.author, link: commentsListItem.author_link)
                        })
                    Spacer()
                    
                    if str(s: commentsListItem.date) == true {
                        HStack {
                            Text(commentsListItem.date.replacingOccurrences(of: "Комментарий был изменен", with: ""))
                                .font(.system(.body))
                                .foregroundColor(.gray)
                            Image(systemName: "pencil")
                                .font(.title2)
                        }
                    } else {
                        Text(commentsListItem.date)
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    }
                }
                if (Int(commentsListItem.rate) ?? 0) < 0 {
                    //                    Text(commentsListItem.content)
                    //                        .multilineTextAlignment(.leading)
                    //                        .foregroundColor(.gray)
                    myAttrString(paragraph: commentsListItem.content)
                        .foregroundColor(.gray)
                } else {
                    //                    Text(commentsListItem.content)
                    //                        .multilineTextAlignment(.leading)
                    //                        .foregroundColor(Color("FeedListFont"))
                    myAttrString(paragraph: commentsListItem.content)
                        .foregroundColor(Color("FeedListFont"))
                }
                HStack(alignment: .center, spacing: 2) {
                    Image(systemName: "rhombus")
                        .font(.system(.body))
                        .foregroundColor(.gray)
                    if commentsListItem.rate == "0" {
                        Text(commentsListItem.rate)
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    }
                    if (Int(commentsListItem.rate) ?? 0) > 0 {
                        Text(commentsListItem.rate)
                            .foregroundColor(.green)
                    }
                    if (Int(commentsListItem.rate) ?? 0) < 0 {
                        Text(commentsListItem.rate)
                            .foregroundColor(.red)
                    }
                    Spacer()
                }
                Divider()
            }
        }
        .onTapGesture {
            // showingActionSheet = true
            withAnimation {
                toggleBottom = true
            }
        }
        .ignoresSafeArea(.container, edges: .bottom)
        //        .actionSheet(isPresented: $showingActionSheet) {
        //            ActionSheet(title: Text("Комментарий"), buttons: [
        //                .default(Text("html")) {  },
        //                .default(Text("Скопировать ссылку на комментарий")) { pasteboard.string = "https://m.habr.com" },
        //                .default(Text("Открыть комментарий в браузере")) { UIApplication.shared.open(URL(string: "https://m.habr.com")!) },
        //                .default(Text("Скопировать ссылку на автора")) {  },
        //                .default(Text("Открыть профиль автора в браузере")) {  },
        //                .cancel()
        //            ])
        //        }
    }
}

struct commentListItemView_Previews: PreviewProvider {
    static let cli: [ commentsItem ] = [ commentsItem(
        content: "content_",
        indent: "5",
        author: "author_",
        author_link: "author-link_",
        date: "11.12.2021 00:00_",
        link: "comment-link_",
        rate: "44"
    )]
    
    @State static var tb: Bool = false
    static var previews: some View {
        commentListItemView(commentsListItem: cli[0], toggleBottom: $tb)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
