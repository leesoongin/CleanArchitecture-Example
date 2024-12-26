//
//  FetchVideosUsecaseImpl.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/24/24.
//

import Foundation
import Combine

enum VideoSearchError: Error { 
    case notFound
}

protocol FetchVideosUsecase {
    var videosPublisher: Published<[Video]>.Publisher { get }
    var isEndPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func fetchInitialVideos(
        query: String,
        page: Int,
        size: Int,
        sort: SearchQuery.Sort
    )
    func fetchMoreVideos()
}

final class FetchVideosUsecaseImpl: FetchVideosUsecase {
    private let videosRepository: SearchRepository
    private var currentQuery: SearchQuery?

    @Published private(set) var videos: [Video] = []
    @Published private(set) var isEnd: Bool = true

    var videosPublisher: Published<[Video]>.Publisher { $videos }
    var isEndPublisher: Published<Bool>.Publisher { $isEnd }
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private var videoFetchTask: Task<Void, Never>?

    init(videosRepository: SearchRepository) {
        self.videosRepository = videosRepository
    }

    func fetchInitialVideos(
        query: String,
        page: Int,
        size: Int,
        sort: SearchQuery.Sort
    ) {
        currentQuery = SearchQuery(
            query: query,
            page: page,
            size: size,
            sort: sort
        )

        videos = [] // 초기화
        isEnd = true // 초기값 설정

        fetchVideos()
    }

    func fetchMoreVideos() {
        guard let query = currentQuery, !isEnd else { return }

        currentQuery = SearchQuery(
            query: query.query,
            page: query.page + 1,
            size: query.size,
            sort: query.sort
        )

        fetchVideos()
    }

    private func fetchVideos() {
        guard let query = currentQuery else {
            return
        }
        
        videoFetchTask?.cancel()
        
        self.videoFetchTask = Task {
            do {
                let page = try await videosRepository.fetchVideos(with: query)
                videos.append(contentsOf: page.videos)
                isEnd = page.isEnd
            } catch {
                errorSubject.send(error)
            }
        }
    }
}
