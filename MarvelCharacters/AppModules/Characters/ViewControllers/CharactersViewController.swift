//
//  CharactersViewController.swift
//  MarvelCharacters
//
//  Created by Apple on 02/07/22.
//

import UIKit
import Combine

class CharactersViewController: UICollectionViewController {
    
    // MARK: - Constants
    private let reuseIdentifier = Constants.reuseIdentifier
    
    // MARK: - Computed property
    let searchController = UISearchController(searchResultsController: nil)
    var cancellables = Set<AnyCancellable>()
    private var viewModel: CharactersViewModel!
    private var activityIndiator : UIActivityIndicatorView?
    private var searchString: String = Constants.emptyString
    
    let transparentView = UIView()
    let tableView = UITableView()
    
    // MARK: - ViewLifeCycle
    init(collectionViewLayout layout: UICollectionViewLayout, viewModel: CharactersViewModel) {
        super.init(collectionViewLayout: layout)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError(Constants.defaultCoderError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViewModel()
        self.setActivityIndicater()
        self.setUpSearchHistoryTableview()
        self.configureCollectionView()
        self.configureNavigationbar()
        self.setupSearchBarListeners()
        self.observeViewModel()
    }
    
    // MARK: - Custom Methods
    private func configureCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let size = (view.frame.width - 26) / 2
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        self.collectionView.collectionViewLayout = layout
        self.view.backgroundColor = UIColor.init(hex: "FFFFFF")
        self.collectionView.backgroundColor = UIColor.clear
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        self.collectionView!.register(ItemCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    private func configureNavigationbar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.title = self.viewModel.getTitle()
        self.searchController.searchBar.placeholder = Constants.searchPlaceHolder
    }
    
    private func setUpSearchHistoryTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func addTransparentView(frames: CGRect) {
        let window = UIWindow.key
        transparentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transparentView)
        tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        self.view.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height + 5, width: frames.width, height: CGFloat(self.viewModel.getSearchHistoryArray().count * 50 + 50))
        }, completion: nil)
        tableView.reloadData()
    }
    
    @objc func removeTransparentView() {
        let frames = self.searchController.searchBar.frame
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.tableView.frame = CGRect(x: frames.origin.x, y: frames.origin.y + frames.height, width: frames.width, height: 0)
        }, completion: nil)
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
        self.viewModel.getCharacters(text: "", isFromSearch: false, isNewPage: false)
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: searchController.searchBar.searchTextField)
        let textDidBeginEditing = NotificationCenter.default.publisher(for: UISearchTextField.textDidBeginEditingNotification, object: searchController.searchBar.searchTextField)
        let textDidEndEditing = NotificationCenter.default.publisher(for: UISearchTextField.textDidEndEditingNotification, object: searchController.searchBar.searchTextField)
        textDidBeginEditing.receive(on: RunLoop.main).sink { textDidBeginEditing in
                self.addTransparentView(frames: self.searchController.searchBar.searchTextField.frame)
        }.store(in: &cancellables)
        textDidEndEditing.receive(on: RunLoop.main).sink { textDidEndEditing in
            self.searchController.searchBar.resignFirstResponder()
            self.removeTransparentView()
        }.store(in: &cancellables)
        publisher
            .map { ($0.object as! UISearchTextField).text }
            .debounce(for: .milliseconds(1000), scheduler: RunLoop.main)
            .sink { (str) in
                if let string = str {
                    if string != "" {
                        self.searchString = string
                        if self.searchString != "" {
                            _ =  self.viewModel.addNewElementTofixedArray(element: string)
                        }
                        self.tableView.reloadData()
                        self.viewModel.getCharacters(text: string, isFromSearch: true, isNewPage: false)
                        self.searchController.searchBar.endEditing(true)
                    }
                }
            }.store(in: &cancellables)
    }
        
    private func observeViewModel() {
        viewModel.getUserSubject().sink(receiveCompletion: { (resultCompletion) in
            switch resultCompletion {
            case .failure(let error):
                self.presentAlertWithTitle(title: "Error", message: error.localizedDescription, options: "OK") { (option) in }
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
        self.viewModel.getCharacters().count > 0 ? self.collectionView.restore() : self.collectionView.setEmptyMessage("We couldn’t find a match for \"\(self.searchController.searchBar.searchTextField.text ?? "")\"")
        return self.viewModel.getCharacters().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ItemCell
        let results = self.viewModel.getCharacters()[indexPath .row]
        cell.configureCharactersCell(results: results)
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
                    self.viewModel.getCharacters(text: self.searchController.searchBar.text ?? "", isFromSearch: false, isNewPage: true)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.activityIndiator?.stopAnimating()
            }
        }
    }
}

extension CharactersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getSearchHistoryArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = self.viewModel.getSearchHistoryArray()[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchController.searchBar.text = self.viewModel.getSearchHistoryArray()[indexPath.row]
        self.viewModel.getCharacters(text: self.viewModel.getSearchHistoryArray()[indexPath.row], isFromSearch: true, isNewPage: false)
        removeTransparentView()
    }
}


