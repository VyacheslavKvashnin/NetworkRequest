//
//  MainCollectionViewController.swift
//  NetworkRequest
//
//  Created by Вячеслав Квашнин on 04.04.2022.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {

    // MARK: UICollectionViewDataSource
    
    private let userAction = UserAction.allCases

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        userAction.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserActionCell
        cell.userActionLabel.text = userAction[indexPath.item].rawValue
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userAction = userAction[indexPath.item]

        switch userAction {
        case .posts: performSegue(withIdentifier: "showPosts", sender: nil)
        case .comments: performSegue(withIdentifier: "showPhotos", sender: nil)
        case .postDict: postRequestWithDict()
        case .postModel: postRequestWithModel()
        case .alamofireGet: performSegue(withIdentifier: "showAFGet", sender: nil)
        case .alamofirePost: performSegue(withIdentifier: "showAFPost", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showPosts" {
            guard let commentVC = segue.destination as? CommentsTableViewController else { return }
            
            switch segue.identifier {
            case "showPhotos": commentVC.getComments()
            case "showAFGet": commentVC.alamofireGetButton()
            case "showAFPost": commentVC.alamofirePostButton()
            default: break
            }
        }
    }
    
    private func postRequestWithDict() {
        let dict = [
            "name": "Koko",
            "username": "Jako"
        ]
        
        NetworkManager.shared.postRequest(with: dict, to: Link.postsURL.rawValue) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func postRequestWithModel() {
        let user = User(
            name: "Name",
            username: "UserName",
            email: "post@mail.ru")
        
        NetworkManager.shared.postRequest(with: user, to: Link.postsURL.rawValue) { result in
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 40, height: 100)
    }
}
