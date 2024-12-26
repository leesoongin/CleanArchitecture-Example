//
//  ImageListViewModel+Interactorable.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/23/24.
//

import Foundation

protocol SearchedListInteractorable {
    func request(with command: SearchedListViewModel.Command)
}

extension SearchedListViewModel {
    enum Command {
        case loadImages(query: String)
        case loadMoreImages(triggerID: String)
        
        case loadVideos(query: String)
        case loadMoreVideos(triggerID: String)
    }
}

extension SearchedListViewModel: SearchedListInteractorable {
    func request(with command: Command) {
        switch command {
        case .loadImages(let query):
            loadImages(query: query)
        case .loadMoreImages(let triggerID):
            guard triggerID == Constants.loadMoreValidateTrigger else {
                return
            }
            
            loadMoreImages()
        case .loadVideos(let query):
            loadVideos(query: query)
        case .loadMoreVideos(let triggerID):
            guard triggerID == Constants.loadMoreValidateTrigger else {
                return
            }
            
            loadMoreVideos()
        }
    }

    private func loadImages(query: String) {
        imageFetchUsecase.fetchInitialImages(
            query: query,
            page: Constants.defaultPage,
            size: Constants.defaultSize,
            sort: Constants.defaultSort
        )
    }
    
    private func loadMoreImages() {
        imageFetchUsecase.fetchMoreImages()
    }
    
    private func loadVideos(query: String) {
        videoFetchUsecase.fetchInitialVideos(
            query: query,
            page: Constants.defaultPage,
            size: Constants.defaultSize,
            sort: Constants.defaultSort
        )
    }
    
    private func loadMoreVideos() {
        videoFetchUsecase.fetchMoreVideos()
    }
}
