//
//  MemoListTableViewController.swift
//  JhMemo
//
//  Created by 김지호 on 2021/07/06.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    // 클로져를 통한 DateFormatter 설정
    let formatter : DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DataManager.shared.fetchMemo()
        tableView.reloadData()
        //        tableView.reloadData() // 리로드해준다~ 최신으로 업데이트
        //        print(#function)
    }
    
    var token : NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // 다음 컨트롤러로 넘기기전 현 컨트롤러에서 전해줘야할 동작들을 준비해준다
        
        if let cell = sender as? UITableViewCell , let indexPath = tableView.indexPath(for: cell){
            if let vc = segue.destination as? DetailViewController {
//                vc.memo = Memo.dummyMemoList[indexPath.row]
                vc.memo = DataManager.shared.memoList[indexPath.row]
                // detailViewContoroller에 memo객체 데이터 전달
            }
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       token = NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { (noti) in
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return Memo.dummyMemoList.count
        return DataManager.shared.memoList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 사용한 셀 가져오기
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        // 표시할 데이터 가져오기
        //        The value of the row element of the index path.
//        let target = Memo.dummyMemoList[indexPath.row]
        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
//        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        cell.detailTextLabel?.text = target.insertDate
        // date인스턴스를 텍스트형으로 전환 decription
        
        return cell
    }
    
    
   
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
    
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
        let target = DataManager.shared.memoList[indexPath.row]
        DataManager.shared.deleteMemo(target)
        DataManager.shared.memoList.remove(at: indexPath.row)
        //테이블 뷰 셀 숫자와 일치해야 하므로 리스트 배열에서도 삭제하고자하는 인덱스를 삭제해야함 크래쉬 발생했었음
        
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
        
        
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
