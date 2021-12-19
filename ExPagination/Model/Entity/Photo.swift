//
//  Photo.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

struct Photo: ModelType {
  let id: Int
  let title, welcomeDescription: String
  let totalPhotos: Int
  let coverPhoto: CoverPhoto
  var urlString: String {
    return coverPhoto.urls.regular
  }
  
  enum CodingKeys: String, CodingKey {
    case id, title
    case welcomeDescription = "description"
    case totalPhotos = "total_photos"
    case coverPhoto = "cover_photo"
  }
  
  struct CoverPhoto: Codable {
    let id: String
    let width, height: Int
    let likes: Int
    let likedByUser: Bool
    let coverPhotoDescription: String
    let urls: Urls
    
    enum CodingKeys: String, CodingKey {
      case id, width, height
      case likes
      case likedByUser = "liked_by_user"
      case coverPhotoDescription = "description"
      case urls
    }
    
    struct Urls: Codable {
      let raw, full, regular, small: String
      let thumb: String
    }
  }
}

extension Photo: Equatable {
  static func == (lhs: Photo, rhs: Photo) -> Bool {
    lhs.id == rhs.id
  }
}
