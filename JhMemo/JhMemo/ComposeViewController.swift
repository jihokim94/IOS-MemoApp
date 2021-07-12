//
//  ComposeViewController.swift
//  JhMemo
//
//  Created by 김지호 on 2021/07/06.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    var editTarget : Memo?
    var originalContent : String?
    
    @IBAction func close(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil) // 프레젠트 모달창을 끌때 쓰는 메소드
        
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        guard let memo = memoTextView.text ,
              memo.count > 0 else {
            // 메모장 텍스트 에어리에가 비어있을 경우
            alert(message: "메모를 입력하세요")
            return
        }
        
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        if let target = editTarget { // 편집일 경우
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidUpdate, object: nil)
        } else { // 일반적인 메모 추가 경우
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
    //Dismisses the view controller that was presented modally by the view controller.
        dismiss(animated: true, completion: nil)
        
    }
    
    // 노티피케이션 토큰
    var willShowToken : NSObjectProtocol?
    var willHideToken : NSObjectProtocol?
    
    // 키보드 옵저버 제거
    deinit {
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Asks UIKit to make this object the first responder in its window.
        memoTextView.becomeFirstResponder() // 히히
        
        navigationController?.presentationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        memoTextView.resignFirstResponder()
        navigationController?.presentationController?.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        로딩 될때 수정하는 객체의 여부에 따라 모달창 설정
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
            originalContent = memo.content
        } else {
            navigationItem.title = "새 메모"
            memoTextView.text = ""
        }
        // Do any additional setup after loading the view.
        memoTextView.delegate = self
        
        //옵저버 생성 및 메모내용 하단에 키보드가 화면가 겹치지 않게 마진주기
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self](noti) in
            guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.verticalScrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else { return }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.verticalScrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
            
            
        })
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
extension ComposeViewController {
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidUpdate = Notification.Name(rawValue: "memoDidUpdate")
}
