//
//  PhotoViewReactor.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import ReactorKit
import RxCocoa
import Differentiator
import Kingfisher

class PhotoViewReactor: Reactor {
  enum Action {
    case viewDidLoad
    case prefetchItems([PhotoSection.Item])
    case pagination(
      contentHeight: CGFloat,
      contentOffsetY: CGFloat,
      scrollViewHeight: CGFloat
    )
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
    case .prefetchItems(let items):
      var urls = [URL]()
      items.forEach {
        if case let .main(photo) = $0,
           let url = URL(string: photo.urlString) {
          urls.append(url)
        }
      }
      ImagePrefetcher(resources: urls).start() // <- 캐싱
      return .empty()
    case let .pagination(contentHeight, contentOffsetY, scrollViewHeight):
      let paddingSpace = contentHeight - contentOffsetY
      if paddingSpace < scrollViewHeight {
        return getPhotos()
      } else {
        return .empty()
      }
    }
  }
  
  private func getPhotos() -> Observable<Mutation> {
    self.currentPage += 1
    let photoRequest = PhotoRequest(page: currentPage)
    return self.provider.photoService.getPhotos(photoRequest: photoRequest)
      .map { (photos: [Photo]) -> [PhotoSection.Item] in
        let photoSectionItem = photos.map(PhotoSection.Item.main)
        return photoSectionItem
      }
      .map(Mutation.updateDataSource)
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
