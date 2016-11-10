//
//  PaymentTableView.swift
//  mala-ios
//
//  Created by 王新宇 on 2/29/16.
//  Copyright © 2016 Mala Online. All rights reserved.
//

import UIKit

class PaymentTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - ReuseId
    private let paymentAmountCellIdentifier = "paymentAmountCellIdentifier"
    private let paymentChannelCellIdentifier = "paymentChannelCellIdentifier"
    private let malaBaseCellIdentifier = "malaBaseCellIdentifier"
    
    
    // MARK: - Property
    private var currentSelectedIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    
    // MARK: - Constructed
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private Method
    private func configure() {
        dataSource = self
        delegate = self
        bounces = false
        separatorStyle = .none
        
        register(PaymentAmountCell.self, forCellReuseIdentifier: paymentAmountCellIdentifier)
        register(PaymentChannelCell.self, forCellReuseIdentifier: paymentChannelCellIdentifier)
        register(MalaBaseCell.self, forCellReuseIdentifier: malaBaseCellIdentifier)
    }
    
    
    // MARK: - DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : MalaConfig.paymentChannelAmount()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 模式匹配
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            // 应付金额
            let cell = (tableView.dequeueReusableCell(withIdentifier: paymentAmountCellIdentifier, for: indexPath)) as! PaymentAmountCell
            return cell
            
        case (1, 0):
            // 支付宝
            let cell = (tableView.dequeueReusableCell(withIdentifier: paymentChannelCellIdentifier, for: indexPath)) as! PaymentChannelCell
            cell.model = MalaConfig.malaPaymentChannels()[0]
            cell.isSelected = true
            currentSelectedIndexPath = indexPath
            return cell
            
        case (1, 1):
            // 微信支付
            let cell = (tableView.dequeueReusableCell(withIdentifier: paymentChannelCellIdentifier, for: indexPath)) as! PaymentChannelCell
            cell.model = MalaConfig.malaPaymentChannels()[1]
            return cell
        case (1, 2):
            // 家长代付
            let cell = (tableView.dequeueReusableCell(withIdentifier: paymentChannelCellIdentifier, for: indexPath)) as! PaymentChannelCell
            cell.model = MalaConfig.malaPaymentChannels()[2]
            cell.hideSeparator()
            return cell
        default:
            let cell = (tableView.dequeueReusableCell(withIdentifier: malaBaseCellIdentifier, for: indexPath)) as! MalaBaseCell
            return cell
        }
    }

    
    // MARK: - Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 47 : 66
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 33 : 8
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 1 ? PaymentChannelSectionHeaderView() : UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 所有操作结束弹栈时，取消选中项
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        // 当选择支付方式时
        guard indexPath.section == 1 else {
            return
        }
        
        // 切换支付方式
        tableView.cellForRow(at: currentSelectedIndexPath)?.isSelected = false
        currentSelectedIndexPath = indexPath
        let cell = tableView.cellForRow(at: indexPath) as? PaymentChannelCell
        cell?.isSelected = true
        
        // 更改订单模型 - 支付方式
        MalaOrderObject.channel = cell?.model?.channel ?? .Other
    }
}
