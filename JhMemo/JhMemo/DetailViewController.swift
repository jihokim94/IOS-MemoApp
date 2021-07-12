//
//  DetailViewController.swift
//  JhMemo
//
//  Created by 김지호 on 2021/07/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memo : Memo?
    
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    @IBAction func share(_ sender: Any) {
        guard let memo = memo?.content else {
            return
        }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] (action) in
            DataManager.shared.deleteMemo(self?.memo) // 데이터에서 삭제
            
            //Pops the top view controller from the navigation stack and updates the display.
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }
    
    var token :NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidUpdate, object: nil, queue: OperationQueue.main, using: { [weak self](noti) in
            self?.memoTableView.reloadData()
        })
        // Do any additional setup after loading the view.
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


extension DetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 표시할 테이블 숫자
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //인덱스에 따라 표시 할 데이터 넣기
        switch indexPath.row {
        case 0:
            //특정 테이블셀 접근
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            //접근한 테이블셀에 원하는 데이터 넣기
            cell.textLabel?.text = memo?.content
            print(memo?.content ?? 1)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
//            cell.textLabel?.text = formatter.string(from:memo?.insertDate ?? Date())
            cell.textLabel?.text = memo?.insertDate
            return cell
        default: fatalError()
        }
    }
    
    
} // EXTENSION
