//
//  AuthAPI.swift
//  MoneyPro
//
//  Created by Hau Nguyen Dang on 25/03/2022.
//

import Foundation
import Combine

protocol AuthAPI {
    /**
     Auth
     */
    func login(email: String, password: String) -> Future<AuthResponse?, Never>
    func signUp(email: String, firstname: String, lastname: String, password: String, password_confirm: String) -> Future<AuthResponse?, Never>
    
    /**
     Profile
     */
    func updateProfile(firstname: String, lastname: String, accessToken: String?) -> Future<AuthResponse?, Never>
    func changePassword(current_password: String, password: String, password_confirm: String, accessToken: String?) -> Future<AuthResponse?, Never>
    
    /**
     App Settings
     */
    func getAppSetting(accessToken: String?) -> Future<SiteSettingResponse?, Never>
    func updateAppSettings(site_name: String, site_slogan: String, site_description: String, site_keywords: String, logotype: String, logomark: String, language: String, currency: String, accessToken: String?) -> Future<SiteSettingResponse?, Never>
    
    
    func getEmailSetting(accessToken: String?) -> Future<EmailSettingResponse?, Never>
    func updateEmailSettings(host: String, port: String, encryption: String, auth: Bool, username: String, password: String, from: String, accessToken: String?) -> Future<EmailSettingResponse?, Never>
    
    
    /**
     Categories
     */
    func getListCategory(type: String, search: String, start: Int, length: Int, accessToken: String?) -> Future<CategoryResponse?, Never>
    func updateOrSaveCategory(type: String, category: Category, accessToken: String?) -> Future<CategoryResponse?, Never>
    func deleteCategory(type: String, category: Category, accessToken: String?) -> Future<CategoryResponse?, Never>
    
    /**
     Accounts
     */
    func getListAccount(search: String, start: Int, length: Int, accessToken: String?) -> Future<AccountResponse?, Never>
    func updateOrSaveAccount(account: Account, accessToken: String?) -> Future<AccountResponse?, Never>
    func deleteAccount(account: Account, accessToken: String?) -> Future<AccountResponse?, Never>
    
    
    /**
     Goals
     */
    func getListGoal(status: Int, search: String, start: Int, length: Int, dateFrom: Date, dateTo: Date, accessToken: String?) -> Future<GoalResponse?, Never>
    func updateOrSaveGoal(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never>
    func deleteGoal(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never>
    func addDeposit(goal: Goal, accessToken: String?) -> Future<GoalResponse?, Never>
    
    
    /**
     Budget
     */
    func getListBudget(search: String, start: Int, length: Int, accessToken: String?) -> Future<BudgetResponse?, Never>
    func updateOrSaveBudget(budget: Budget, month: MonthItem, year: YearItem, accessToken: String?) -> Future<BudgetResponse?, Never>
    func deleteBudget(budget: Budget, accessToken: String?) -> Future<BudgetResponse?, Never>
    func getTransactionByDate(budget: Budget, accessToken: String?) -> Future<BudgetResponse?, Never>
    
    
    /**
     User
     */
    func getListUser(search: String, start: Int, length: Int, accessToken: String?) -> Future<UserResponse?, Never>
    func updateOrSaveUser(user: User, accessToken: String?) -> Future<UserResponse?, Never>
    func deleteUser(user: User, accessToken: String?) -> Future<UserResponse?, Never>
    
    
    /**
     Report
     */
    func getDataIncomeVsExpense(type: String, date: BarChartDateType, accessToken: String?) -> Future<ReportTotalResponse?, Never>
    func getListCategoryInTime(type: MoneyType, date: BarChartDateType, accessToken: String?) -> Future<CategoryReportTotalResponse?, Never>
    
    
    func getTotalTransaction(type: MoneyType, accessToken: String?) -> Future<TransactionReportTotalResponse?, Never>

    /**
     Transaction
     */
    func getReportListTransaction(type: MoneyType, search: String, date: ReportDate, category: Int, start: Int, length: Int, accessToken: String?) -> Future<TransactionResponse?, Never>
    func getLatestListTransaction(type: MoneyType, start: Int, length: Int, accessToken: String?) -> Future<TransactionResponse?, Never>

    func updateOrSaveTransaction(type: MoneyType, transaction: Transaction, accessToken: String?) -> Future<TransactionResponse?, Never>
    func deleteTransaction(transaction: Transaction, accessToken: String?) -> Future<TransactionResponse?, Never>

    
}
