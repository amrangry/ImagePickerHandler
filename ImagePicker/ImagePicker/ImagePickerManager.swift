//
//  ImagePickerManager.swift
//  ImagePicker
//
//  Created by Amr ELghadban on 7/15/18.
//  Copyright © 2018 ADKA. All rights reserved.
//

import UIKit

class ImagePickerHandler: NSObject {

    // MARK: - picker Configuartion

    var pickerTitle: String = "Choose Image"
    var pickerCamerTitle: String = "Camera"
    var pickerGalleryTitle: String = "Gallary"
    var pickerCancelTitle: String = "Cancel"

    // callBack clouser can hold the choosen image or return with nil in case of canecl by user
    var pickImageCallback: ((UIImage?) -> ())?

    // MARK: - picker Configuartion

    var warningAlertTitle = "Warning!"
    var warningAlertMessage = "You don't have camera"
    var warningAlertCloseButtonTitle = "Ok"

    // MARK: - private varibles

    private var picker: UIImagePickerController?
    private var alert: UIAlertController?
    private var viewController: UIViewController?

    override init() {
        super.init()
    }

    private func setupUIImagePicker() -> UIImagePickerController {
        return UIImagePickerController()
    }

    private func setupAlertController() -> UIAlertController {
        return UIAlertController(title: pickerTitle, message: nil, preferredStyle: .actionSheet)
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage?) -> ())) {
        let cameraAction = UIAlertAction(title: pickerCamerTitle, style: .default) {
            _ in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: pickerGalleryTitle, style: .default) {
            _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: pickerCancelTitle, style: .cancel) {
            _ in
        }

        let imagePicker = setupUIImagePicker()
        let alertView = setupAlertController()

        pickImageCallback = callback
        self.viewController = viewController
        imagePicker.delegate = self

        // Add the actions
        alertView.addAction(cameraAction)
        alertView.addAction(gallaryAction)
        alertView.addAction(cancelAction)
        alertView.popoverPresentationController?.sourceView = viewController.view

        picker = imagePicker
        alert = alertView

        viewController.present(alertView, animated: true, completion: nil)
    }

    func openCamera() {
        alert?.dismiss(animated: true, completion: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            guard let pickerController = picker else {
                assertionFailure("Picker is nil")
                return
            }
            picker?.sourceType = .camera
            viewController?.present(pickerController, animated: true, completion: nil)
        } else {
            let warningAlert = UIAlertController(title: warningAlertTitle, message: warningAlertMessage, preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: warningAlertCloseButtonTitle, style: .cancel) {
                _ in
            }

            warningAlert.addAction(cancelAction)

            viewController?.present(warningAlert, animated: true, completion: nil)
        }
    }

    func openGallery() {
        alert?.dismiss(animated: true, completion: nil)
        guard let pickerController = picker else {
            assertionFailure("Picker is nil")
            return
        }
        picker?.sourceType = .photoLibrary
        viewController?.present(pickerController, animated: true, completion: nil)
    }
}

extension ImagePickerHandler: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: {
            self.pickImageCallback?(nil)
        })
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        picker.dismiss(animated: true, completion: {
            self.pickImageCallback?(image)
        })
    }

    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}
