//
//  QuickSearchTests.swift
//  SearchSampleTests
//
//  Created by 이숭인 on 12/29/24.
//  Copyright © 2024 SearchSample. All rights reserved.
//

import Foundation
import Nimble
import Quick
import Combine

final class QuickSearchTests: QuickSpec {
    override static func spec() {
        var cancellables = Set<AnyCancellable>()
        var sut: SearchedListViewModel!
        var mockRepository: MockSearchRepositoryImpl!
        
        beforeEach {
            mockRepository = MockSearchRepositoryImpl()
            
            let imageFetchUsecase = FetchImagesUsecaseImpl(imagesRepository: mockRepository)
            let videoFetchUsecase = FetchVideosUsecaseImpl(videosRepository: mockRepository)
            
            sut = SearchedListViewModel(
                imageFetchUsecase: imageFetchUsecase,
                videoFetchUsecase: videoFetchUsecase
            )
        }
        
        afterEach {
            sut = nil
            mockRepository = nil
        }
        
        describe("화면 로드") {
            it("검색목록을 불러온다") {
                sut.request(with: .loadImages(query: "dummy query"))

                expect(mockRepository.fetchImagesExpectation).to(beTrue()) // verify
            }
            
            context("검색 목록을 불러오는데 성공했다면") {
                context("아이템이 하나 이상이라면") {
                    beforeEach {
                        mockRepository.stubFetchImagesResult(
                            .success(
                                ImagesPage(
                                    totalCount: 0,
                                    totalPages: 0,
                                    isEnd: false,
                                    images: [
                                        Image(id: "", thumbnailURL: "", imageURL: "", date: "")
                                    ]
                                )
                            )
                        )
                    }
                    
                    it("화면에 검색 결과를 표시한다") {
                        var isFetched = false
                        sut.request(with: .loadImages(query: "dummy query"))
                        sut.searchedImageValues
                            .sink { images in
                                isFetched = true
                            }
                            .store(in: &cancellables)
                        
                        expect(isFetched).to(beTrue())
                    }
                }
                
                context("아이템이 존재하지 않는다면") {
                    beforeEach {
                        mockRepository.stubFetchImagesResult(
                            .success(
                                ImagesPage(
                                    totalCount: 0,
                                    totalPages: 0,
                                    isEnd: false,
                                    images: []
                                )
                            )
                        )
                    }
                    
                    it("빈 화면을 표시한다") {
                        var results: [Image] = []
                        
                        sut.request(with: .loadImages(query: "dummy query"))
                        sut.searchedImageValues
                            .sink { images in
                                results = images
                            }
                            .store(in: &cancellables)
                     
                        expect(results.count).toEventually(equal(0))
                    }
                }
            }
            
            context("검색 목록을 불러오는데 실패했다면") {
                beforeEach {
                    mockRepository.stubFetchImagesResult(.failure(MockError.fetchFailed))
                }
                
                it("에러메세지를 표시한다") {
                    var isErrorOccured = false
                    
                    sut.request(with: .loadImages(query: "dummy query"))
                    sut.errorPublisher
                        .sink { error in
                            isErrorOccured = true
                        }
                        .store(in: &cancellables)
                    
                    expect(isErrorOccured).toEventually(beTrue())
                }
            }
        }
    }
}

//TODO: 검증을 Presenter로 대체. Stub 기능을 넣고싶은데 이건 어찌할지 내일 피티랑 이애ㅑ기해보자
