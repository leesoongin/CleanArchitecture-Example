//
//  ImageListViewModel+Presentable.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/23/24.
//

import Foundation
import Combine

protocol SearchedListPresentable {
    var sectionItems: AnyPublisher<[SectionModelType], Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func present(with response: SearchedListViewModel.Response)
}

extension SearchedListViewModel {
    enum Response {
        case imageList(images: [Image])
        case videoList(videos: [Video])
        
        case error(error: Error)
    }
}

extension SearchedListViewModel: SearchedListPresentable {
    var sectionItems: AnyPublisher<[SectionModelType], Never> {
        sectionSubject.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    func present(with response: Response) {
        switch response {
        case .imageList(let images):
            let sections = createImageSections(
                with: images,
                isEnd: self.isEnd
            )
            
            sectionSubject.send(sections)
        case .videoList(let videos):
            let sections = createVideoSections(
                with: videos,
                isEnd: self.isEnd
            )
            
            sectionSubject.send(sections)
        case .error(let error):
            errorSubject.send(error)
        }
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

