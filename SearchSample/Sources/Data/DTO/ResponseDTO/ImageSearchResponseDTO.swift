//
//  ImageSearchResponseDTO.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation

import Foundation

struct ImageSearchResponseDTO: Codable {
    let meta: Meta
    let documents: [Document]
    
    func toDomain() -> ImagesPage {
        ImagesPage(
            totalCount: meta.totalCount,
            totalPages: meta.pageableCount,
            isEnd: meta.isEnd,
            images: documents.map { 
                Image(
                    id: UUID().uuidString,
                    thumbnailURL: $0.thumbnailUrl,
                    imageURL: $0.imageUrl,
                    date: $0.datetime
                )
            }
        )
    }
}

struct Meta: Codable {
    let totalCount: Int
    let pageableCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case pageableCount = "pageable_count"
        case isEnd = "is_end"
    }
}

struct Document: Codable {
    let collection: String
    let thumbnailUrl: String
    let imageUrl: String
    let width: Int
    let height: Int
    let displaySitename: String
    let docUrl: String
    let datetime: String

    enum CodingKeys: String, CodingKey {
        case collection
        case thumbnailUrl = "thumbnail_url"
        case imageUrl = "image_url"
        case width
        case height
        case displaySitename = "display_sitename"
        case docUrl = "doc_url"
        case datetime
    }
}
