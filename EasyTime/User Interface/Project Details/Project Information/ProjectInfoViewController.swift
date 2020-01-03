//
//  ProjectInfoViewController.swift
//  EasyTime
//
//  Created by Mobexs on 1/9/18.
//  Copyright © 2018 Mobexs. All rights reserved.
//

import UIKit

fileprivate struct Constants {

    static let buttonText = NSLocalizedString("Add Photo", comment: "")
    static let buttonCornerRadius: CGFloat = 4
    static let buttonBorderColor = UIColor(red: 109 / 255, green: 137 / 255, blue: 175 / 255, alpha: 1)
    static let buttonBorderDashPattern: [NSNumber] = [4, 4]
    static let buttonIconSpacing: CGFloat = 3
    static let statusPickerTitleText = NSLocalizedString("Select status", comment: "")
    static let photosCollectionViewPadding: CGFloat = 10
    static let imageSourcePickerCameraText = NSLocalizedString("Camera", comment: "")
    static let imageSourcePickerLibraryText = NSLocalizedString("Photo Library", comment: "")
    static let imageSourcePickerCancelText = NSLocalizedString("Cancel", comment: "")
    static let photoMaxDimension = 1000.0
    static let projectDescriptionLabelPadding: CGFloat = 12
}

class ProjectInfoViewController: BaseViewController<ProjectInfoViewModel>, UITableViewDelegate, UITableViewDataSource, SectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddPhoto: UIButton!

    @IBOutlet weak var vTableViewHeader: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblbDate: UILabel!

    @IBOutlet weak var vPhotosPlaceholder: UIView!
    @IBOutlet weak var btnAddPhotoSmall: UIButton!
    @IBOutlet weak var cvPhotos: UICollectionView!
    @IBOutlet weak var pcPhotos: UIPageControl!

    lazy var imagePickerController: UIImagePickerController = {

        let controller = UIImagePickerController()
        controller.sourceType = .photoLibrary
        controller.delegate = self
        return controller
    }()

    lazy var imageSourcePicker: UIAlertController = {

        let controller = UIAlertController(title: Constants.buttonText, message: nil, preferredStyle: .actionSheet)
        controller.addAction(UIAlertAction(title: Constants.imageSourcePickerCameraText, style: .default, handler: { action in

            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: Constants.imageSourcePickerLibraryText, style: .default, handler: { action in

            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        controller.addAction(UIAlertAction(title: Constants.imageSourcePickerCancelText, style: .cancel, handler: nil))
        return controller
    }()

    lazy var pvStatus: UIPickerView = {

        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    lazy var btnAddPhotoDashLineLayer: CAShapeLayer = {

        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = Constants.buttonBorderColor.cgColor
        borderLayer.lineDashPattern = Constants.buttonBorderDashPattern
        borderLayer.frame = self.btnAddPhoto.bounds
        borderLayer.fillColor = nil
        borderLayer.cornerRadius = Constants.buttonCornerRadius
        return borderLayer
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblName.text = self.viewModel.job.name
        self.lblDescription.text = self.viewModel.job.information

        if let project = self.viewModel.job as? ETProject, let dateStart = project.dateStart, let dateEnd = project.dateEnd {

            self.lblbDate.text = (dateStart as Date).toDefaultString() + " - " + (dateEnd as Date).toDefaultString()
        }
        else if let date = self.viewModel.job.date {

            self.lblbDate.text = (date as Date).toDefaultString()
        }

        self.tableView.register(UINib(nibName: ProjectInfoTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectInfoTableViewCell.reuseIdentifier)
        self.tableView.register(UINib(nibName: ProjectInfoInstructionsTableViewCell.cellName, bundle: nil), forCellReuseIdentifier: ProjectInfoInstructionsTableViewCell.reuseIdentifier)
        self.tableView.tableHeaderView = self.vTableViewHeader
        self.tableView.tableFooterView = UIView() //To hide separators of empty cells

        self.cvPhotos.layer.cornerRadius = Constants.buttonCornerRadius
        self.cvPhotos.register(UINib.init(nibName: ProjectPhotoCollectionViewCell.cellName, bundle: nil), forCellWithReuseIdentifier: ProjectPhotoCollectionViewCell.reuseIdentifier)

        self.btnAddPhotoSmall.alignVertical(spacing: Constants.buttonIconSpacing)

        if self.viewModel.photos.count == 0 {

            self.btnAddPhoto.layer.addSublayer(self.btnAddPhotoDashLineLayer)
            self.btnAddPhoto.alignVertical(spacing: Constants.buttonIconSpacing)
            self.btnAddPhoto.setTitle(Constants.buttonText, for: .normal)
        }
        else {

            self.btnAddPhoto.removeFromSuperview()
            self.vPhotosPlaceholder.isHidden = false
            self.pcPhotos.numberOfPages = self.viewModel.photos.count
            self.view.setNeedsLayout()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.updateAddPhotoButton()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.viewModel.save()
    }

    override func viewDidLayoutSubviews() {

        self.lblDescription.preferredMaxLayoutWidth = self.view.frame.size.width - Constants.projectDescriptionLabelPadding * 2

        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
            var headerFrame = headerView.frame

            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }

        super.viewDidLayoutSubviews()
        self.updateAddPhotoButton()
    }

    func expandSection(section: Int, isExpanded: Bool) {

        let sectionInfo = self.viewModel[section]
        sectionInfo.isExpanded = isExpanded
        UIView.setAnimationsEnabled(false)
        self.tableView.reloadSections([section], with: .none)
        UIView.setAnimationsEnabled(true)
    }

    func updateAddPhotoButton() {

        if self.viewModel.photos.count == 0 {

            self.btnAddPhotoDashLineLayer.path = UIBezierPath(rect: self.btnAddPhoto.bounds).cgPath
        }
    }

    func updatePhotosPageControl() {

        if self.viewModel.photos.count > 0 {

            let index = Int(self.cvPhotos.contentOffset.x / (self.cvPhotos.contentSize.width / CGFloat(self.viewModel.photos.count)))
            self.pcPhotos.currentPage = index
        }
    }

    //MARK: - Action handlers

    @IBAction func didTapAddPhoto(sender: Any) {

        self.present(self.imageSourcePicker, animated: true, completion: nil)
    }

    @objc func didTapDoneOnStatusPicker(sender: UIButton) {

        self.view.endEditing(true)

        let index = self.pvStatus.selectedRow(inComponent: 0)
        let status = self.viewModel.statuses[index]
        self.viewModel.updateStatus(newStatus: status)
        self.expandSection(section: ProjectInfoSectionType.status.rawValue, isExpanded: false)
    }

    //MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.viewModel[section].numberOfObjects()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell: UITableViewCell?
        let sectionInfo = self.viewModel[indexPath.section]

        if sectionInfo.type == .instructions {

            let instructionsCell = tableView.dequeueReusableCell(withIdentifier: ProjectInfoInstructionsTableViewCell.reuseIdentifier, for: indexPath) as! ProjectInfoInstructionsTableViewCell
            instructionsCell.lblTitle.text = sectionInfo.titleForObject(at: indexPath.row)
            instructionsCell.lblDetail.text = sectionInfo.detailForObject(at: indexPath.row)
            cell = instructionsCell
        }
        else {

            let commonCell = tableView.dequeueReusableCell(withIdentifier: ProjectInfoTableViewCell.reuseIdentifier, for: indexPath) as! ProjectInfoTableViewCell
            commonCell.label?.text = sectionInfo.titleForObject(at: indexPath.row)
            cell = commonCell
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        let sectionInfo = self.viewModel[indexPath.section]
        return (sectionInfo.isExpanded == true && sectionInfo.isHidden == false) ? ProjectInfoTableViewCell.cellHeight : 0
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return self.viewModel[section].isHidden ? 0 : ProjectInfoSectionView.sectionHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let sectionInfo = self.viewModel[section]

        if sectionInfo.isHidden == false {

            let sectionView: ProjectInfoSectionView = UIView.loadFromNib()
            sectionView.delegate = self
            sectionView.sectionIndex = section
            sectionView.isExpanded = sectionInfo.isExpanded
            sectionView.imgIcon.image = UIImage(named: sectionInfo.sectionIcon())
            sectionView.lblTitle.text = sectionInfo.sectionTitle()
            sectionView.imgAccessory.isHidden = !sectionInfo.isClickable

            if sectionInfo.type == .status {

                sectionView.button.inputView = self.pvStatus
                sectionView.button.inputAccessoryView = sectionView.button.keyboardToolbar
                sectionView.button.addDoneOnKeyboardWithTarget(self, action: #selector(ProjectInfoViewController.didTapDoneOnStatusPicker(sender:)), titleText: Constants.statusPickerTitleText)
                sectionView.delegate = nil

                if let status = self.viewModel.statuses.filter({ type -> Bool in
                    return type.typeId == sectionInfo.job.statusId
                }).first {

                    sectionView.lblDetails.text = status.name
                    if let index = self.viewModel.statuses.index(of: status) {

                        self.pvStatus.selectRow(index, inComponent: 0, animated: false)
                    }
                }
            }
            else if sectionInfo.type == .customer {

                sectionView.lblDetails.text = self.viewModel.job.customer?.companyName
            }
            else {

                sectionView.lblDetails.text = nil
            }
            return sectionView
        }
        return nil
    }

    //MARK: - SectionViewDelegate
    func didExpandSectionView(view: ExpandedSectionView) {

        if view.sectionIndex == ProjectInfoSectionType.customer.rawValue,
            let customer = self.viewModel.customer{

            let viewModel = ClientInfoViewModel(customer: customer)
            let controller = ClientInfoViewController(viewModel: viewModel)
            self.navigationController?.pushViewController(controller, animated: true)
            self.expandSection(section: view.sectionIndex, isExpanded: false)
            return 
        }

        self.expandSection(section: view.sectionIndex, isExpanded: true)
    }

    func didCollapseSectionView(view: ExpandedSectionView) {

        self.expandSection(section: view.sectionIndex, isExpanded: false)
    }

    //MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage {

            if self.viewModel.photos.count == 0 {

                self.btnAddPhoto.removeFromSuperview()
                self.vPhotosPlaceholder.isHidden = false
                self.view.setNeedsLayout()
            }
            self.viewModel.addPhoto(photo: photo.scaledImage(maxDimension: Constants.photoMaxDimension))
            self.pcPhotos.numberOfPages = self.viewModel.photos.count
            self.cvPhotos.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return self.viewModel.statuses.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return self.viewModel.statuses[row].name
    }

    //MARK: - UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.viewModel.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectPhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! ProjectPhotoCollectionViewCell
        cell.imageView.image = self.viewModel.photos[indexPath.item]
        return cell
    }

    //MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.vPhotosPlaceholder.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }

    //MARK: - UIScrollViewDelegate

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        if scrollView == self.cvPhotos {

            self.updatePhotosPageControl()
        }
    }
}
