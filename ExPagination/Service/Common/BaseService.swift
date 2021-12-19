//
//  BaseService.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import Foundation

class BaseService {
  unowned let provider: ServiceProviderType
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
}
