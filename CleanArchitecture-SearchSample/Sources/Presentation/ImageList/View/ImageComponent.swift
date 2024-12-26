//
//  ImageComponent.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/24/24.
//

import UIKit
import Combine
import SnapKit
import Then
import Kingfisher

struct ImageComponent: Component {
    var widthStrategy: ViewWidthStrategy = .column(3)
    var heightStrategy: ViewHeightStrategy = .ratio(1)
    
    var identifier: String
    let thumbnailURL: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(thumbnailURL)
    }
}

extension ImageComponent {
    typealias ContentType = ImageComponentView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(thumbnailURL: context.thumbnailURL)
    }
}

final class ImageComponentView: BaseView {
    let imageView = UIImageView()
    
    override func setupSubviews() {
        addSubview(imageView)
    }
    
    override func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func bind(thumbnailURL: String) {
        let url = URL(string: thumbnailURL)
        imageView.kf.setImage(with: url)
    }
}

