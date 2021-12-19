//
//  ServiceProvider.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import RxSwift

protocol ServiceProviderType: AnyObject {
  var photoService: PhotoServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
  lazy var photoService: PhotoServiceType = PhotoService(provider: self)
}
