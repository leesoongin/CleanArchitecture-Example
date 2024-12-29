//
//  SearchedListViewModel.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/23/24.
//

import Foundation
import Combine

//MARK: Constants
extension SearchedListViewModel {
    enum Constants {
        // about Query
        static let defaultKeyword: String = ""
        static let defaultPage: Int = 1
        static let defaultSize: Int = 30
        static let defaultSort: SearchQuery.Sort = .accuracy
        
        static let loadMoreValidateTrigger: String = "indicator_component"
    }
}

final class SearchedListViewModel {
    private var cancellables = Set<AnyCancellable>()
    
    let imageFetchUsecase: FetchImagesUsecase
    let videoFetchUsecase: FetchVideosUsecase
    
    @Published var isEnd: Bool = true
    
    init(
        imageFetchUsecase: FetchImagesUsecase,
        videoFetchUsecase: FetchVideosUsecase
    ) {
        self.imageFetchUsecase = imageFetchUsecase
        self.videoFetchUsecase = videoFetchUsecase
        
        bind()
    }
    
    let searchedImageValues = CurrentValueSubject<[Image], Never>([])
    let searchedVideoValues = CurrentValueSubject<[Video], Never>([])
    let sectionSubject = CurrentValueSubject<[SectionModelType], Never>([])
    let errorSubject = PassthroughSubject<Error, Never>()
    
    func bind() {
        imageFetchUsecase.imagesPublisher
            .sink { [weak self] images in
                self?.present(with: .imageList(images: images))
            }
            .store(in: &cancellables)
        
        imageFetchUsecase.isEndPublisher
            .assign(to: &$isEnd)
        
        imageFetchUsecase.errorPublisher
            .sink { [weak self] error in
                self?.present(with: .error(error: error))
            }
            .store(in: &cancellables)
        
        
        videoFetchUsecase.videosPublisher
            .sink { [weak self] videos in
                self?.present(with: .videoList(videos: videos))
            }
            .store(in: &cancellables)
        
        videoFetchUsecase.isEndPublisher
            .assign(to: &$isEnd)
    }
}
