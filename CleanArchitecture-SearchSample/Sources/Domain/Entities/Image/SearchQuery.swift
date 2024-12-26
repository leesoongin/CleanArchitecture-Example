//
//  SearchQuery.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/23/24.
//

import Foundation

struct SearchQuery {
    var query: String
    var page: Int
    var size: Int
    var sort: Sort
    
    enum Sort {
        case accuracy // 정확도순
        case recency // 최신순
    }
    
    mutating func updateQuery(with keyword: String) {
        self.query = keyword
    }
    
    mutating func updatePage() {
        self.page = page + 1
    }
    
    mutating func updateSort(sort: Sort) {
        self.sort = sort
    }
}
