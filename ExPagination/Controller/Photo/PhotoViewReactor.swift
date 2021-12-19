//
//  PhotoViewReactor.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import ReactorKit
import RxCocoa

class PhotoViewReactor: Reactor {
  enum Action {
    case viewDidLoad
  }
  
  enum Mutation {
    case updateDataSource
  }
  
  struct State {
    var photoSection = PhotoSection.Model(
      model: 0,
      items: []
    )
  }
  
  var initialState = State()
  
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
      case .viewDidLoad:
      return Observable<Mutation>.just(.updateDataSource)
    }
  }
  
  func reduce(state: State, mutation: Mutation) -> State {
    var state = state
    switch mutation {
    case .updateDataSource:
      // TODO: API
      let newPhotos = [PhotoSection.Item]()
      state.photoSection.items.append(contentsOf: newPhotos)
    }
    return state
  }
}
