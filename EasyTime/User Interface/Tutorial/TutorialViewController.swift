//
//  TutorialViewController.swift
//  EasyTime
//
//  Created by Mobexs on 2/7/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants
{
    static let skipButtonTitle = NSLocalizedString("Skip", comment: "")
}

class TutorialViewController: BaseViewController<TutorialViewModel>, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var btnSkip: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib.init(nibName: TutorialCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: TutorialCollectionViewCell.reuseIdentifier)
        self.btnSkip.setTitle(Constants.skipButtonTitle, for: .normal)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        self.updateControls()
    }

    func updateControls() {

        if let index = self.collectionView.indexPathsForVisibleItems.first {
            let item = self.viewModel[index]
            self.lblTitle.text = item.title
            self.lblDescription.text = item.description
            self.pageControl.numberOfPages = self.viewModel.numberOfItemsInSection(section: 0)
            self.pageControl.currentPage = index.row
        }
    }

    //MARK: - Action handlers

    @IBAction func skip(sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel.numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCollectionViewCell.reuseIdentifier, for: indexPath) as! TutorialCollectionViewCell
        let item = self.viewModel[indexPath]
        cell.imageView.image = UIImage(named: item.imageName)
        return cell
    }

    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    //MARK: - UIScrollViewDelegate

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateControls()
    }
}
