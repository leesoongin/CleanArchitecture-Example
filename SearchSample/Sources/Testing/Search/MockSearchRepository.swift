//
//  StubSearchRepository.swift
//  SearchSample
//
//  Created by 이숭인 on 12/28/24.
//  Copyright © 2024 SearchSample. All rights reserved.
//

import Foundation
import Combine
import XCTest

// MARK: - Mock Repository
final class MockSearchRepositoryImpl: SearchRepository {
    var fetchImagesExpectation: Bool = false
    var fetchVideosExpectation: Bool = false

    var stubbedFetchImagesResult: Result<ImagesPage, Error>?
    var stubbedFetchVideosResult: Result<VideosPage, Error>?

    func stubFetchImagesResult(_ result: Result<ImagesPage, Error>) {
        fetchImagesExpectation = true
        stubbedFetchImagesResult = result
    }

    func stubFetchVideosResult(_ result: Result<VideosPage, Error>) {
        fetchVideosExpectation = true
        stubbedFetchVideosResult = result
    }

    func fetchImages(with query: SearchQuery) async throws -> ImagesPage {
        fetchImagesExpectation = true
        
        if let result = stubbedFetchImagesResult {
            switch result {
            case .success(let page):
                return page
            case .failure(let error):
                throw error
            }
        }
        throw MockError.stubNotSet
    }

    func fetchVideos(with query: SearchQuery) async throws -> VideosPage {
        fetchVideosExpectation = true
        
        if let result = stubbedFetchVideosResult {
            switch result {
            case .success(let page):
                return page
            case .failure(let error):
                throw error
            }
        }
        throw MockError.stubNotSet
    }
}

// MARK: - Mock Error
enum MockError: Error {
    case fetchFailed
    case stubNotSet
}
