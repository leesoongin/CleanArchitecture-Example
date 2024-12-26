//
//  FetchImagesUsecase.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation
import Combine

protocol FetchImagesUsecase {
    var imagesPublisher: Published<[Image]>.Publisher { get }
    var isEndPublisher: Published<Bool>.Publisher { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func fetchInitialImages(
        query: String,
        page: Int,
        size: Int,
        sort: SearchQuery.Sort
    )
    func fetchMoreImages()
}

final class FetchImagesUsecaseImpl: FetchImagesUsecase {
    private let imagesRepository: SearchRepository
    private var currentQuery: SearchQuery?

    @Published private(set) var images: [Image] = []
    @Published private(set) var isEnd: Bool = true

    var imagesPublisher: Published<[Image]>.Publisher { $images }
    var isEndPublisher: Published<Bool>.Publisher { $isEnd }
    
    private let errorSubject = PassthroughSubject<Error, Never>()
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private var imageFetchTask: Task<Void, Never>?

    init(imagesRepository: SearchRepository) {
        self.imagesRepository = imagesRepository
    }

    func fetchInitialImages(
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

        images = [] // 초기화
        isEnd = true // 초기값 설정

        fetchImages()
    }

    func fetchMoreImages() {
        guard let query = currentQuery, !isEnd else { return }

        currentQuery = SearchQuery(
            query: query.query,
            page: query.page + 1,
            size: query.size,
            sort: query.sort
        )

        fetchImages()
    }

    private func fetchImages() {
        guard let query = currentQuery else {
            return
        }
        imageFetchTask?.cancel()
        
        imageFetchTask = Task {
            do {
                let page = try await imagesRepository.fetchImages(with: query)
                images.append(contentsOf: page.images)
                isEnd = page.isEnd
            } catch {
                errorSubject.send(error)
            }
        }
    }
}
