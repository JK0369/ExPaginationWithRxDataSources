//
//  PhotoSection.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import RxDataSources

struct PhotoSection {
  typealias Model = SectionModel<Int, Item>
  
  enum Item {
    case main(Photo)
  }
}

extension PhotoSection.Item: Equatable {
  
}
