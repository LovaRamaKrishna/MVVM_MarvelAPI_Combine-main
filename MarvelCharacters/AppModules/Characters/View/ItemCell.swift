//
//  CharactersCell.swift
//  MarvelCharacters
//
//  Created by Apple on 02/07/22.
//

import UIKit

class ItemCell: UICollectionViewCell {
    
    private var title: String?
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    private (set) lazy var titleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(Constants.defaultCoderError)
    }
    
    func setup() {
        addSubview(imageView)
        self.imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.imageView.addBorder(color: .black, cornerRadius: 10, borderWidth: 1.0)
        addSubview(titleBackgroundView)
        self.titleBackgroundView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: self.contentView.frame.height * 0.7, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        titleBackgroundView.addSubview(titleLabel)
        self.titleLabel.anchor(top: titleBackgroundView.topAnchor, left: titleBackgroundView.leftAnchor, bottom: titleBackgroundView.bottomAnchor, right: titleBackgroundView.rightAnchor, paddingTop: 0, paddingLeft: 6, paddingBottom: 0, paddingRight: 6, width: 0, height: 0)
    }
    
    func configureCharactersCell(results: Results) {
        if let path = results.thumbnail?.path, let thumbnailExtension = results.thumbnail?.thumbnailExtension {
            self.imageView.loadRemoteImageFromServer(urlString: "\(path)\(AppURLS.extentionImageUrl)\(thumbnailExtension)")
        }
        self.titleLabel.text = results.name
    }
    
    func configureComicCell(results: ComicsObj){
        if let path = results.thumbnail.path, let thumbnailExtension = results.thumbnail.thumbnailExtension {
            self.imageView.loadRemoteImageFromServer(urlString: "\(path)\(AppURLS.extentionImageUrl)\(thumbnailExtension)")
        }
        self.titleLabel.text = results.title
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
}
