//
//  PhotoService.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import RxSwift

protocol PhotoServiceType {
  func getPhotos(photoRequest: PhotoRequest) -> Observable<[Photo]>
}

final class PhotoService: BaseService, PhotoServiceType {
  func getPhotos(photoRequest: PhotoRequest) -> Observable<[Photo]> {
    UnsplashAPI.getPhotos(photoRequest: photoRequest)
      .request()
      .map([Photo].self, using: UnsplashAPI.jsonDecoder)
      .do(onError: { print($0) })
      .asObservable()
  }
}
