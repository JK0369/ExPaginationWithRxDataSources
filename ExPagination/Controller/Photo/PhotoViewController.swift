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
    static let collectionViewSpacing = 8.0
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
      $0.centerY.centerX.equalToSuperview()
      $0.height.equalToSuperview().inset(Metric.collectionViewVerticalSpacing)
      $0.left.equalTo(view.safeAreaLayoutGuide).offset(Metric.collectionViewSpacing)
      $0.right.equalTo(view.safeAreaLayoutGuide).offset(-Metric.collectionViewSpacing)
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
    
    reactor.state.map(\.photoSection)
      .distinctUntilChanged()
      .map(Array.init(with:))
      .bind(to: self.photoCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
