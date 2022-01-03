//
//  FeedListItemModel.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 29.03.2021.
//

import SwiftUI

struct FeedListItem: Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var author_link: String
    var date: String
    var rate: String
    var rate_detail: String
    var view: String
    var bookmark: String
    var comments: String
    var link: String
    var article_snippet: String
    var offset: CGFloat
    var isSwiped: Bool
}

//class FeedListItemContainer: ObservableObject{
//    @Published var users = [FeedListItem]()
//}

//class FeedListItem: ObservableObject, Identifiable {
//     var id = UUID()
//     var title: String
//     var author: String
//     var author_link: String
//     var date: String
//     var rate: String
//     var rate_detail: String
//     var view: String
//     var bookmark: String
//      var comments: String
//     var link: String
//     var article_snippet: String
//     var offset: CGFloat
//     var isSwiped: Bool
//
//    init(title: String, author: String, author_link: String, date: String, rate: String, rate_detail: String, view: String, bookmark: String, comments: String, link: String, article_snippet: String, offset: CGFloat, isSwiped: Bool) {
//        self.title = title
//         self.author = author
//         self.author_link = author_link
//         self.date = date
//         self.rate = rate
//         self.rate_detail = rate_detail
//         self.view = view
//         self.bookmark = bookmark
//         self.comments = comments
//         self.link = link
//         self.article_snippet = article_snippet
//         self.offset = offset
//         self.isSwiped = isSwiped
//    }
//}
