//
//  ViewController.swift
//  UICollectionViewSimpleList1
//
//  Created by MH on 2023/09/21.
//

import UIKit

class ViewController: UIViewController {
    
    enum Section {
        case main
    }
    
    let prefectures: [String] = ["福岡", "佐賀", "長崎", "大分", "熊本", "宮崎", "鹿児島"]
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var collectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }
}

extension ViewController {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}

extension ViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.delegate = self //タップ操作へ対応するため
    }
    
    func configureDataSource() {
        
        //【C】リサイクル機能
        let cellRegistration = UICollectionView.CellRegistration
        <UICollectionViewListCell, String> {
            (cell, indexPath, identifier) in
            var content = cell.defaultContentConfiguration()
            content.text = identifier
            cell.contentConfiguration = content
        }
        
        //データソースの作成
        dataSource = UICollectionViewDiffableDataSource<Section, String> (collectionView: collectionView) 
        {
            //【B】セルの内容が決定
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        //【A】構成を決める
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.main])
        snapshot.appendItems(prefectures, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


