//
//  SegmentView.swift
//  EasyTime
//
//  Created by Yury Ramazanov on 29/03/2018.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static let borderColor = UIColor(red: 175 / 255, green: 190 / 255, blue: 211 / 255, alpha: 1)
    static let thumbBorderColor = UIColor(red: 62 / 255, green: 142 / 255, blue: 215 / 255, alpha: 1)
    static let defaultItems = [NSLocalizedString("day", comment: ""), NSLocalizedString("week", comment: ""), NSLocalizedString("month", comment: "")]
    static let font = UIFont.systemFont(ofSize: 14)
    static let slectedFont = UIFont.boldSystemFont(ofSize: 14)
}

class SegmentView: UIControl {
    
    private var labels = [UILabel]()
    
    lazy var backgroundView: UIView = {
        
        let backgroundView = UIView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        backgroundView.backgroundColor = UIColor.clear
        backgroundView.layer.cornerRadius = frame.height / 2
        backgroundView.layer.borderColor = Constants.borderColor.cgColor
        backgroundView.layer.borderWidth = 1
        backgroundView.translatesAutoresizingMaskIntoConstraints = false;
        backgroundView.isUserInteractionEnabled = false
        
        return backgroundView
    }()
    
    lazy var thumbView: UIView = {
        let thumbView = UIView()
        thumbView.backgroundColor = UIColor.clear
        thumbView.layer.cornerRadius = thumbView.frame.height / 2
        thumbView.layer.borderColor = Constants.thumbBorderColor.cgColor
        thumbView.layer.borderWidth = 2
        
        return thumbView
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        stackView.axis  = .horizontal
        stackView.distribution  = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        stackView.isUserInteractionEnabled = false
        
        return stackView
    }()
    
    var items: [String] = Constants.defaultItems {
        didSet {
            updateLabels()
        }
    }
    
    var selectedIndex : Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var newFrame = self.bounds
        
        let newWidth = newFrame.width / CGFloat(items.count)
        let newHeight = newFrame.height
        newFrame.size.width = newWidth
        newFrame.size.height = newHeight
        thumbView.frame = CGRect(origin: thumbView.frame.origin, size: newFrame.size)
        thumbView.layer.cornerRadius = newHeight / 2
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex:Int?
        for label in labels {
            if label.frame.contains(location) {
                calculatedIndex = labels.index(of: label)
                break
            }
        }
        
        if let index = calculatedIndex {
            selectItem(at: index, animated: true)
            sendActions(for: .valueChanged)
        }
    
        return false
    }
    
//MARK: - Public functions
    
    func selectItem(at index:Int, animated: Bool = false) {
        
        guard (0..<self.items.count) ~= index else {
            return
        }
        
        selectedIndex = index
        let selectedLabel = labels[selectedIndex]
        
        labels.forEach {
            $0.font = $0.isEqual(selectedLabel) ? Constants.slectedFont : Constants.font
        }

        if animated {
            UIView.animate(withDuration: 0.5) {
                self.thumbView.center = selectedLabel.center
            }
        }
        else {
            self.thumbView.center = selectedLabel.center
        }
    }
    
    
//MARK: - Private functions
    
    private func configView() {
        backgroundColor = UIColor.clear
        
        //Background View
        addSubview(self.backgroundView)
        self.backgroundView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        self.backgroundView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
        self.backgroundView.safeTopAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        self.backgroundView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor).isActive = true
        
        //Stack View
        addSubview(self.stackView)
        self.stackView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor).isActive = true
        self.stackView.safeTrailingAnchor.constraint(equalTo: safeTrailingAnchor).isActive = true
        self.stackView.safeTopAnchor.constraint(equalTo: safeTopAnchor).isActive = true
        self.stackView.safeBottomAnchor.constraint(equalTo: safeBottomAnchor).isActive = true
        
        //Thumb View
        addSubview(self.thumbView)
        
        updateLabels()
    }
    
    private func updateLabels() {
        
        labels.forEach { stackView.removeArrangedSubview($0) }
        labels.removeAll()
        
        for index in 0..<items.count {
            
            let label = UILabel()
            label.heightAnchor.constraint(equalToConstant: stackView.frame.size.height).isActive = true
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = (selectedIndex==index) ? Constants.slectedFont : Constants.font
            label.text = items[index].uppercased()
            
            stackView.addArrangedSubview(label)
            labels.append(label)
        }
    }
}
