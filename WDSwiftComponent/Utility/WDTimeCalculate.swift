//
//  WDTimeCalculate.swift
//  WDSwiftComponent
//
//  Created by zhangguangpeng on 2017/11/7.
//  Copyright © 2017年 zhangguangpeng. All rights reserved.
//

import UIKit

class WDTimeCalculate: NSObject {
    
    //消息时间或者直播时间
    class func timeTransForm(time: Double, isMessage: Bool) -> String {
        
        let today = NSDate()
        let date = NSDate.init(timeIntervalSince1970: (time/1000))
        let nDays = self.numberOfDays(startDate: date, endDate: today)
        var formater = DateFormatter()
        if isMessage {
            if nDays < 1 {
                formater.dateFormat = "HH:mm"
                return formater.string(from: date as Date)
                
            }else {
                formater.dateFormat = "yyyy-MM-dd HH:mm"
                return formater.string(from: date as Date)
            }
        }else {
            formater.dateFormat = "yyyy年MM月dd日 HH:mm"
            return formater.string(from: date as Date)
        }
        
    }
    
    //将double时间转换成date
    func timeTransFromDate(time: Double) -> NSDate {
        let date = NSDate.init(timeIntervalSince1970: (time/1000))
        return date
    }
    
    //计算距离当前时间
    class func timeDifferenceWithNow(time: Double) -> String {
        
        let startDate = NSDate.init(timeIntervalSince1970: (time/1000))
        let today = NSDate()
        let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        cal?.locale = NSLocale.current
        let startHours = cal?.ordinality(of: NSCalendar.Unit.minute, in: NSCalendar.Unit.era, for: startDate as Date)
        let endHour = cal?.ordinality(of: NSCalendar.Unit.minute, in: NSCalendar.Unit.era, for: today as Date)
        var differenceHour = endHour! - startHours!
        if differenceHour < 0 {
            differenceHour = -differenceHour
        }
        if differenceHour <= 24 * 60 && differenceHour >= 60{
            let huors = differenceHour / 60
            let min = differenceHour % 60
            return "\(huors)小时\(min)分钟"
        }else if differenceHour < 60 && differenceHour > 1{
            return "\(differenceHour)分钟"
        }else if differenceHour <= 1 && differenceHour >= 0 {
            return "1分钟"
        }else {
            let days = differenceHour/(24 * 60)
            let hours = (differenceHour%(24 * 60))/60
            if hours == 0 {
                return "\(days)天"
            }else {
                return "\(days)天\(hours)小时"
            }
            
        }
        
    }
    
    //计算时间差
    class func numberOfDays(startDate: NSDate, endDate: NSDate) -> NSInteger {
        
        let cal = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))
        cal?.locale = NSLocale.current
        let startDays = cal?.ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.era, for: startDate as Date)
        let endDays = cal?.ordinality(of: NSCalendar.Unit.day, in: NSCalendar.Unit.era, for: endDate as Date)
        return endDays! - startDays!
    }
    
    //语音时间
    class func getTimeWithSecond(time: Int64) -> String {
        
        let m = time / 60
        let s = time % 60
        var timeStr = "\(m):\(s)"
        if s < 10 {
            timeStr = "\(m):0\(s)"
        }
        return timeStr
        
    }
    
    class func getCurrentTimeInterval() -> Int64 {
        
        let date = NSDate()
        let timeInterval = date.timeIntervalSince1970 * 1000
        return Int64(timeInterval)
        
    }
    
    
}
