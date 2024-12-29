import Foundation
import Combine
import XCTest

@testable import SearchSample

final class SearchTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    private var sut: SearchedListViewModel!
    private var mockRepository: MockSearchRepositoryImpl!
    
    override func setUpWithError() throws {
        createSut()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
    }
    
    private func createSut() {
        mockRepository = MockSearchRepositoryImpl()
        
        let imageFetchUsecase: FetchImagesUsecase = FetchImagesUsecaseImpl(imagesRepository: mockRepository)
        let videoFetchUsecase: FetchVideosUsecase = FetchVideosUsecaseImpl(videosRepository: mockRepository)
        
        sut = SearchedListViewModel(
            imageFetchUsecase: imageFetchUsecase,
            videoFetchUsecase: videoFetchUsecase
        )
    }
    
    /*
        화면이 로드됨 -> describe
        검색목록을 불러옴 -> describe
     
        목록을 가져오는데 성공한다면 -> when
        아이탬이 하나 이상이라면 -> when
        화면에 결과를 표시한다. -> Then
        아이탬이 없다면 -> When
        결과없음 화면을 표시한다 -> Then
     
        목록을 가져오는데 실패한다면 -> when
        실패 에러메세지를 도출해낸다 -> Then
     **/
    
    func test_이미지검색_성공적으로_목록을_불러온다() {
        // Given
        let expectation = XCTestExpectation(description: "success_fetch_image")
        let mockImages: [Image] = [
            Image(
                id: "",
                thumbnailURL: "",
                imageURL: "",
                date: ""
            ),
            Image(
                id: "",
                thumbnailURL: "",
                imageURL: "",
                date: ""
            )
        ]
        
        mockRepository.stubFetchImagesResult(
            .success(
                ImagesPage(
                    totalCount: 0,
                    totalPages: 0,
                    isEnd: false,
                    images: mockImages
                )
            )
        )
        
        sut.sectionItems
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When: 이미지 검색 결과를 호출한다.
        sut.request(with: .loadImages(query: "dummy query"))
        
        
        // Then: 결과를 표시한다.
        wait(for: [expectation], timeout: 2)
        
        XCTAssertTrue(mockRepository.fetchImagesExpectation, "Expected fetchImages to be called")
        if let result = mockRepository.stubbedFetchImagesResult {
            switch result {
            case .success:
                print("fetchImagesResult is success")
            case .failure:
                print("fetchImagesResult is failure")
            }
        } else {
            XCTFail("No stubbed result set for fetchImages")
        }
    }
    
    func test_이미지검색_목록불러오기_실패() {
        // Given
        let expectation = XCTestExpectation(description: "fail_fetch_image")
        mockRepository.stubFetchImagesResult(.failure(MockError.fetchFailed))
        
        sut.errorPublisher
            .sink { error in
                XCTAssertEqual(error as! MockError, MockError.fetchFailed)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        sut.request(with: .loadImages(query: "dummy query"))
        
        // Then
        wait(for: [expectation], timeout: 2)
    }
}

