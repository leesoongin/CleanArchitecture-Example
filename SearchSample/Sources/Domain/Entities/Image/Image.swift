//
//  Image.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation

struct Image: Identifiable {
    let id: String
    let thumbnailURL: String
    let imageURL: String
    let date: String
}

struct Video: Identifiable {
    let id: String
    let title: String
    let thumbnailURL: String
    let url: String
    let date: String
}
