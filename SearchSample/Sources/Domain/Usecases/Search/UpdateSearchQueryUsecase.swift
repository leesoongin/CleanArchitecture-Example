//
//  UpdateSearchQueryUsecase.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/24/24.
//

import Foundation

protocol UpdateSearchQueryUsecase {
    func initializeQuery(
        keyword: String,
        page: Int,
        size: Int,
        sort: SearchQuery.Sort
    ) -> SearchQuery
    
    func updatePageOfQuery(
        query: SearchQuery
    ) -> SearchQuery
    
    func updateKeywordOfQuery(
        query: SearchQuery,
        with keyword: String
    ) -> SearchQuery
    
    func updateSortOfQuery(
        query: SearchQuery,
        with sort: SearchQuery.Sort
    ) -> SearchQuery
}

struct UpdateSearchQueryUsecaseImpl: UpdateSearchQueryUsecase {
    func initializeQuery(
        keyword: String,
        page: Int,
        size: Int,
        sort: SearchQuery.Sort
    ) -> SearchQuery {
        SearchQuery(
            query: keyword,
            page: page,
            size: size,
            sort: sort
        )
    }
    
    func updatePageOfQuery(query: SearchQuery) -> SearchQuery {
        var newQuery = query
        newQuery.updatePage()
        
        return newQuery
    }
    
    func updateKeywordOfQuery(query: SearchQuery, with keyword: String) -> SearchQuery {
        var newQuery = query
        newQuery.updateQuery(with: keyword)
        
        return newQuery
    }
    
    func updateSortOfQuery(query: SearchQuery, with sort: SearchQuery.Sort) -> SearchQuery {
        var newQuery = query
        newQuery.updateSort(sort: sort)
        
        return newQuery
    }
}
