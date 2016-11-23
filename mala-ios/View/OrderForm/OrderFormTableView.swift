//
//  OrderFormTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 16/5/13.
//  Copyright © 2016年 Mala Online. All rights reserved.
//

import UIKit

let OrderFormCellReuseId = [
    0: "OrderFormStatusCellReuseId",            // 订单状态及信息
    1: "OrderFormTimeScheduleCellReuseId",      // 上课时间
    2: "OrderFormPaymentChannelCellReuseId",    // 支付方式
    3: "OrderFormOtherInfoCellReuseId"          // 其他信息
]

class OrderFormTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Property
    /// 订单详情模型
    var model: OrderForm? {
        didSet {
            println("当前支付渠道信息： \(model?.chargeChannel)")
            // 若订单状态为[待支付]或[已关闭]，隐藏支付渠道Cell
            self.shouldHiddenPaymentChannel = model?.orderStatus == .canceled || model?.orderStatus == .penging
            
            // 刷新数据渲染UI
            ThemeHUD.showActivityIndicator()
            self.reloadData()
            delay(0.5) {
                self.shouldHiddenTimeSlots = false
                self.reloadSections(IndexSet(integer: 1), with: .fade)
                ThemeHUD.hideActivityIndicator()
            }
        }
    }
    // 是否隐藏时间表
    var shouldHiddenTimeSlots: Bool = true
    // 是否隐藏支付渠道Cell
    var shouldHiddenPaymentChannel: Bool = false
    

    // MARK: - Instance Method
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        delegate = self
        dataSource = self
        backgroundColor = MalaColor_F2F2F2_0
        estimatedRowHeight = 500
        separatorStyle = .none
        
        register(OrderFormStatusCell.self, forCellReuseIdentifier: OrderFormCellReuseId[0]!)
        register(OrderFormTimeScheduleCell.self, forCellReuseIdentifier: OrderFormCellReuseId[1]!)
        register(OrderFormPaymentChannelCell.self, forCellReuseIdentifier: OrderFormCellReuseId[2]!)
        register(OrderFormOtherInfoCell.self, forCellReuseIdentifier: OrderFormCellReuseId[3]!)
    }
    
    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 12 : 6
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == (OrderFormCellReuseId.count-1) ? 12 : 6
    }
    
    
    // MARK: - DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = shouldHiddenPaymentChannel ? OrderFormCellReuseId.count-1 : OrderFormCellReuseId.count
        count = model?.orderStatus == .confirm ? OrderFormCellReuseId.count-2 : count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let sectionIndex = (indexPath.section >= 2 && shouldHiddenPaymentChannel) ? indexPath.section+1 : indexPath.section
        
        let reuseCell = tableView.dequeueReusableCell(withIdentifier: OrderFormCellReuseId[sectionIndex]!, for: indexPath)
        reuseCell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let cell = reuseCell as! OrderFormStatusCell
            cell.model = self.model
            return cell
            
        case 1:
            let cell = reuseCell as! OrderFormTimeScheduleCell
            cell.classPeriod = self.model?.hours ?? 0
            cell.timeSchedules = self.model?.timeSlots
            cell.shouldHiddenTimeSlots = self.shouldHiddenTimeSlots
            return cell
            
        case 2:
            // 若隐藏支付渠道Cell，则显示支付信息Cell
            if shouldHiddenPaymentChannel {
                let cell = reuseCell as! OrderFormOtherInfoCell
                cell.model = self.model
                return cell
            }else {
                let cell = reuseCell as! OrderFormPaymentChannelCell
                cell.channel = (self.model?.channel ?? .Other)
                return cell
            }

        case 3:
            let cell = reuseCell as! OrderFormOtherInfoCell
            cell.model = self.model
            return cell
            
        default:
            break
        }
        
        return reuseCell
    }
    
    
    deinit {
        println("OrderFormTableView deinit")
    }
}
