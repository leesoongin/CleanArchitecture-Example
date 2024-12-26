//
//  CommonIndicatorComponent.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/24/24.
//

import UIKit
import Combine

struct CommonIndicatorComponent: Component {
    var widthStrategy: ViewWidthStrategy = .fill
    var heightStrategy: ViewHeightStrategy = .static(40)
    
    var identifier: String
    let isLast: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isLast)
    }
    
    public func prepareForReuse(content: CommonIndicatorView) {
        content.activityIndicator.stopAnimating()
    }
}

extension CommonIndicatorComponent {
    typealias ContentType = CommonIndicatorView
    
    func render(content: ContentType, context: Self, cancellable: inout Set<AnyCancellable>) {
        content.bind(with: context.isLast)
    }
}

final class CommonIndicatorView: BaseView {
    let emptySpace = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .medium).then {
        $0.color = .systemPink
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicator.center = self.center
    }
    
    override func setupSubviews() {
        addSubview(activityIndicator)
    }
    
    override func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func bind(with isLast: Bool) {
        if isLast {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}

