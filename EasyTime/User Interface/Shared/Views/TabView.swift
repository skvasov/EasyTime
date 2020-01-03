//
//  TabView.swift
//  EasyTime
//
//  Created by Sergei Kvasov on 1/5/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//
import UIKit

fileprivate struct Constants {

    static let curveViewWidth: CGFloat = 39
    static let curverViewOverlayWidth: CGFloat = 0.5
    static let fontSize: CGFloat = 14
    static let textColor = UIColor(red: 65 / 255, green: 91 / 255, blue: 128 / 255, alpha: 1)
    static let selectedTextColor = UIColor.black
    static let fillColor = UIColor(red: 175 / 255, green: 190 / 255, blue: 211 / 255, alpha: 1)
    static let selectedFillColor = UIColor.white
}

enum TabViewItemPosition {
    
    case left
    case right
    case middle
}

@objc protocol TabViewDelegate: class {
    
    func numberOfItemsForTabView(tabView: TabView) -> Int
    func tabView(_ tabView: TabView, titleForItemAtIndex index: Int) -> String?
    func tabView(_ tabView: TabView, didSelectItemAtIndex index: Int)
}

class TabView: UIView {
    
    @IBOutlet weak var delegate: TabViewDelegate? {
        
        didSet {
            
            self.reloadData()
        }
    }

    var selectedIndex: Int = 0 {

        didSet {

            self.selectItem(at: self.selectedIndex)
        }
    }

    func reloadData() {
        
        for subview in self.subviews {
            
            subview.removeFromSuperview()
        }
        
        if let delegate = self.delegate {
            
            let numberOfItems = delegate.numberOfItemsForTabView(tabView: self)

            if numberOfItems > 0 {

                var leadingItem: UIView? = nil
                for i in 0...(numberOfItems - 1) {

                    var position = TabViewItemPosition.middle
                    if i == 0 && numberOfItems > 1 {

                        position = .left
                    }
                    else if i == numberOfItems - 1 && numberOfItems > 1 {

                        position = .right
                    }

                    let item = TabViewItem(position: position)
                    item.tag = i
                    item.setTitle(delegate.tabView(self, titleForItemAtIndex: i), for: .normal)
                    item.addTarget(self, action: #selector(TabView.didTap(sender:)), for: .touchUpInside)

                    self.addSubview(item)

                    NSLayoutConstraint.activate( [
                        NSLayoutConstraint(item: item, attribute: .leading, relatedBy: .equal, toItem: leadingItem == nil ? self : leadingItem, attribute: leadingItem == nil ? .leading : .trailing, multiplier: 1, constant: leadingItem == nil ? -Constants.curveViewWidth / 2 : -Constants.curveViewWidth),
                        item.safeTopAnchor.constraint(equalTo: self.safeTopAnchor),
                        item.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor),
                        NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1 / CGFloat(numberOfItems), constant: Constants.curveViewWidth),
                        ])

                    leadingItem = item
                }
                self.selectItem(at: self.selectedIndex)
            }
        }
    }
    
    //MAKR: - Action handlers
    
    @objc func didTap(sender: UIButton) {
        
        let index = sender.tag
        self.selectItem(at: index)

        if let delegate = self.delegate {

            delegate.tabView(self, didSelectItemAtIndex: index)
        }
    }

    //MARK: - Private functions

    private func selectItem(at index: Int) {

        for item in self.subviews {

            let i = item.tag
            if let item = item as? UIButton {

                item.isSelected = i == index

                if item.isSelected == true {

                    self.bringSubview(toFront: item)
                }
            }
        }
    }
}

private class TabViewItem: UIButton
{
    let position: TabViewItemPosition

    lazy var leftCurveImageView: UIImageView = {

        let image = UIImage(named: "tabLeftCurve")
        let imageView = UIImageView(image: image)
        imageView.highlightedImage = UIImage(named: "tabLeftCurveSelected")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    lazy var rightCurveImageView: UIImageView = {

        let image = UIImage(named: "tabRightCurve")
        let imageView = UIImageView(image: image)
        imageView.highlightedImage = UIImage(named: "tabRightCurveSelected")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    lazy var middleView: UIView = {

        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    override var isSelected: Bool {

        didSet {

            self.middleView.backgroundColor = self.isSelected ? Constants.selectedFillColor : Constants.fillColor

            if self.position != .left {

                self.leftCurveImageView.isHighlighted = self.isSelected
            }
            if self.position != .right {

                self.rightCurveImageView.isHighlighted = self.isSelected
            }
        }
    }

    init(position: TabViewItemPosition) {

        self.position = position
        super.init(frame: CGRect.zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.middleView)
        var constraints: [NSLayoutConstraint] = [
            self.middleView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: position == .left ? 0 : Constants.curveViewWidth),
            self.middleView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor),
            self.middleView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: position == .right ? 0 : -Constants.curveViewWidth),
            self.middleView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor)
        ]

        if position == .left || position == .middle {

            self.addSubview(self.rightCurveImageView)
            constraints.append(contentsOf: [
                self.rightCurveImageView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor),
                self.rightCurveImageView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor),
                self.rightCurveImageView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: Constants.curverViewOverlayWidth),
                NSLayoutConstraint(item: self.rightCurveImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.curveViewWidth + Constants.curverViewOverlayWidth),
                ])
        }

        if position == .right || position == .middle {

            self.addSubview(self.leftCurveImageView)
            constraints.append(contentsOf: [
                self.leftCurveImageView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor),
                self.leftCurveImageView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor),
                self.leftCurveImageView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: Constants.curverViewOverlayWidth),
                NSLayoutConstraint(item: self.leftCurveImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: Constants.curveViewWidth + Constants.curverViewOverlayWidth),
                ])
        }

        NSLayoutConstraint.activate(constraints)

        self.titleLabel?.font = UIFont.systemFont(ofSize: Constants.fontSize)
        self.titleLabel?.textColor = Constants.textColor
        self.setTitleColor(Constants.textColor, for: .normal)
        self.setTitleColor(Constants.selectedTextColor, for: .selected)
        self.backgroundColor = UIColor.clear
        self.isSelected = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

