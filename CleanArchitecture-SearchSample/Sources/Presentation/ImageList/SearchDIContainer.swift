//
//  SearchDIContainer.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/26/24.
//

import Foundation
import Swinject

public final class SearchDIContainer {
    private let container: Container

    public init(parentContainer: Container) {
        self.container = Container(parent: parentContainer)
        registerDependencies()
    }

    private func registerDependencies() {
        container.register(KakaoSearchRemoteDataSource.self) { resolver in
            KakaoSearchRemoteDataSourceImpl()
        }
        .inObjectScope(.graph)
        
        // Repository
        container.register(SearchRepository.self) { resolver in
            SearchRepositoryImpl(
                kakaoSearchDataSource: resolver.resolve(KakaoSearchRemoteDataSource.self)!)
        }
        .inObjectScope(.graph)

        // UseCase
        container.register(FetchImagesUsecase.self) { resolver in
            FetchImagesUsecaseImpl(
                imagesRepository: resolver.resolve(SearchRepository.self)!)
        }
        
        container.register(FetchVideosUsecase.self) { resolver in
            FetchVideosUsecaseImpl(
                videosRepository: resolver.resolve(SearchRepository.self)!)
        }

        // ViewModel
        container.register(SearchedListViewModel.self) { resolver in
            SearchedListViewModel(
                imageFetchUsecase: resolver.resolve(FetchImagesUsecase.self)!,
                videoFetchUsecase: resolver.resolve(FetchVideosUsecase.self)!)
        }
        .inObjectScope(.graph)

        // ViewController
        container.register(SearchedListViewController.self) { resolver in
            SearchedListViewController(
                presenter: resolver.resolve(SearchedListViewModel.self)!,
                interactor: resolver.resolve(SearchedListViewModel.self)!
            )
        }
    }

    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = container.resolve(serviceType) else {
            fatalError("Dependency not registered for type \(serviceType)")
        }
        return service
    }
}
