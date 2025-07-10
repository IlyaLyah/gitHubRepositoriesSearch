//
//  RepositoryTableViewCell.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import UIKit

public class RepositoryTableViewCell: UITableViewCell {
    public static let identifier = "RepositoryTableViewCell"
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var starsCounterView: StarsCounterView = {
        let view = StarsCounterView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewModel: RepositoryTableViewCellViewModel? = nil {
        didSet {
            self.updateData()
        }
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        self.viewModel = nil
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        
        let textStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, starsCounterView])
            stackView.axis = .vertical
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 8
            stackView.alignment = .leading
            return stackView
        }()
        
        let contentStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [avatarImageView, textStackView])
            stackView.axis = .horizontal
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 20
            stackView.alignment = .center
            stackView.isUserInteractionEnabled = true
            return stackView
        }()
        
        self.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            .init(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60),
            .init(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 60),
            
            .init(item: contentStackView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 20),
            .init(item: contentStackView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -20),
            .init(item: contentStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 20),
            .init(item: contentStackView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: -20)
        ])
    }
    
    private func updateData() {
        guard let viewModel else { return }

        self.titleLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        if let avatarPath = viewModel.avatarPath, let url = URL(string: avatarPath) {
            Task {
                let imageData = await viewModel.imageLoader.loadImage(url: url)
                if let imageData {
                    self.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
        self.starsCounterView.setViewModel(viewModel: viewModel.starsViewModel)
    }
    
    public func set(viewModel: RepositoryTableViewCellViewModel) {
        self.viewModel = viewModel
    }
}
