//
//  MainTabBarController.swift
//  MarvelCharacters
//
//  Created by Apple on 02/07/22.
//

import UIKit

class RootViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationAndTabBarApperance()
        self.setupTabBarController()
    }
    
    fileprivate func setupTabBarController() {
        //Instantiate controllers
        //Characters
        let charactersFlow = UICollectionViewFlowLayout()
        let viewModel = CharactersViewModel(apiManager: APIManager(), router: Router.getCharacters(searchKey: "", offSet: 0))
        let characters = UINavigationController.init(rootViewController: CharactersViewController(collectionViewLayout: charactersFlow, viewModel: viewModel))
        characters.title = TitlesConstants.charactersTitle
        characters.tabBarItem.image = UIImage(systemName: ImageNames.charactersTabBarUnselectedImage)
        characters.tabBarItem.selectedImage = UIImage(systemName: ImageNames.charactersTabBarselectedImage)
        //Comics
        let comicsFlow = UICollectionViewFlowLayout()
        let Comics = UINavigationController.init(rootViewController: ComicsViewController(collectionViewLayout: comicsFlow))
        Comics.title = TitlesConstants.comicsTitle
        Comics.tabBarItem.image = UIImage(systemName: ImageNames.comicsTabBarUnselectedImage)
        Comics.tabBarItem.selectedImage = UIImage(systemName: ImageNames.comicsTabBarselectedImage)
        //Set to Tab Bar
        viewControllers = [characters, Comics]
        if let items = tabBar.items {
            for item in items{
                item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
            }
        }
        
    }
    
    func setUpNavigationAndTabBarApperance() {
        if #available(iOS 15, *) {
            // NavigationBar Appearance
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            // Tab Bar Appearance
            let appearanceTab = UITabBarAppearance()
            appearanceTab.configureWithOpaqueBackground()
            UITabBar.appearance().standardAppearance = appearanceTab
            UITabBar.appearance().scrollEdgeAppearance = appearanceTab
        }
    }
    
}


