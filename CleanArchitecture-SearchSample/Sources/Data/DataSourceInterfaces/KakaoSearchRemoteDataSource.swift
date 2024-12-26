//
//  KakaoSearchRemoteDataSource.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation
import Combine

protocol KakaoSearchRemoteDataSource {
    func fetchImages(
        query: String,
        page: Int,
        size: Int,
        sort: SearchRequestDTO.Sort
    ) -> AnyPublisher<ImagesPage, Error>
    
    func fetchVideos(
        query: String,
        page: Int,
        size: Int,
        sort: SearchRequestDTO.Sort
    ) -> AnyPublisher<VideosPage, Error>
}
