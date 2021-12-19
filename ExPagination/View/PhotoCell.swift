//
//  PhotoCell.swift
//  ExPagination
//
//  Created by 김종권 on 2021/12/19.
//

import UIKit
import Reusable
import SnapKit

final class PhotoCell: UICollectionViewCell, Reusable {
  // MARK: UI
  private let photoImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  // MARK: Initializers
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.contentView.addSubview(self.photoImageView)
    self.photoImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setImage(urlString: String) {
    photoImageView.setImage(with: urlString)
  }
}
