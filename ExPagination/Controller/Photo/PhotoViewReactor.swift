//
//  PhotoViewReactor.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import ReactorKit
import RxCocoa
import Differentiator

class PhotoViewReactor: Reactor {
  enum Action {
    case viewDidLoad
  }
  
  enum Mutation {
    case updateDataSource([PhotoSection.Item])
  }
  
  struct State {
    var photoSection = PhotoSection.Model(
      model: 0,
      items: []
    )
  }
  
  let provider: ServiceProviderType
  var currentPage = 0
  var initialState = State()
  
  init(provider: ServiceProviderType) {
    self.provider = provider
  }
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .viewDidLoad:
      currentPage += 1
      let photoRequest = PhotoRequest(page: currentPage)
      return self.provider.photoService.getPhotos(photoRequest: photoRequest)
        .map { (photos: [Photo]) -> [PhotoSection.Item] in
          let photoSectionItem = photos.map(PhotoSection.Item.main)
          return photoSectionItem
        }
        .map(Mutation.updateDataSource)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .updateDataSource(let sectionItem):
      state.photoSection.items.append(contentsOf: sectionItem)
    }
    return state
  }
}
