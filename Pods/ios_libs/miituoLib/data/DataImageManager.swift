//
//  DataImageManager.swift
//  miituo
//
//  Created by John Alexis Cristobal Jimenez  on 09/09/21.
//  Copyright © 2021 John A. Cristobal. All rights reserved.
//

import Foundation
import Alamofire

class DataImageManager{

    static let sharedImage = DataImageManager()
    
    func sendPhotoCar(sendThisImage: Bool, rowsel: Int, imagenn:UIImage, idpic:String, completion: @escaping (String) -> Void){

        if sendThisImage{
            let comrimidad = compressImage(image: imagenn)
            let tok = arreglo[rowsel]["token"]!

            let parameters = ["Type": idpic,"PolicyId":arregloPolizas[rowsel]["idpoliza"] ,"PolicyFolio":arregloPolizas[rowsel]["nopoliza"]]
            let head : HTTPHeaders = ["Authorization": tok,"Content-Type":"application/json"]

            var data : String = ""
            data += "\(idpic),"
            
            if let polizaid = arregloPolizas[rowsel]["idpoliza"]{
                data += "\(polizaid),"
            }
            if let polizafolio = arregloPolizas[rowsel]["nopoliza"]{
                data += "\(polizafolio)"
            }
                    
            //Alamofire to upload image
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(comrimidad, withName: "image",fileName: "file\(idpic).jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            },to:"\(ip)ImageSendProcess/Array/",headers:head).responseJSON { (result) in

                if result.error != nil {                    
                    completion("error")
                }
                
                switch result.result {
                case .success(_):
                    completion("ok")
                    
                case .failure(let encodingError):
                    print("error \(encodingError)")
                    completion("error")
                }
            }
        } else {
            completion("ok")
        }
    }
    
//************************ compress image and get data***************************//
    func compressImage(image:UIImage) -> Data {
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = image.size.height
        var actualWidth : CGFloat = image.size.width
        let maxHeight : CGFloat = image.size.height/1//300
        let maxWidth : CGFloat = image.size.width/1//400.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        //var rect = CGRect(0.0, 0.0, actualWidth, actualHeight);
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: actualWidth, height: actualHeight));
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        let imageData = img!.jpegData(compressionQuality: 0.9);
        UIGraphicsEndImageContext();
        
        return imageData!
    }
}
