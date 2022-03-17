//
//  Stockage.swift
//  iTravel
//
//  Created by Kyphun Lepeule on 07/02/2022.
//

import Foundation
import FirebaseStorage

class Stockage {
    func addImage(reference: StorageReference, data: Data, completion: SuccessCompletion?) {
        reference.putData(data, metadata: nil) { (meta, error) in
            if error == nil {
                reference.downloadURL(completion: { (url, error) in
                    if error == nil, let urlString = url?.absoluteString {
                        completion?(true, urlString)
                    } else {
                        completion?(false, error?.localizedDescription)
                    }
                })
            } else {
                completion?(false, error!.localizedDescription)
            }
        }
    }
}
