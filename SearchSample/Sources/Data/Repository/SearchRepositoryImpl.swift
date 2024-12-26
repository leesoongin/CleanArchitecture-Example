//
//  SearchRepositoryImpl.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation
import Combine

final class SearchRepositoryImpl: SearchRepository {
    private var cancellables = Set<AnyCancellable>()
    
    private let kakaoSearchDataSource: KakaoSearchRemoteDataSource
    
    init(
        kakaoSearchDataSource: KakaoSearchRemoteDataSource
    ) {
        self.kakaoSearchDataSource = kakaoSearchDataSource
    }
    
    func fetchImages(with query: SearchQuery) async throws -> ImagesPage {
        try await withCheckedThrowingContinuation { continuation in
            let sort: SearchRequestDTO.Sort = {
                switch query.sort {
                case .accuracy:
                    return .accuracy
                case .recency:
                    return .recency
                }
            }()
            
            kakaoSearchDataSource.fetchImages(
                query: query.query,
                page: query.page,
                size: query.size,
                sort: sort
            )
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            } receiveValue: { response in
                continuation.resume(returning: response)
            }
            .store(in: &cancellables)
        }
    }
    
    func fetchVideos(with query: SearchQuery) async throws -> VideosPage {
        try await withCheckedThrowingContinuation { continuation in
            let sort: SearchRequestDTO.Sort = {
                switch query.sort {
                case .accuracy:
                    return .accuracy
                case .recency:
                    return .recency
                }
            }()
            
            kakaoSearchDataSource.fetchVideos(
                query: query.query,
                page: query.page,
                size: query.size,
                sort: sort
            )
            .sink { completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            } receiveValue: { response in
                continuation.resume(returning: response)
            }
            .store(in: &cancellables)
        }
    }
}
