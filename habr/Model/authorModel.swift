//
//  AuthorModel.swift
//  habr
//
//  Created by Anton Krivonozhenkov on 01.05.2021.
//

import SwiftUI

struct AuthorItem: Identifiable {
    var id = UUID()
    var card_name: String // имя
    var card_nickname: String // логин
    var short_info: String // пользователь или системный аналитик
    var karma: String
    var rating: String 
}
