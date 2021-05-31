//
//  FeedListItemModel.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 29.03.2021.
//

import SwiftUI

struct FeedNewsItem: Identifiable {
    var id = UUID()
    var title: String
    var date: String
    var comments: String
    var link: String
}
