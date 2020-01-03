//
//  General.swift
//  easyService
//
//  Created by Yury Ramazanov on 05/05/2017.
//  Copyright © 2017 Mobexs. All rights reserved.
//

import UIKit

extension UIColor {
    static let et_blueColor = UIColor(red: 62/255, green: 142/255, blue: 215/255, alpha: 1.0)
    static let et_borderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 0.4)
    static let et_shadowColor = UIColor(red: 191 / 255, green: 203 / 255, blue: 220 / 255, alpha:1.0)
}

private var AssociatedObjectHandle: UInt8 = 0

extension UIImage {

    func scaledImage(maxDimension: Double) -> UIImage {

        let current = max(self.size.width, self.size.height)
        if current > CGFloat(maxDimension) {

            let scale = CGFloat(maxDimension) / current
            let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0);
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            if let newImage = UIGraphicsGetImageFromCurrentImageContext() {

                UIGraphicsEndImageContext();
                return newImage
            }

            UIGraphicsEndImageContext();
            return self
        }
        else {

            return self
        }
    }
}

extension UIView {

    open override var inputViewController: UIInputViewController? {
        get {

            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? UIInputViewController
        }
        set(newValue) {
            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    class func loadFromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadFromNib () -> UIView? {
        return Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? UIView
    }
    
    func getFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for subView in self.subviews {
            if let responder = subView.getFirstResponder() {
                return responder
            }
        }
        
        return nil
    }

    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        } else {
            return self.topAnchor
        }
    }

    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        }else {
            return self.leadingAnchor
        }
    }

    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.trailingAnchor
        }else {
            return self.trailingAnchor
        }
    }

    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        } else {
            return self.bottomAnchor
        }
    }
}

extension Date {
    func toString(_ format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toRelativeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
    
    func toDefaultString() -> String {
        return toString(AppConstants.defaultDateFormat)
    }
        
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 1, second: -1), to: self.startOfDay)!
    }
    
    var startOfWeek: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfWeek: Date {
        return Calendar.current.date(byAdding: DateComponents(day: 7, second: -1), to: self.startOfWeek)!
    }
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, second: -1), to: self.startOfMonth)!
    }
}

extension Bundle {
    class var appName: String {
        get{
            return main.object(forInfoDictionaryKey: "CFBundleName") as! String
        }
    }
    
    class var appVersion: String {
        get {
            return main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        }
    }
}

extension String {

    mutating func append(_ string: String?, separator: String) {

        if let string = string {

            if self.count > 0, string.count > 0 {

                self.append(separator)
            }
            self.append(string)
        }
    }
}

extension UIButton {

    func alignVertical(spacing: CGFloat = 12.0) {

        guard let imageSize = self.imageView?.image?.size,
            let text = self.titleLabel?.text,
            let font = self.titleLabel?.font
            else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

extension FileManager {
    func documentPath(folder folderName:String, file fileName:String? = nil) -> URL? {
        do {
            let docDir = try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let folderUrl = docDir.appendingPathComponent(folderName)
            
            if !self.fileExists(atPath: folderUrl.path) {
                try self.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            }
            
            guard let fileName = fileName else {
                return folderUrl
            }
            
            let filePath = folderUrl.appendingPathComponent(fileName)
            return filePath
        }
        catch {
            return nil
        }
    }
}

extension UIViewController {
    
    func showMessage(message: String, withTitle title: String? = AppConstants.appName, completion: (() -> Swift.Void)? = nil ) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { action in
            completion?()
        })
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showMessage(withError error: Error) {
        self.showMessage(message: error.localizedDescription)
    }

    public static func topMostViewController() -> UIViewController? { //TODO:

        guard let keyWindow = UIApplication.shared.keyWindow else { return nil }

        if var topViewController = keyWindow.rootViewController?.childViewControllers.first {

            if let selectedViewController = (topViewController as? UITabBarController)?.selectedViewController {

                topViewController = selectedViewController
            }

            if let visibleViewController = (topViewController as? UINavigationController)?.visibleViewController {

                topViewController = visibleViewController
            }

            while let childViewController = topViewController.childViewControllers.first {

                topViewController = childViewController
            }

            return topViewController
        }

        return nil
    }
}
