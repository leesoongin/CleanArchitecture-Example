//
//  ImageListViewController.swift
//  CleanArchitecture-SearchSample
//
//  Created by 이숭인 on 12/22/24.
//

import UIKit
import Combine
import SnapKit
import Then

final class SearchedListView: BaseView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func setupSubviews() {
        addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

final class SearchedListViewController: ViewController<SearchedListView> {
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var adapter = CollectionViewAdapter(with: contentView.collectionView)
    
    let presenter: SearchedListPresentable
    let interactor: SearchedListInteractorable
    
    init(presenter: SearchedListPresentable, interactor: SearchedListInteractorable) {
        self.presenter = presenter
        self.interactor = interactor
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        interactor.request(with: .loadImages(query: "정신병동에도"))
//        interactor.request(with: .loadVideos(query: "정신병동에도"))
    }
    
    private func bind() {
        presenter.sectionItems
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                _ = self?.adapter.receive(sections)
            }
            .store(in: &cancellables)
        
        adapter.willDisplayCellIdentifierPublisher
            .sink { [weak self] identifier in
                self?.interactor.request(
                    with: .loadMoreImages(triggerID: identifier)
//                    with: .loadMoreVideos(triggerID: identifier)
                )
            }
            .store(in: &cancellables)
    }
}

