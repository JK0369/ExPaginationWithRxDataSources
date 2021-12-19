//
//  UnsplashAPI+Path.swift
//  ExMoya
//
//  Created by Jake.K on 2021/12/11.
//

import Foundation

extension UnsplashAPI {
  func getPath() -> String {
    switch self {
    case .getPhotos:
      return "photos"
    }
  }
}
