//
//  RepositoryDetailsViewController.swift
//  githubRepo
//
//  Created by Ilya Liakh on 17.06.25.
//

import UIKit

public class RepositoryDetailsViewController: UIViewController {
    private let viewModel: RepositoryDetailsViewModel
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
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
    
    private lazy var forksCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var issuesCounterLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var repositoryLinkLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blue
        label.isUserInteractionEnabled = true
        return label
    }()
    
    init(viewModel: RepositoryDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        self.view.backgroundColor = .white
        let textStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, starsCounterView, forksCounterLabel, issuesCounterLabel, repositoryLinkLabel])
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
        
        self.view.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            .init(item: avatarImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 60),
            .init(item: avatarImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 60),
            
            .init(item: contentStackView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
            .init(item: contentStackView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1.0, constant: -20),
            .init(item: contentStackView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 20),
            .init(item: contentStackView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: -20)
        ])
        
        self.titleLabel.text = viewModel.name
        self.descriptionLabel.text = viewModel.description
        self.forksCounterLabel.text = "Forks count is \(viewModel.forksCount)"
        self.issuesCounterLabel.text = "Issues count is \(viewModel.issuesCount)"
        self.repositoryLinkLabel.text = viewModel.repositoryPath
        self.starsCounterView.setViewModel(viewModel: viewModel.starsViewModel)
        if let avatarPath = viewModel.avatarPath, let url = URL(string: avatarPath) {
            Task {
                let imageData = await viewModel.imageLoader.loadImage(url: url)
                if let imageData {
                    self.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
        
        let repositoryLinkGesture = UITapGestureRecognizer(target: self, action: #selector(repositoryUrlTap))
        repositoryLinkLabel.addGestureRecognizer(repositoryLinkGesture)
    }

    @objc private func repositoryUrlTap() {
        viewModel.repositoryLinkTapped()
    }
}

