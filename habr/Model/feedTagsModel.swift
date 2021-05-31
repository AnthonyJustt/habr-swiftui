//
//  feedTagsModel.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 24.04.2021.
//

import SwiftUI

struct feedTagsItem: Identifiable {
    var id = UUID()
    var title: String
    var link: String
}
