//
//  UIViewControllerAlert.swift
//  JhMemo
//
//  Created by 김지호 on 2021/07/07.
//

import UIKit

extension UIViewController{
    
    func alert(title : String = "알림" , message : String)  {
        // alert 설정 (타이틀 , 메세지 , 스타일)
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // 버튼의 이름 스타일 탭했을때 일어날 이벤트
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
     
        // Attaches an action object to the alert or action sheet.
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
