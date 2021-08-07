//
//  CommentsView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 07.04.2021.
//

import SwiftUI

struct CommentsView: View {
    @State var farray: [commentsItem]
    var title: String
    var link: String
    @State private var numberOfComments: String = ""
    @State var isHidden: Bool = true
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(.system(.title2))
                        .foregroundColor(Color("FeedListFont"))
                        .fontWeight(.bold)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                        .padding()
                    Divider()
                        .padding(.horizontal)
                }
                
                if numberOfComments != "0" {
                    Text("Комментарии - \(numberOfComments)")
                        .padding()
                } else {
                    Text("Комментариев нет")
                        .padding()
                }
                ForEach(farray, id: \.id) {
                    item in
                    commentListItemView(commentsListItem: item)
                        .padding(.horizontal)
                }
                if farray.count == 0 {
                    EmptyPlaceholderView(imageName: "NoComments", rendering: false)
                }
                Text("https://m.habr.com\(link)comments/")
                    .font(.footnote)
                    .padding()
            }
            .opacity(isHidden ? 0 : 1)
            
            ProgressView()
                .opacity(isHidden ? 1 : 0)
                .progressViewStyle(CircularProgressViewStyle())
                .onAppear(perform: {
                    DispatchQueue.global(qos: .userInitiated).async {
                        print("https://m.habr.com\(link)comments/")
                        (numberOfComments, farray) = fparseComments(fhtml: fname(furl: "https://m.habr.com\(link)comments/"))
                        isHidden.toggle()
                    }
                })
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(farray: [commentsItem(
            content: "content_",
            indent: "content_",
            author: "content_",
            author_link: "content_",
            date: "content_",
            link: "content_",
            rate: "content_"
        )], title: "title_", link: "link_")
    }
}
