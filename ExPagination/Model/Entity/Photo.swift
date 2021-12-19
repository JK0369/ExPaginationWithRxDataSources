//
//  Photo.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import Foundation

// MARK: - PhotoElement
struct Photo: Codable {
  let id: String
  let width, height: Int
  let likes: Int?
  let likedByUser: Bool?
  let photoDescription: String?
  let urls: Urls
  var urlString: String {
    urls.regular
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case width, height
    case likes
    case likedByUser = "liked_by_user"
    case photoDescription = "description"
    case urls
  }
  
  struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
  }
}

extension Photo: Equatable {
  static func == (lhs: Photo, rhs: Photo) -> Bool {
    lhs.id == rhs.id
  }
}
