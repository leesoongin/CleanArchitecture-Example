//
//  ImageSearchRequestDTO.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import Foundation

public struct SearchRequestDTO: Encodable {
    let query: String
    let page: Int
    let size: Int
    let sort: Sort
    
    enum CodingKeys: String, CodingKey {
        case query
        case page
        case size
        case sort
    }
    
    public enum Sort: String {
        case accuracy // 정확도순
        case recency // 최신순
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(query, forKey: .query)
        try container.encode(page, forKey: .page)
        try container.encode(size, forKey: .size)
        try container.encode(sort.rawValue, forKey: .sort)
    }
}

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any]? {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
        return jsonObject as? [String: Any]
    }
}
