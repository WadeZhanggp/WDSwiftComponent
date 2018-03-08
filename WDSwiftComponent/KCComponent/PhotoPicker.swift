//
//  PhotoPicker.swift
//  FuDou4iPhone
//
//  Created by karsa on 16/6/2.
//  Copyright © 2016年 karsa. All rights reserved.
//

import Foundation
import RxCocoa

open class KCPhotoPicker : NSObject {
    static fileprivate let shareInstance = KCPhotoPicker()
    
    fileprivate lazy var imagePicker = UIImagePickerController()
    fileprivate lazy var cameraPicker = UIImagePickerController()
    fileprivate var selectedAction : ((UIImage)->())?
    
    open class func showPhotoCameraSelector(_ showEdit : Bool = true, showAction : @escaping (UIViewController)->(), photoSelectedAction : @escaping (UIImage)->()) {
        let actionSheet = UIActionSheet(title: nil, delegate: nil, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        actionSheet.addButton(withTitle: "拍照")
        actionSheet.addButton(withTitle: "相册")
        KCPhotoPicker.shareInstance.selectedAction = photoSelectedAction
        
        if let window = UIApplication.shared.windows.last {
            actionSheet.show(in: window)
            _=actionSheet.rx.selectedIndex.subscribe(onNext: { (index) in
                if 1 == index {
                    KCPhotoPicker.shareInstance.showCamera(showEdit, showAction: showAction)
                } else if 2 == index {
                    KCPhotoPicker.shareInstance.showPhotoPicker(showEdit, showAction: showAction)
                }
            })
        }
    }
    
    override init() {
        super.init()
    }
    
    fileprivate func showCamera(_ showEdit : Bool, showAction : (UIViewController)->()) {
        if cameraPicker.isBeingPresented || imagePicker.isBeingPresented {
            return
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraPicker.delegate = self
            cameraPicker.sourceType = .camera
            cameraPicker.allowsEditing = showEdit
            showAction(cameraPicker)
        } else {
            let alert = UIAlertView(title: "提示", message: "无法打开相机，请设置相机权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "前往")
            _=alert.rx.buttonClicked.subscribe(onNext: { (index) in
                if index != alert.cancelButtonIndex {
                    if let url = URL.init(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            alert.show()
        }
    }
    
    fileprivate func showPhotoPicker(_ showEdit : Bool, showAction : (UIViewController)->()) {
        if cameraPicker.isBeingPresented || imagePicker.isBeingPresented {
            return
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = showEdit
            showAction(imagePicker)
        } else {
            let alert = UIAlertView(title: "提示", message: "无法读取相册内容，请设置相册权限", delegate: nil, cancelButtonTitle: "取消", otherButtonTitles: "前往")
            _=alert.rx.buttonClicked.subscribe(onNext: { (index) in
                if index != alert.cancelButtonIndex {
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.openURL(url)
                    }
                }
            })
            alert.show()
        }
    }
}

extension KCPhotoPicker : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let action = self.selectedAction {
            var selectedImg : UIImage? = nil
            if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
                selectedImg = img
            } else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
                selectedImg = img
            }
            selectedImg = selectedImg?.fixOrientation()
            picker.dismiss(animated: true, completion: {
                if let img = selectedImg {
                    action(img)
                }
            })
        }
    }
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .downMirrored, .down:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height);
            transform = transform.rotated(by: CGFloat(M_PI));
        case .leftMirrored, .left:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.rotated(by: CGFloat(M_PI_2));
        case .rightMirrored, .right:
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-M_PI_2));
        default:
            break
        }
        
        switch (self.imageOrientation) {
        case .downMirrored, .upMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        case .rightMirrored, .leftMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        default:
            break;
        }
        
        if let cgimage = self.cgImage
            ,let colorSpace = self.cgImage?.colorSpace {
            if let ctx = CGContext.init(data: nil
                , width: Int(self.size.width)
                , height: Int(self.size.height)
                , bitsPerComponent: cgimage.bitsPerComponent
                , bytesPerRow: 0
                , space: colorSpace
                , bitmapInfo: cgimage.bitmapInfo.rawValue) {
                
                ctx.concatenate(transform)
                
                switch (self.imageOrientation) {
                case .rightMirrored, .left, .leftMirrored, .right:
                    ctx.draw(cgimage, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
                default :
                    ctx.draw(cgimage, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height));
                }
                
                if let cgimg = ctx.makeImage() {
                    let img = UIImage(cgImage: cgimg)
                    return img
                }
            }
        }
        
        return self
    }
}
