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
}

extension SearchedListViewModel: SearchedListPresentable {
    var sectionItems: AnyPublisher<[SectionModelType], Never> {
        sectionSubject.eraseToAnyPublisher()
    }
}
