//
//  ImagesRepository.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/23/24.
//

import Foundation
import Combine

protocol SearchRepository {
    func fetchImages(with query: SearchQuery) async throws -> ImagesPage
    func fetchVideos(with query: SearchQuery) async throws -> VideosPage
}
