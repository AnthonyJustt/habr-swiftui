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
    
    @State var toggleBottom: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
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
                    HStack(spacing:0) {
                        Text(LocalizedStringKey("Comments.Comments"))
                        Text("\(numberOfComments)")
                    }
                    .padding()
                } else {
                    Text(LocalizedStringKey("Comments.NoComments"))
                        .padding()
                }
                ForEach(farray, id: \.id) {
                    item in
                    commentListItemView(commentsListItem: item, toggleBottom: $toggleBottom)
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
            
            .overlay(
                //  Rectangle()
                //      .fill(.gray)
                blurView()
                    .opacity(toggleBottom ? 1 : 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation{
                            toggleBottom.toggle()
                        }
                    }
            )
            
            .overlay(
                bottomSheet(), alignment: .bottom
            )
            .ignoresSafeArea(.container, edges: .bottom)
            
            .overlay(
                ZStack {
                    
                    blurView(cornerRadius: 25)
                        .frame(width: 50, height: 50)
                    
                    //    Button(action: {
                    //        presentationMode.wrappedValue.dismiss()
                    //    }) {
                    Image(systemName: "xmark")
                    //    }
                    
                }
                    .padding(.top, 15)
                    .padding(.trailing, 15)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                , alignment: .topTrailing
            )
            
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
    
    @ViewBuilder
    func bottomSheet() -> some View {
        VStack {
            Text("Comment Actions")
                .foregroundColor(Color("FeedListFont"))
                .padding()
                .onTapGesture {
                    withAnimation {
                        toggleBottom.toggle()
                    }
                }
            Text("html")
            Text("Скопировать ссылку на комментарий")
            Text("Открыть комментарий в браузере")
            Text("Скопировать ссылку на автора")
            Text("Открыть профиль автора в браузере")
        }
        .frame(maxWidth: .infinity)
        .frame(height: 350, alignment: .top)
        .background(
            Color("FeedListItem")
                .clipShape(RoundedRectangle(cornerRadius: 35))
        )
        .offset(y: toggleBottom ? 0 : 350)
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
