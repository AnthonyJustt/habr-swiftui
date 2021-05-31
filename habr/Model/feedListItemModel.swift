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
