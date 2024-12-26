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
    
    @Published private var isEnd: Bool = true
    
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
    
    func bind() {
        imageFetchUsecase.imagesPublisher
            .compactMap { [weak self] images -> [SectionModelType]? in
                self?.searchedImageValues.value = images
                
                return self?.createImageSections(
                    with: images,
                    isEnd: self?.isEnd ?? true
                )
            }
            .sink { [weak self] sections in
                self?.sectionSubject.send(sections)
            }
            .store(in: &cancellables)
        
        imageFetchUsecase.isEndPublisher
            .assign(to: &$isEnd)
        
        videoFetchUsecase.videosPublisher
            .compactMap { [weak self] videos -> [SectionModelType]? in
                self?.searchedVideoValues.value = videos
                
                return self?.createVideoSections(
                    with: videos,
                    isEnd: self?.isEnd ?? false
                )
            }
            .sink { [weak self] sections in
                self?.sectionSubject.send(sections)
            }
            .store(in: &cancellables)
        
        videoFetchUsecase.isEndPublisher
            .assign(to: &$isEnd)
    }
}

//MARK: - Domain To SectionModel
extension SearchedListViewModel {
    func createImageSections(
        with images: [Image],
        isEnd: Bool
    ) -> [SectionModelType] {
        let components = images.map {
            ImageComponent(
                identifier: $0.id,
                thumbnailURL: $0.thumbnailURL
            )
        }
        
        let indicatorComponent = CommonIndicatorComponent(
            identifier: "indicator_component",
            isLast: false
        )
        
        let section = SectionModel(
            identifier: "image_section",
            itemModels: components + [indicatorComponent]
        )
        
        return [section]
    }
    
    func createVideoSections(
        with videos: [Video],
        isEnd: Bool
    ) -> [SectionModelType] {
        let components = videos.map {
            VideoComponent(
                identifier: $0.id,
                thumbnailURL: $0.thumbnailURL
            )
        }
        
        let indicatorComponent = CommonIndicatorComponent(
            identifier: "indicator_component",
            isLast: isEnd
        )
        
        let section = SectionModel(
            identifier: "video_section",
            itemModels: components + [indicatorComponent]
        )
        
        return [section]
    }
}
