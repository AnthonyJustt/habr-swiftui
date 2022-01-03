//
//  EmbedNewsView.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 29.03.2021.
//

import SwiftUI

struct EmbedNewsView: View {
    
    @Binding var farrayNews: [FeedNewsItem]
//    = [FeedNewsItem(title: "Заголовок_", date: "00:00_", comments: "Комментарии: 12 +10", link: "")]
    
    @Binding var tabSelection: Int
    
    var body: some View {
        TabView {
            ForEach(farrayNews) { item in
                NavigationLink (destination: FeedDetailView(title: item.title, link: item.link, comments: item.comments.replacingOccurrences(of: "Комментарии: ", with: ""))) {
                    VStack {
                        HStack {
                            Text(item.title)
                                .font(.system(.title2))
                                .foregroundColor(Color("FeedListFont"))
                                .fontWeight(.bold)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading)
                        }
                        .padding()
                        HStack {
                            Text(item.date)
                            Text(" • ")
                            Text(item.comments)
                        }
                        .foregroundColor(.gray)
                        Spacer()
                    }
                }
                
            }
                VStack {
                    HStack {
                        Text(LocalizedStringKey("EmbedNew.MoreNews"))
                        Image(systemName: "arrow.right.circle")
                        
                    }
                    Text("")
                }
                .onTapGesture(perform: {
                    self.tabSelection = 3
                })
                .foregroundColor(Color("FeedListFont"))
                .font(.system(.title2))
        }
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color("AccentColor"), lineWidth: 2))
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

//struct EmbedNewsView_Previews: PreviewProvider {
//    @State static var previewTabSelection = 3
//    static var previews: some View {
//        EmbedNewsView(tabSelection: $previewTabSelection)
//            .previewLayout(.fixed(width: 400, height: 200))
//            .padding()
//    }
//}
