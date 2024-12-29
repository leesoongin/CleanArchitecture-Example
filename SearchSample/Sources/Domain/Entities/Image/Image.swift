//
//  Image.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation

public struct Image: Identifiable {
    public let id: String
    let thumbnailURL: String
    let imageURL: String
    let date: String
}

public struct Video: Identifiable {
    public let id: String
    let title: String
    let thumbnailURL: String
    let url: String
    let date: String
}
