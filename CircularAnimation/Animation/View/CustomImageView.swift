//
//  CustomImageVIew.swift
//  CircularAnimation
//
//  Created by Павел Афанасьев on 09.11.2022.
//

import UIKit

class CustomImageView: UIImageView {
    
    let progressIndicatorView = CircularLoaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(progressIndicatorView)
        translatesAutoresizingMaskIntoConstraints = false
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressIndicatorView.widthAnchor.constraint(equalTo: widthAnchor),
            progressIndicatorView.heightAnchor.constraint(equalTo: heightAnchor),
            progressIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
