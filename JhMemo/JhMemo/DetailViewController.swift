//
//  DetailViewController.swift
//  JhMemo
//
//  Created by 김지호 on 2021/07/07.
//

import UIKit

class DetailViewController: UIViewController {
    
    var memo : Memo?
    
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            cell.textLabel?.text = formatter.string(from:memo?.insertDate ?? Date())
            return cell
        default: fatalError()
        }
    }
    
    
} // EXTENSION
