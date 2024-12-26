//
//  KakaoSearchRemoteDataSourceImpl.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation
import Combine
import Moya
import CombineMoya

final class KakaoSearchRemoteDataSourceImpl: KakaoSearchRemoteDataSource {
    private var cancellables = Set<AnyCancellable>()
    
    let provider = MoyaProvider<KakaoSearchAPI>(plugins: [
        NetworkLoggerPlugin(
            configuration: .init(
                logOptions: [
//                    .requestHeaders,
                    .requestBody,
                    .successResponseBody,
//                    .errorResponseBody
                ]
            )
        )
    ])
    
    func fetchImages(
        query: String,
        page: Int,
        size: Int,
        sort: SearchRequestDTO.Sort
    ) -> AnyPublisher<ImagesPage, Error> {
        Deferred {
            Future<ImagesPage, Error> { [weak self] promise in
                guard let self else { return }
                self.provider.requestPublisher(
                    .fetchImages(
                        request: SearchRequestDTO(
                            query: query,
                            page: page,
                            size: size,
                            sort: sort
                        )
                    )
                )
                .tryMap { response in
                    return try response.map(ImageSearchResponseDTO.self)
                }
                .map { $0.toDomain() }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }, receiveValue: { response in
                    promise(.success(response))
                })
                .store(in: &self.cancellables)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func fetchVideos(
        query: String,
        page: Int,
        size: Int,
        sort: SearchRequestDTO.Sort
    ) -> AnyPublisher<VideosPage, Error> {
        Deferred {
            Future<VideosPage, Error> { [weak self] promise in
                guard let self else { return }
                provider.requestPublisher(
                    .fetchVideos(
                        request: SearchRequestDTO(
                            query: query,
                            page: page,
                            size: size,
                            sort: sort
                        )
                    )
                )
                .tryMap { response in
                    return try response.map(VideoSearchResponseDTO.self)
                }
                .map { $0.toDomain() }
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let failure):
                        promise(.failure(failure))
                    }
                }, receiveValue: { response in
                    promise(.success(response))
                })
                .store(in: &self.cancellables)
            }
        }
        .eraseToAnyPublisher()
        
    }
}
