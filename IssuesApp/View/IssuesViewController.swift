//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Leonard on 2017. 11. 4..
//  Copyright © 2017년 intmain. All rights reserved.
//

import UIKit
import Alamofire

protocol DataSourceRefreshable: class {
    associatedtype Item
    var dataSource: [Item] { get set }
    var needRefreshDataSource: Bool { get set }
}

extension DataSourceRefreshable {
    func setNeedRefreshDataSource() {
        needRefreshDataSource = true
    }
    func refreshDataSourceIfNeeded() {
        if needRefreshDataSource {
            dataSource = []
            needRefreshDataSource = false
        }
    }
}

class IssuesViewController: UIViewController, DataSourceRefreshable {
    var needRefreshDataSource: Bool = false
    @IBOutlet var collectionView: UICollectionView!
    let owner: String = GlobalState.instance.owner
    let repo: String = GlobalState.instance.repo
    var dataSource: [Model.Issue] = []
    fileprivate let estimateCell: IssueCell = IssueCell.cellFromNib
    let refreshControl = UIRefreshControl()
    var page: Int  = 1
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var loadMoreFooterView: LoadMoreFooterView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension IssuesViewController {
    
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
    }
    func load() {
        guard isLoading == false else { return }
        isLoading = true
        App.api.repoIssues(owner: owner, repo: repo, page: page) { [weak self] (dataResponse: DataResponse<[Model.Issue]>) in
            guard let `self` = self else { return }
            switch dataResponse.result {
            case .success(let items):
                
                self.dataLoaded(items: items)
                self.isLoading = false
            case .failure:
                self.isLoading = false
                break
            }
            
        }
    }
    func dataLoaded(items: [Model.Issue]) {
        refreshDataSourceIfNeeded()
        refreshControl.endRefreshing()
        page += 1
        if items.isEmpty {
            canLoadMore = false
            loadMoreFooterView?.loadDone()
        }
        dataSource.append(contentsOf: items)
        collectionView.reloadData()
    }
    func refresh() {
        page = 1
        canLoadMore = true
        loadMoreFooterView?.load()
        setNeedRefreshDataSource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard indexPath.item == dataSource.count - 1  && !isLoading && canLoadMore else { return }
        load()
    }
}

extension IssuesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else { return IssueCell() }
        let data = dataSource[indexPath.item]
        cell.update(data: data)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            return footer
        default:
            assert(false, "unexpected element Kind")
            return UICollectionReusableView()
        }
    }
}

extension IssuesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = dataSource[indexPath.item]
        estimateCell.update(data: data)
        let targetSize = CGSize(width: collectionView.frame.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        return estimatedSize
    }
}
extension IssuesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
}










