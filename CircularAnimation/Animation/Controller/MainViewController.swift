//
//  ViewController.swift
//  CircularAnimation
//
//  Created by Павел Афанасьев on 09.11.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var goButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download and present", for: .normal)
        button.backgroundColor = .orange
        button.tintColor = .white
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(goButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let customImageView = CustomImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupViews()
    }
    
    private func setupViews() {
        
        view.addSubview(goButton)
        view.addSubview(customImageView)
        
        NSLayoutConstraint.activate([
            goButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            goButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            goButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            goButton.heightAnchor.constraint(equalToConstant: 60),
            
            customImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            customImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
    }
    
    @objc private func goButtonTapped() {
        loadImageFromUrl()
    }
}

extension MainViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let data = try? Data(contentsOf: location) else { print("error with getting data")
            return }
        let image = UIImage(data: data)
        DispatchQueue.main.async {
            self.customImageView.image = image
            self.customImageView.progressIndicatorView.reveal()
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = totalBytesWritten / totalBytesExpectedToWrite
        DispatchQueue.main.async {
            self.customImageView.progressIndicatorView.progress = CGFloat(progress)
        }
    }
    
    private func loadImageFromUrl() {
        let stringUrl = "https://s1.1zoom.ru/big3/753/371608-svetik.jpg"
        guard let url = URL(string: stringUrl) else { print("error with downloading Image")
            return }
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        session.downloadTask(with: url)
            .resume()
    }
}


