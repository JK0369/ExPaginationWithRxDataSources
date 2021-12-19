//
//  BaseViewController.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
  // MARK: Constants
  private enum Color {
    static let white = UIColor.white
  }
  
  // MARK: Properties
  var disposeBag = DisposeBag()
  
  // MARK: Initializers
  init() {
    super.init(nibName: nil, bundle: nil)
    configures()
  }
  
  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: View Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBackgroundIfNotSet()
    configureLayout()
  }
  
  private func setupBackgroundIfNotSet() {
    if self.view.backgroundColor == nil {
      self.view.backgroundColor = Color.white
    }
  }
  
  // MARK: Override points
  func configures() {}
  func configureLayout() {}
}


