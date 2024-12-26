//
//  ImagesPage.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation

struct ImagesPage {
    let totalCount: Int
    let totalPages: Int
    let isEnd: Bool
    let images: [Image]
}

struct VideosPage {
    let totalCount: Int
    let totalPages: Int
    let isEnd: Bool
    let videos: [Video]
}
