//
//  ComicsViewController.swift
//  MarvelCharacters
//
//  Created by Apple on 02/07/22.
//

import UIKit
import Combine

class ComicsViewController: UICollectionViewController {
    
    // MARK: - Constants
    private let reuseIdentifier = Constants.reuseIdentifier
    
    // MARK: - property
    private var cancellables = Set<AnyCancellable>()
    private var filterKey = FilterActions.all
    
    private let apiManager = APIManager()
    private var viewModel: ComicsViewModel!
    private var activityIndiator : UIActivityIndicatorView?
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.defaultCoderError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewModel()
        self.configureCollectionView()
        self.configureNavigationbar()
        self.setActivityIndicater()
        self.observeViewModel()
        self.setCustomSegmentedControl()
    }
    
    // MARK: - Custom Methods
    private func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 60, left: 10, bottom: 10, right: 10)
        let size = (view.frame.width - 26) / 2
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        self.collectionView.collectionViewLayout = layout
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        self.collectionView!.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    private func configureNavigationbar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
       // self.navigationItem.searchController = setCustomSegmentedControl()
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = self.viewModel.getTitle()
    }
  
    private func setActivityIndicater() {
        activityIndiator = UIActivityIndicatorView(frame: CGRect(x: self.view.frame.midX - 15, y: self.view.frame.height - 140, width: 30, height: 30))
        activityIndiator?.style = .medium
        activityIndiator?.color = UIColor.black
        activityIndiator?.hidesWhenStopped = true
        activityIndiator?.backgroundColor = .clear
        activityIndiator?.layer.cornerRadius = 15
        self.view.addSubview(activityIndiator!)
        self.view.bringSubviewToFront(activityIndiator!)
    }
    
    private func setUpViewModel() {
        self.viewModel = ComicsViewModel(apiManager: apiManager, router: .getComics(offSet: 0, filterKey: filterKey.apiKeys))
        self.viewModel.getComics(isFromSearch: false, isNewPage: false, filterKey: filterKey.apiKeys, isNewOffset: false)
    }
    
    private func setCustomSegmentedControl()  {
        var codeSegmented = CustomSegmentedControl()
        if UIDevice.current.hasNotch {
            codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 90, width: self.view.frame.width, height: 40), buttonTitle: FilterActions.buttonList)
        } else {
            codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 64, width: self.view.frame.width, height: 40), buttonTitle: FilterActions.buttonList)
        }
        codeSegmented.backgroundColor = .white
        codeSegmented.delegate = self
        self.view.addSubview(codeSegmented)
    }
    
     func observeViewModel() {
        viewModel.getUserSubject().sink(receiveCompletion: { (resultCompletion) in
            switch resultCompletion {
            case .failure(let error):
                self.presentAlertWithTitle(title: Constants.error, message: error.localizedDescription, options: Constants.ok) { (option) in }
            default: break
            }
        }) { (arrayOfResults) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.store(in: &cancellables)
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.getComics().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        let results = self.viewModel.getComics()[indexPath .row]
        cell.configureComicCell(results: results)
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.viewModel.isGetResponse {
            if (self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.bounds.size.height)) {
                if self.viewModel.totalArrayCount > self.viewModel.totalCount ?? 0 {
                    self.viewModel.isGetResponse = true
                    self.activityIndiator?.startAnimating()
                    self.view.bringSubviewToFront(activityIndiator!)
                    self.viewModel.getComics(isFromSearch: false, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: false)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.activityIndiator?.stopAnimating()
            }
        }
    }
}


extension ComicsViewController: CustomSegmentedControlDelegate {
    func change(to index:Int) {
        print("segmentedControl index changed to \(index)")
        if let caseValue = FilterActions.allCases.first(where: { $0.rawValue == index }) {
            switch caseValue {
            case .lastWeek:
                filterKey = .lastWeek
                self.viewModel.getComics(isFromSearch: true, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: true)
            case .thisWeek:
                filterKey = .thisWeek
                self.viewModel.getComics(isFromSearch: true, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: true)
            case .nextWeek:
                filterKey = .nextWeek
                self.viewModel.getComics(isFromSearch: true, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: true)
            case .thisMonth:
                filterKey = .thisMonth
                self.viewModel.getComics(isFromSearch: true, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: true)
            case .all:
                filterKey = .all
                self.viewModel.getComics(isFromSearch: true, isNewPage: true, filterKey: filterKey.apiKeys, isNewOffset: true)
            }
        }
    }
}
