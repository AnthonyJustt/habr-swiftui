//
//  commentsModel.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 25.04.2021.
//

import SwiftUI

struct commentsItem: Identifiable {
    var id = UUID()
    var content: String
    var indent: String
    var author: String
    var author_link: String
    var date: String
    var link: String
    var rate: String
}
