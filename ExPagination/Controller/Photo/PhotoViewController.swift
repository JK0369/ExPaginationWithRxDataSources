//
//  PhotoViewController.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import UIKit
import Then
import ReactorKit
import RxSwift
import RxCocoa
import Reusable
import RxDataSources
import SnapKit

class PhotoViewController: BaseViewController, ReactorKit.View {
  // MARK: Constants
  private enum Metric {
    private static let numberOfColumns = 3.0
    private static let numberOfRows = 7.0
    static let collectionViewItemSize = CGSize(
      width: (
        UIScreen.main.bounds.width
        - collectionViewSpacing
        * (numberOfColumns + 1)
        - Self.collectionViewSpacing
      ) / numberOfColumns,
      height: (
        UIScreen.main.bounds.height
        - collectionViewSpacing
        * (numberOfRows + 1)
        - Self.collectionViewSpacing
      ) / numberOfRows
    )
    static let collectionViewSpacing = 4.0
    static let collectionViewContentInset: UIEdgeInsets = UIEdgeInsets(
      top: 4,
      left: 4,
      bottom: 4,
      right: 4
    )
    static let collectionViewVerticalSpacing = UIScreen.main.bounds.height / 3
  }
  
  private enum Color {
    static let clear = UIColor.clear
  }
  
  // MARK: UI
  private let photoCollectionView = UICollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout().then {
      $0.itemSize = Metric.collectionViewItemSize
      $0.minimumLineSpacing = Metric.collectionViewSpacing
      $0.minimumInteritemSpacing = Metric.collectionViewSpacing
      $0.scrollDirection = .vertical
    }
  ).then {
    $0.register(cellType: PhotoCell.self)
    $0.contentInset = Metric.collectionViewContentInset
    $0.showsHorizontalScrollIndicator = false
    $0.allowsSelection = true
    $0.isScrollEnabled = true
    $0.bounces = true
    $0.backgroundColor = Color.clear
    $0.isPagingEnabled = true
  }
  
  override func configureLayout() {
    self.view.addSubview(photoCollectionView)
    self.photoCollectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  required init(reactor: PhotoViewReactor) {
    defer { self.reactor = reactor }
    super.init()
  }
  
  func bind(reactor: PhotoViewReactor) {
    // Action
    self.rx.viewDidLoad
      .map { Reactor.Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    // State
    let dataSource = RxCollectionViewSectionedReloadDataSource<PhotoSection.Model> { _, collectionView, indexPath, item in
      switch item {
      case .main(let photo):
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PhotoCell
        cell.setImage(urlString: photo.urlString)
        return cell
      }
    }
    
    self.photoCollectionView.rx.prefetchItems
      .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
      .observe(on: MainScheduler.asyncInstance)
      .asObservable()
      .map(dataSource.items(at:))
      .map(Reactor.Action.prefetchItems)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    self.photoCollectionView.rx.didScroll
      .withLatestFrom(self.photoCollectionView.rx.contentOffset)
      .map { [weak self] in
        Reactor.Action.pagination(
          contentHeight: self?.photoCollectionView.contentSize.height ?? 0,
          contentOffsetY: $0.y,
          scrollViewHeight: UIScreen.main.bounds.height
        )
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    reactor.state.map(\.photoSection)
      .distinctUntilChanged()
      .map(Array.init(with:))
      .bind(to: self.photoCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
