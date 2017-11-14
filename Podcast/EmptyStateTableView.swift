//
//  EmptyStateTableView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//
import UIKit
import NVActivityIndicatorView

protocol EmptyStateTableViewDelegate: class {
    func didPressEmptyStateViewActionItem()
}

/**
 UITableView Subclass with predefined styles and an empty state view shown when no cells are in this tableView for all sections
 */
class EmptyStateTableView: UITableView, EmptyStateViewDelegate {
    
    var type: EmptyStateType
    var emptyStateView: EmptyStateView!
    var loadingAnimation: NVActivityIndicatorView!
    weak var emptyStateTableViewDelegate: EmptyStateTableViewDelegate?
    
    // isRefreshable Boolean indicating whether this tableView has a UIRefreshControl
    init(frame: CGRect, type: EmptyStateType, isRefreshable: Bool = false) {
        self.type = type
        super.init(frame: frame, style: .plain)
        emptyStateView = EmptyStateView(type: type)
        emptyStateView.mainView.isHidden = true
        emptyStateView.delegate = self
        backgroundView = emptyStateView
        showsVerticalScrollIndicator = false
        separatorStyle = .none
        backgroundColor = .clear
        
        loadingAnimation = createLoadingAnimationView()
        backgroundView!.addSubview(loadingAnimation)
        loadingAnimation.snp.makeConstraints { make in
            make.center.equalToSuperview().priority(999)
        }
        loadingAnimation.startAnimating()
        
        if isRefreshable {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = .sea
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !loadingAnimation.isAnimating else { return }
        // make sure there is no data in tableView before displaying background
        for s in 0..<numberOfSections {
            if numberOfRows(inSection: s) > 0 {
                emptyStateView.mainView.isHidden = true
                return
            }
        }
        emptyStateView.mainView.isHidden = false
    }
    
    func stopLoadingAnimation() {
        loadingAnimation.stopAnimating()
    }
    
    func startLoadingAnimation() {
        loadingAnimation.startAnimating()
        emptyStateView.mainView.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didPressActionItemButton() {
        emptyStateTableViewDelegate?.didPressEmptyStateViewActionItem()
    }
    
    //MARK
    //MARK: Refresh Control Functions
    //MARK
    
    func endRefreshing() {
        if let control = refreshControl {
            if control.isRefreshing {
                DispatchTime.waitFor(milliseconds: 500, completion: { self.refreshControl?.endRefreshing() } )
            }
        }
    }
    
    func beginRefreshing() {
        if let control = refreshControl {
            if !control.isRefreshing { control.beginRefreshing() }
        }
    }
    
    //this is a function extension because NVActivityIndicatorView is a final class so it cannot be subclassed
    func createLoadingAnimationView() -> NVActivityIndicatorView {
        let width: CGFloat = 30
        let height: CGFloat = 30
        let color: UIColor = .sea
        let type: NVActivityIndicatorType = .ballTrianglePath
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        return NVActivityIndicatorView(frame: frame, type: type, color: color, padding: 0)
    }
}
