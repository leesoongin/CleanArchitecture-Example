//
//  VideoSearchResponseDTO.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/24/24.
//

import Foundation
import Foundation

struct VideoSearchResponseDTO: Codable {
    let meta: Meta
    let documents: [Document]
    
    func toDomain() -> VideosPage {
        VideosPage(
            totalCount: meta.totalCount,
            totalPages: meta.pageableCount,
            isEnd: meta.isEnd,
            videos: documents.map {
                Video(
                    id: UUID().uuidString,
                    title: $0.title,
                    thumbnailURL: $0.thumbnail,
                    url: $0.url,
                    date: $0.datetime
                )
            }
        )
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
        let title: String         // 동영상 제목
        let url: String           // 동영상 링크
        let datetime: String        // 동영상 등록일, ISO 8601
        let playTime: Int         // 동영상 재생시간, 초 단위
        let thumbnail: String     // 동영상 미리보기 URL
        let author: String        // 동영상 업로더

        enum CodingKeys: String, CodingKey {
            case title
            case url
            case datetime
            case playTime = "play_time"
            case thumbnail
            case author
        }
    }
}
