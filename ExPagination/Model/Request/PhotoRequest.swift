//
//  PhotoRequest.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import Foundation

struct PhotoRequest: ModelType {
  let page: Int
  let perPage: Int = 30
  
  enum CodingKeys: String, CodingKey {
    case page
    case perPage = "per_page"
  }
}
