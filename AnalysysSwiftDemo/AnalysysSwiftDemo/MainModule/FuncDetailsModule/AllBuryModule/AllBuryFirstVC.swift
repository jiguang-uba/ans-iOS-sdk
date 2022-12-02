//
//  AllBuryFirstVC.swift
//  AnalysysSwiftDemo
//
//  Created by xiao xu on 2020/7/22.
//  Copyright © 2020 xiao xu. All rights reserved.
//

import UIKit

class AllBuryFirstVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var lab_gesture: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.lab_gesture.isUserInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(label_tap_action))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.lab_gesture.addGestureRecognizer(tap)
    }
    
    func showSystemPhoto() -> Void {
        weak var weakSelf = self
        let alert: UIAlertController = UIAlertController(title: "选取图片", message: nil, preferredStyle: .actionSheet)
        let cameraAction: UIAlertAction = UIAlertAction(title: "相机", style: .default) { (action) in
            let imagePicker: UIImagePickerController = UIImagePickerController()
            imagePicker.delegate = weakSelf
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .rear
            self.present(imagePicker, animated: true) {
                //
            }
        }
        
        let photosAlbumAction: UIAlertAction = UIAlertAction(title: "图片", style: .default) { (action) in
            let photos: UIImagePickerController = UIImagePickerController()
            photos.delegate = weakSelf
            photos.allowsEditing = true
            photos.sourceType = .photoLibrary
            self.present(photos, animated: true) {
                //
            }
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .default) { (action) in
            //
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        alert.addAction(photosAlbumAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true) {
            //
        }
    }
    
    @IBAction func analysys_photo_action(_ sender: Any) {
        self.showSystemPhoto()
    }
    @objc func label_tap_action() {
        
    }
    
    @IBAction func anlysys_step_action(_ sender: Any) {
    }
    @IBAction func analysys_seg_action(_ sender: Any) {
    }
    
    @IBAction func analysys_switch_action(_ sender: Any) {
        
        AnalysysHUD.show(title: "提示", message: "AnalysysSwitch - click")
        
    }
    @IBAction func analysys_btn_action(_ sender: Any) {
        
        AnalysysHUD.show(title: "提示", message: "AnalysysButton - click")
        
    }
    
    @IBAction func to_all_bury_second(_ sender: Any) {
        
        let allBurySecondVC: AllBurySecondVC = AllBurySecondVC()
        self.navigationController?.pushViewController(allBurySecondVC, animated: true)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
