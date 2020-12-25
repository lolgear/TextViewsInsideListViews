//
//  ViewController.swift
//  TextViewsInsideListViews
//
//  Created by Dmitry Lobanov on 02.12.2020.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    /// Aliases
    private typealias ListDiffableDataSource = AnyListDataSource<ViewModel.Section, ViewModel.Row>
    typealias ListDiffableDataSourceSnapshot = NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Row>
    typealias TableViewDataSource = UITableViewDiffableDataSource<ViewModel.Section, ViewModel.Row>
    typealias CollectionViewDataSource = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Row>
    
    /// Views
    private var tableView: UITableView!
    private var collectionView: UICollectionView!
    
    private var tableViewController: UITableViewController?
    private var collectionViewController: UICollectionViewController?
    
    private var listView: UIView? {
        self.viewModel.options.shouldUseCollectionView ? self.collectionView : self.tableView
    }
    private var listViewController: UIViewController? {
        self.viewModel.options.shouldUseCollectionView ? self.collectionViewController : self.tableViewController
    }
    
    /// DataSource
    private var dataSource: ListDiffableDataSource?
    //UITableViewDiffableDataSource<ViewModel.Section, ViewModel.Row>?
    
    /// ViewModel
    private var viewModel: ViewModel
    
    /// Subscriptions
    private var subscriptions: Set<AnyCancellable> = []
    
    /// Initializers
    init(_ model: ViewModel) {
        self.viewModel = model
        super.init(nibName: nil, bundle: nil)
        self.setupController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: View Lifecycle
extension ViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.refreshDataSource()
    }
}

// MARK: Setup
extension ViewController {
    func setup() {
        self.setupListView()
        self.addLayout()
        self.setupDataSource()
        self.setupSubscribers()
    }
    
    func setupController() {
        self.title = self.viewModel.title
    }
    
    func setupDataSource() {
        if self.viewModel.options.shouldUseCollectionView {
            self.setupCollectionViewDataSource()
        }
        else {
            self.setupTableViewDataSource()
        }
    }
    
    func setupListView() {
        switch (self.viewModel.options.shouldUseCollectionView, self.viewModel.options.shouldEmbedController) {
        case (false, false):
            /// TableView
            self.tableView = .init()
        case (true, false):
            /// CollectionView
            self.collectionView = .init(frame: .zero, collectionViewLayout: self.createLayout())
        case (false, true):
            /// TableViewController
            self.tableViewController = .init(style: .plain)
            self.tableView = self.tableViewController?.tableView
        case (true, true):
            /// CollectionViewController
            self.collectionViewController = .init(collectionViewLayout: self.createLayout())
            self.collectionView = self.collectionViewController?.collectionView
        }
        
        if let controller = self.listViewController {
            self.addChild(controller)
        }
        if let view = self.listView {
            self.view.addSubview(view)
        }
        if let controller = self.listViewController {
            controller.didMove(toParent: self)
        }
        
        if self.tableView != nil {
            self.setupTableView()
        }
        else if self.collectionView != nil {
            self.setupCollectionView()
        }
    }
        
    func addLayout() {
        self.listView?.embedInParent()
    }
    
    func setupSubscribers() {
        self.viewModel.sizeDidChangePublisher.sink { [weak self] _ in
            self?.refreshCellSize()
        }.store(in: &self.subscriptions)
    }
}

// MARK: TableView
extension ViewController {
    func setupTableViewDataSource() {
        
        /// Register Cells
        self.tableView.register(Cell.ContentConfiguration.Cell.Table.self, forCellReuseIdentifier: Cell.ContentConfiguration.Cell.Table.cellReuseIdentifier())
        
        /// Data Source
        let dataSource = TableViewDataSource.init(tableView: self.tableView, cellProvider: { (tableView, indexPath, row) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.ContentConfiguration.Cell.Table.cellReuseIdentifier(), for: indexPath)
            cell.contentConfiguration = Cell.ContentConfiguration.ContentConfiguration(row)
            return cell
        })
        self.tableView.dataSource = dataSource
        self.dataSource = .init(dataSource)
    }
    
    func setupTableView() {
        if let tableView = self.tableView {
            tableView.contentInset = .zero
            tableView.backgroundView = .init()
            tableView.backgroundColor = .white
            tableView.allowsSelection = true
            tableView.delegate = self
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableView.automaticDimension
            tableView.sectionHeaderHeight = 0
            tableView.separatorStyle = .none
        }
    }
}

// MARK: CollectionView
extension ViewController {
    func setupCollectionViewDataSource() {
        
        /// Register Cells
        self.collectionView.register(Cell.ContentConfiguration.Cell.Collection.self, forCellWithReuseIdentifier: Cell.ContentConfiguration.Cell.Collection.cellReuseIdentifier())
        
        /// Data Source
        let dataSource = CollectionViewDataSource.init(collectionView: self.collectionView, cellProvider: { (collectionView, indexPath, row) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.ContentConfiguration.Cell.Collection.cellReuseIdentifier(), for: indexPath)
            cell.contentConfiguration = Cell.ContentConfiguration.ContentConfiguration(row)
            return cell
        })
        self.collectionView.dataSource = dataSource
        self.dataSource = .init(dataSource)
    }
    
    func setupCollectionView() {
        if let collectionView = self.collectionView {
            collectionView.backgroundView = .init()
            collectionView.backgroundColor = .white
            collectionView.allowsSelection = true
        }
    }
    
    private func createFlowLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(40))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(40))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.backgroundColor = .white
        listConfiguration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
        return layout
    }
    
    private func createLayout() -> UICollectionViewLayout {
//        self.createFlowLayout()
        self.createListLayout()
    }
}

// MARK: Refresh
extension ViewController {
    func refreshDataSource() {
        var snapshot: NSDiffableDataSourceSnapshot<ViewModel.Section, ViewModel.Row> = .init()
        snapshot.appendSections(self.viewModel.sections)
        snapshot.appendItems(self.viewModel.rows, toSection: self.viewModel.sections[0])
//        UIView.performWithoutAnimation {
            self.dataSource?.apply(snapshot, animatingDifferences: false, completion: nil)
//        }
    }
    
    func refreshCellSize() {
        func updateView() {
            // WORKAROUND:
            // In case of jumping rows we should remove animations..
            // well...
            // it works...
            // I guess..
            // Thanks! https://stackoverflow.com/a/51048044/826614
            if let tableView = self.tableView {
                let lastContentOffset = tableView.contentOffset
                tableView.beginUpdates()
                tableView.endUpdates()
                tableView.layer.removeAllAnimations()
                tableView.setContentOffset(lastContentOffset, animated: false)
//                tableView.performBatchUpdates(nil, completion: nil)
            }
            else if let collectionView = self.collectionView {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }

        updateView()
    }
}

// MARK: Configurations
extension ViewController {
    func configured(_ model: ViewModel) -> Self {
        self.viewModel = model
        return self
    }
}

extension ViewController: UITableViewDelegate {
    /// Do something if needed.
}

