//
//  main.swift
//  LeetCode
//
//  Created by iMac on 2019/4/25.
//  Copyright © 2019 iMac. All rights reserved.
//

import Foundation

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

class Solution {
    
    // 1. 两数之和
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var map: [Int: Int] = [:]
        for (index, num) in nums.enumerated() {
            let value = target - num
            if map.contains(where: { $0.key == value }) {
                return [map[value]!, index];
            }
            map[num] = index
        }
        return []
    }
    
    
    // 2. 两数相加
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var node1 = l1, node2 = l2
        var node: ListNode?, last_node: ListNode?
        var flag = 0
        while node1 != nil || node2 != nil {
            let tmp = (node1?.val ?? 0) + (node2?.val ?? 0) + flag
            flag = tmp / 10
            let next_node = ListNode(tmp % 10)
            if node == nil {
                node = next_node
            }
            else {
                last_node?.next = next_node
            }
            last_node = next_node
            
            node1 = node1?.next
            node2 = node2?.next
        }
        if flag >= 1 {
            last_node?.next = ListNode(flag)
        }
        return node
    }
    
    
    // 3. 无重复字符的最长子串
    func lengthOfLongestSubstring(_ s: String) -> Int {
        var longest = 0
        var current_str = ""
        
        for character in s {
            let index = current_str.firstIndex(where: { $0 == character })
            if let idx = index {
                let offset = current_str.index(after: idx)
                longest = max(longest, current_str.count)
                current_str = String(current_str[offset..<current_str.endIndex])
            }
            current_str.append(character)
        }
        longest = max(longest, current_str.count)
        return longest
    }
    
    
    // 4. 寻找两个有序数组的中位数
    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        var nums: [Int] = []
        var index1 = 0
        var index2 = 0
        let count = (nums1.count + nums2.count) / 2 + 1
        while nums.count < count {
            
            if index1 == nums1.count {
                for _ in 0..<count-nums.count {
                    nums.append(nums2[index2])
                    index2 += 1
                }
                break
            }
            
            if index2 == nums2.count {
                for _ in 0..<count-nums.count {
                    nums.append(nums1[index1])
                    index1 += 1
                }
                break
            }
            
            if nums1[index1] <= nums2[index2] {
                nums.append(nums1[index1])
                index1 += 1
            }
            else {
                nums.append(nums2[index2])
                index2 += 1
            }
        }
        
        return (nums1.count + nums2.count) % 2 == 1 ? Double(nums.last!)
            : Double(nums[nums.count-2] + nums.last!) / 2.0
    }
    
    
    // 5. 最长回文子串
    func longestPalindrome(_ s: String) -> String {
        guard s.count > 1 else {
            return s
        }
        
        var str = ""
        
        for i in 0..<s.count {
            let idx = String.Index(utf16Offset: i, in: s)
            str.append(String(s[idx]))
            str.append("#")
        }
        
        var p: [Int] = [1]
        var ct = 0         // 中心位置
        var mr = 1         // 回文字串的最大右边界
        
        var chars = [Character](str)
        
        
        for i in 1..<str.count {
            let val = mr > i ? min(p[2 * ct - i], mr-i) : 1  // p[i]的值为其对称的值p[j]和右边界到i的值的最小值
            p.append(val)
            
            // 如果对称位置的字符相等则加1
            while i-p[i] >= 0
                && i+p[i] < chars.count
                && chars[i-p[i]] == chars[i+p[i]] {
                    p[i] += 1
            }
            
            // 更新中心位置和最大右边界位置
            if i + p[i] > mr {
                mr = i + p[i]
                ct = i
            }
        }
        
        if let val = p.max() {
            let index = p.firstIndex(of: val)
            let start = String.Index(utf16Offset: (index! - val + 1), in: str)
            let end = String.Index(utf16Offset: (index! + val), in: str)
            return String(str[start..<end]).replacingOccurrences(of: "#", with: "")
        }
        
        return ""
    }
    
    
    // 6. Z 字形变换
    func convert(_ s: String, _ numRows: Int) -> String {
        guard numRows > 1 && s.count > numRows else {
            return s
        }
        
        let charaters = [Character](s)
        var result: [Character] = []
        
        let rp = numRows * 2 - 2
        for i in 0..<numRows {
            
            var begin = i
            while begin < s.count {
                
                result.append(charaters[begin])
                
                let next = begin + (numRows - i - 1) * 2
                if i != 0 && i != numRows-1 && next < s.count {
                    result.append(charaters[next])
                }
                
                begin += rp
            }
            
        }
        
        return String(result)
    }
    
    
    // 7. 整数反转
    func reverse(_ x: Int) -> Int {
        var a = abs(x)
        var sum = 0
        while a > 0 {
            sum = sum * 10 + (a % 10)
            a = a / 10
        }
        
        if sum < -(1 << 31) || sum > (1 << 31)-1 {
            return 0
        }
        
        
        if x < 0 {
            return -sum
        }
        
        return sum
    }
    
    
    // 8. 字符串转换整数 (atoi)
    func myAtoi(_ str: String) -> Int {
        var sum = 0
        var flag = 0
        var valid = 1
        let map = ["0" : 0, "1" : 1, "2" : 2, "3" : 3, "4" : 4,
                   "5" : 5, "6" : 6, "7" : 7, "8" : 8, "9" : 9]
        for c in str {
            if valid == 1 && c == " " {
                continue
            }
            if valid == 1 && c == "-" {
                flag = 1
                valid = 0
                continue
            }
            if valid == 1 && c == "+" {
                valid = 0
                continue
            }
            if c >= "0" && c <= "9" {
                sum = sum * 10 + map[String(c)]!
                valid = 0
                if sum > 1<<31 {
                    break
                }
            }
            else {
                break
            }
        }
        
        if flag == 1 {
            sum = -sum
        }
        
        if sum < -1<<31 {
            sum = -1<<31
        }
        else if sum > (1<<31)-1 {
            sum = (1<<31)-1
        }
        
        return sum
    }
    
    
    // 9. 回文数
    func isPalindrome(_ x: Int) -> Bool {
        let str = "\(x)"
        return str == String(str.reversed())
    }
    
    
    // 11. 盛最多水的容器
    func maxArea(_ height: [Int]) -> Int {
        var l = 0, r = height.count-1
        var mx = 0
        while l < r {
            let res = min(height[l], height[r]) * (r - l)
            mx = max(res, mx)
            if height[l] > height[r] {
                r -= 1
            }
            else {
                l += 1
            }
        }
        return mx
    }
    
    
    // 12. 整数转罗马数字
    func intToRoman(_ num: Int) -> String {
        guard num >= 1 && num <= 3999 else {
            return ""
        }
        
        var num = num
        let map = [1 : "I", 2 : "II", 3 : "III", 4 : "IV", 5 : "V", 6 : "VI", 7 : "VII", 8 : "VIII", 9 : "IX",
                   10 : "X", 20 : "XX", 30 : "XXX", 40 : "XL", 50 : "L", 60 : "LX", 70 : "LXX", 80 : "LXXX",
                   90 : "XC", 100 : "C", 200 : "CC", 300 : "CCC", 400 : "CD", 500 : "D", 600 : "DC", 700 : "DCC",
                   800 : "DCCC", 900 : "CM", 1000 : "M", 2000 : "MM", 3000 : "MMM", 0 : ""]
        
        var s = ""
        var multiple = 1
        while num > 0 {
            s = map[(num%10)*multiple]! + s
            multiple *= 10
            num /= 10
        }
        
        return s
    }
    
    
    // 13. 罗马数字转整数
    func romanToInt(_ s: String) -> Int {
        let map = ["I" : 1, "V" : 5, "X" : 10, "L" : 50,
                   "C" : 100, "D" : 500, "M" : 1000]
        let specialMap = ["IV" : 4, "IX" : 9, "XL" : 40, "XC" : 90,
                          "CD" : 400, "CM" : 900]
        
        var idx = 0
        var sum = 0
        while idx <= s.count-1 {
            let start = String.Index(utf16Offset:idx, in:s)
            let end = String.Index(utf16Offset:(idx == s.count-1 ? idx : idx+1), in:s)
            let subStr = String(s[start...end])
            
            if let value = specialMap[subStr] {
                sum += value
                idx += 2
            }
            else if let val = map[String(subStr.first!)] {
                sum += val
                idx += 1
            }
            else {
                idx += 1
            }
        }
        
        return sum
    }
    
    
    // 14. 最长公共前缀
    func longestCommonPrefix(_ strs: [String]) -> String {
        if strs.count == 0 || strs[0] == "" {
            return ""
        }
        
        if strs.count == 1 {
            return strs.first!
        }
        
        let first_str = strs[0]
        let left_strs = strs[1..<strs.endIndex]
        var offset = 0
        var prefix = ""
        
        while offset < first_str.count {
            let offset_index = first_str.index(first_str.startIndex, offsetBy: offset)
            prefix = String(first_str[...offset_index])
            for str in left_strs {
                if !str.hasPrefix(prefix) {
                    let index = prefix.index(before: prefix.endIndex)
                    return String(prefix[..<index])
                }
            }
            offset += 1
        }
        
        return prefix
    }
    
    
    // 15. 三数之和
    func threeSum(_ nums: [Int]) -> [[Int]] {
        var res: [[Int]] = []
        var ss: [String] = []
        for i in 0..<nums.count {
            for j in i+1..<nums.count {
                for k in j+1..<nums.count {
                    if nums[k] + nums[j] + nums[i] == 0 {
                        let vals = [nums[k], nums[j], nums[i]].sorted()
                        let str = vals.reduce("", {$0 + "\($1)"})
                        if !ss.contains(str) {
                            res.append(vals)
                            ss.append(str)
                        }
                    }
                }
            }
        }
        
        return res
    }
    
    
    // 16. 最接近的三数之和
    func threeSumClosest(_ nums: [Int], _ target: Int) -> Int {
        guard nums.count > 3 else {
            return nums.reduce(0, {$0+$1})
        }
        
        var nums = nums.sorted()
        var mn: Int?
        for i in 0..<nums.count {
            let a = nums[i]
            if nums[i] > target && i > 0 {
                break
            }
            if i > 0 && nums[i] == nums[i-1] {
                continue
            }
            var bIdx = i+1
            var cIdx = nums.count-1
            while bIdx < cIdx {
                let sum = a + nums[bIdx] + nums[cIdx] - target
                if sum == 0 {
                    return target
                }
                
                if mn == nil {
                    mn = sum
                }
                else {
                    mn = abs(mn!) > abs(sum) ? sum : mn
                }
                
                if sum > 0 {
                    cIdx -= 1
                }
                else {
                    bIdx += 1
                }
            }
        }
        
        return mn! + target
    }
    
    
    // 17. 电话号码的字母组合
    func letterCombinations(_ digits: String) -> [String] {
        let map = ["2" : [Character]("abc"), "3" : [Character]("def"),
                   "4" : [Character]("ghi"), "5" : [Character]("jkl"),
                   "6" : [Character]("mno"), "7" : [Character]("pqrs"),
                   "8" : [Character]("tuv"), "9" : [Character]("wxyz")]
        var cpt: [[Character]] = []
        var count = 0
        for c in digits {
            if let chs = map[String(c)] {
                cpt.append(chs)
                count = count == 0 ? chs.count : count * chs.count
            }
        }
        
        var res: [String] = []
        for i in 0..<count {
            var str = ""
            var val = 0
            for j in 0..<cpt.count {
                let chs = cpt[j]
                if j == 0 {
                    str.append(chs[i%chs.count])
                    val = chs.count
                }
                else {
                    str.append(chs[(i/val)%chs.count])
                    val *= chs.count
                }
            }
            res.append(str)
        }
        
        return res
    }
    
    
    // 18. 四数之和
    func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
        var nums = nums.sorted()
        var res: [[Int]] = []
        for i in 0..<nums.count {
            let a = nums[i]
            if i > 0 && nums[i] == nums[i-1] {
                continue
            }
            if a > 0 && a > target {
                break
            }
            for j in i+1..<nums.count {
                let b = nums[j]
                if j > i+1 && nums[j] == nums[j-1] {
                    continue
                }
                
                var cIdx = j+1
                var dIdx = nums.count-1
                while cIdx < dIdx {
                    if cIdx > j+1 && nums[cIdx] == nums[cIdx-1] {
                        cIdx += 1
                        continue
                    }
                    if dIdx < nums.count-1 && nums[dIdx] == nums[dIdx+1] {
                        dIdx -= 1
                        continue
                    }
                    let sum = a + b + nums[cIdx] + nums[dIdx]
                    if sum == target {
                        res.append([a, b, nums[cIdx], nums[dIdx]])
                        cIdx += 1
                        dIdx -= 1
                    }
                    else if (sum < target) {
                        cIdx += 1
                    }
                    else {
                        dIdx -= 1
                    }
                }
                
            }
        }
        
        return res
    }
    
    
    // 19. 删除链表的倒数第N个节点
    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        var h = head
        var nextNode = h
        var count = 0
        var lastNode = h
        while nextNode != nil {
            if count > n {
                lastNode = lastNode?.next
            }
            count += 1
            nextNode = nextNode?.next
        }
        
        
        if count > n {
            lastNode?.next = lastNode?.next?.next
        }
        else if count == n {
            h = head?.next
        }
        
        return h
    }
    
    
    // 20. 有效的括号
    func isValid(_ s: String) -> Bool {
        if s == "" {
            return true
        }
        var arr: [Character] = []
        
        for c in s {
            if c == "(" || c == "{" || c == "[" {
                arr.append(c)
                continue
            }
            
            if c == ")" || c == "}" || c == "]" {
                guard let pop = arr.last else {
                    return false
                }
                
                if c == ")" && pop != "(" {
                    return false
                }
                
                if c == "}" && pop != "{" {
                    return false
                }
                
                if c == "]" && pop != "[" {
                    return false
                }
                
                arr = Array(arr.dropLast())
            }
        }
        
        return arr.count == 0
    }
    
    
    // 21. 合并两个有序链表
    func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        var list1 = l1, list2 = l2
        let headNode = ListNode(0)
        var nextNode = headNode
        while let node1 = list1, let node2 = list2 {
            if node1.val <= node2.val {
                nextNode.next = node1
                list1 = list1?.next
                nextNode = node1
            }
            else {
                nextNode.next = node2
                list2 = list2?.next
                nextNode = node2
            }
        }
        
        if let _ = list1 {
            nextNode.next = list1!
        }
        
        if let _ = list2 {
            nextNode.next = list2!
        }
        
        return headNode.next
    }
    
    
    // 22. 括号生成
    func generateParenthesis(_ n: Int) -> [String] {
        guard n > 0 else {
            return []
        }
        
        var res: [String] = ["("]
        
        for i in 1..<2*n {
            var results: [String] = []
            for str in res {
                let lpsCount = str.replacingOccurrences(of: ")", with: "").count
                if i < 2*n - 1 && lpsCount < n {
                    results.append(str + "(")
                }
                if lpsCount*2 > str.count {
                    results.append(str + ")")
                }
            }
            res = results
        }
        
        return res
    }
    
    
    // 24. 两两交换链表中的节点
    func swapPairs(_ head: ListNode?) -> ListNode? {
        var first = head
        var second = head?.next
        var last: ListNode?
        
        let h = second == nil ? first : second
        
        while let _ = first, let _ = second {
            first?.next = second?.next
            second?.next = first
            if let _  = last {
                last?.next = second
            }
            last = first
            first = first?.next
            second = first?.next
        }
        
        return h
    }
    
    
    // 26. 删除排序数组中的重复项
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count <= 1 {
            return nums.count
        }
        
        var length = 1
        var tmp = nums.first!
        for num in nums[1...] {
            if num != tmp {
                nums[length] = num
                tmp = num
                length += 1
            }
        }
        
        return length
    }
    
    
    // 27. 移除元素
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        var length = 0
        for num in nums {
            if num != val {
                nums[length] = num
                length += 1
            }
        }
        
        return length
    }
    
    
    // 28. 实现strStr()
    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle == "" {
            return 0
        }
        if let range = haystack.range(of: needle) {
            return range.lowerBound.utf16Offset(in: haystack)
        }
        
        return -1
    }
    
    
    // 29. 两数相除
    func divide(_ dividend: Int, _ divisor: Int) -> Int {
        let div = dividend < 0 ? -dividend : dividend
        let dsr = divisor < 0 ? -divisor : divisor
        
        guard div >= dsr else {
            return 0
        }
        
        var lfmove = 1
        while (dsr<<lfmove) < div  {
            lfmove += 1
        }
        
        var res = 1<<lfmove
        var sum = dsr<<lfmove
        while lfmove > 0 {
            lfmove -= 1
            if sum > div {
                sum -= (dsr<<lfmove)
                res -= (1<<lfmove)
            }
            else {
                sum += (dsr<<lfmove)
                res += (1<<lfmove)
            }
        }
        
        res = sum > div ? res - 1 : res
        res = (dividend > 0 && divisor > 0) || (dividend < 0 && divisor < 0) ? res : -res
        res = res > Int32.max ? Int(Int32.max) : res
        res = res < Int32.min ? Int(Int32.min) : res
        
        return res
    }
    
    
    // 31. 下一个排列
    func nextPermutation(_ nums: inout [Int]) {
        var index = nums.count-1
        while index > 0 {
            if nums[index-1] < nums[index] {
                break
            }
            index -= 1
        }
        
        if index > 0 {
            var idx = index
            for i in index+1..<nums.count {
                if nums[i] > nums[index-1] && nums[i] < nums[idx] {
                    idx = i
                }
            }
            nums.swapAt(index-1, idx)
        }
        
        nums[index...].sort()
    }
    
    
    // 33. 搜索旋转排序数组
    func search(_ nums: [Int], _ target: Int) -> Int {
        var start = 0
        var end = nums.count-1
        
        while start <= end {
            let mid = start + (end - start)/2
            if nums[mid] == target {
                return mid
            }
            
            if nums[mid] >= nums[start] {   // 前半段排好序
                if nums[mid] > target && nums[start] <= target {
                    end = mid-1
                }
                else {
                    start = mid+1
                }
            }
            else {    // 后半段排好序
                if nums[mid] < target && nums[end] >= target {
                    start = mid+1
                }
                else {
                    end = mid-1
                }
            }
        }
        
        return -1
    }
    
    
    // 34. 在排序数组中查找元素的第一个和最后一个位置
    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        guard let index = nums.firstIndex(of: target) else {
            return [-1, -1]
        }
        
        var last = index
        for i in index+1..<nums.count {
            if nums[i] == target {
                last = i
            }
        }
        
        return [index, last]
    }
    
    
    // 35. 搜索插入位置
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        if nums.count == 0 || target <= nums.first! {
            return 0
        }
        for (index, num) in nums.enumerated() {
            if target <= num {
                return index
            }
        }
        return nums.count
    }
    
    
    // 36. 有效的数独
    func isValidSudoku(_ board: [[Character]]) -> Bool {
        var rows = [[Character]](repeating: [], count: 9)
        var columns = [[Character]](repeating: [], count: 9)
        var squares = [[Character]](repeating: [], count: 9)
        
        for i in 0..<board.count {
            let row = board[i]
            for j in 0..<row.count {
                if row[j] >= "1" && row[j] <= "9" {
                    rows[i].append(row[j])
                    columns[j].append(row[j])
                    let index = (i/3)*3 + j/3
                    squares[index].append(row[j])
                }
            }
        }
        
        let isValid = isValidRows(rows) && isValidRows(columns) && isValidRows(squares)
        
        return isValid
    }
    
    func isValidRows(_ rows: [[Character]]) -> Bool {
        for row in rows {
            if row.count != Set(row).count {
                return false
            }
        }
        return true
    }
    
    
    // 37. 解数独
    func solveSudoku(_ board: inout [[Character]]) {
        
        var stop = false
        for i in 0..<board.count {
            for j in 0..<board[i].count {
                if board[i][j] == ".", !stop {
                    for digit in 1...9 {
                        addDigit(Character("\(digit)"), at: i, column: j, &board, &stop)
                    }
                }
            }
        }
    }
    
    func addDigit(_ digit: Character, at row: Int, column: Int, _ board: inout [[Character]], _ stop: inout Bool) {
        if row == board.count {  // 找到一个解
            stop = true
            return
        }
        
        if isValidDigit(digit, board, at: row, column: column) {
            board[row][column] = digit
            var nextColumn = column
            var nextRow = row
            repeat {
                nextColumn = (nextColumn == board[nextRow].count - 1) ? 0 : nextColumn + 1
                nextRow = (nextColumn == 0) ? nextRow + 1 : nextRow
            } while nextRow < board.count && board[nextRow][nextColumn] != "."
            
            for num in 1...9 {
                if !stop {
                    addDigit(Character("\(num)"), at: nextRow, column: nextColumn, &board, &stop)
                }
            }
            if !stop {
                board[row][column] = Character(".")
            }
        }
    }
    
    func isValidDigit(_ digit: Character, _ board: [[Character]], at row: Int, column: Int) -> Bool {
        
        // 同一行是否有这个数字
        for c in board[row] {
            if c != ".", digit == c {
                return false
            }
        }
        
        // 同一列是否有这个数字
        for i in 0..<board.count {
            if board[i][column] != ".", digit == board[i][column] {
                return false
            }
        }
        
        // 同一个九宫格是否有这个数字
        for i in (row / 3) * 3..<(row / 3 + 1) * 3 {
            for j in (column / 3) * 3..<(column / 3 + 1) * 3{
                if board[i][j] != ".", digit == board[i][j] {
                    return false
                }
            }
        }
        
        return true
    }
    
    
    // 38. 报数
    func countAndSay(_ n: Int) -> String {
        if n == 1 {
            return "1"
        }
        let last = countAndSay(n-1)
        var compare = ""
        var count = 0
        var str = ""
        for c in last {
            if String(c) != compare {
                str += count > 0 ? ("\(count)" + compare) : ""
                compare = String(c)
                count = 0
            }
            count += 1
        }
        str += count > 0 ? ("\(count)" + compare) : ""
        return str
    }
    
    
    // 39. 组合总和
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let nums = candidates.sorted()
        var res: [[Int]] = []
        
        backTrace(nums, target, [], &res)
        
        return res
    }
    
    func backTrace(_ candidates: [Int], _ target: Int, _ vals: [Int], _ res: inout [[Int]]) {
        
        if target == 0 {
            res.append(vals)
            return
        }
        
        var vals = vals
        
        for i in 0..<candidates.count {
            if candidates[i] > target {
                break
            }
            vals.append(candidates[i])
            backTrace([Int](candidates[i...]), target-candidates[i], vals, &res)
            vals.removeLast()
        }
    }
    
    
    // 40. 组合总和 II
    func combinationSum2(_ candidates: [Int], _ target: Int) -> [[Int]] {
        let nums = candidates.sorted()
        var res: [[Int]] = []
        
        dfs(nums, target, [], &res)
        
        return res
    }
    
    func dfs(_ candidates: [Int], _ target: Int, _ vals: [Int], _ res: inout [[Int]]) {
        
        if target == 0 {
            res.append(vals)
            return
        }
        
        var vals = vals
        
        for i in 0..<candidates.count {
            if candidates[i] > target {
                break
            }
            
            if i > 0 && candidates[i] == candidates[i-1] {
                continue
            }
            
            vals.append(candidates[i])
            dfs([Int](candidates[i+1..<candidates.count]), target-candidates[i], vals, &res)
            vals.removeLast()
        }
    }
    
    
    // 41. 缺失的第一个正数
    func firstMissingPositive(_ nums: [Int]) -> Int {
        
        guard nums.count > 0 else {
            return 1
        }
        
        let set = Set(nums)
        for i in 1...nums.count {
            if !set.contains(i) {
                return i
            }
        }
        
        return nums.count+1
    }
    
    
    // 42. 接雨水
    func trap(_ height: [Int]) -> Int {
        guard height.count >= 3 else {
            return 0
        }
        
        var lf = 0
        var rt = height.count - 1
        
        var val = 1
        var sum = 0
        
        while true {
            
            while lf < rt && (height[lf] < val || height[rt] < val) {
                
                if height[lf] < val {
                    lf += 1
                }
                
                if height[rt] < val {
                    rt -= 1
                }
            }
            
            if lf >= rt {
                sum += (height[lf] >= val ? (height[lf] - val + 1) : 0)
                break;
            }
            
            sum += (rt - lf + 1)
            val += 1
        }
        
        let hs = height.reduce(0, {$0 + $1})
        
        return sum - hs
    }
    
    
    // 43. 字符串相乘
    func multiply(_ num1: String, _ num2: String) -> String {
        guard num1 != "0" && num2 != "0" else {
            return "0"
        }
        
        let chas1 = [Character](num1.reversed())
        let chas2 = [Character](num2.reversed())
        
        var lastRes: [Int] = []
        for i in 0..<chas1.count {
            var flag = 0
            var res = [Int](repeating: 0, count: i)
            for j in 0..<chas2.count {
                let val1 = Int(String(chas1[i]))!
                let val2 = Int(String(chas2[j]))!
                let sum = val1 * val2 + flag
                flag = sum / 10
                res.append(sum % 10)
            }
            if flag > 0 {
                res.append(flag)
            }
            lastRes = i == 0 ? res : add(lastRes, res)
        }
        
        return lastRes.reversed().reduce("", {$0 + "\($1)"})
    }
    
    func add(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        let mx = max(nums1.count, nums2.count)
        var i = 0
        var flag = 0
        var res: [Int] = []
        while i < mx {
            let num1 = i < nums1.count ? nums1[i] : 0
            let num2 = i < nums2.count ? nums2[i] : 0
            let sum = num1 + num2 + flag
            flag = sum / 10
            res.append(sum % 10)
            i += 1
        }
        if flag > 0 {
            res.append(flag)
        }
        
        return res
    }
    
    
    // 46. 全排列
    func permute(_ nums: [Int]) -> [[Int]] {
        var res: [[Int]] = []
        var flags: [Int] = [Int](repeating: 0, count: nums.count)
        
        permuteTrace(nums, &flags, [], &res)
        
        return res
    }
    
    func permuteTrace(_ nums: [Int], _ flags: inout [Int], _ vals: [Int], _ res: inout [[Int]]) {
        
        if vals.count == nums.count {
            res.append(vals)
            return
        }
        
        var vals = vals
        for i in 0..<nums.count {
            if flags[i] == 0 {
                vals.append(nums[i])
                flags[i] = 1
                permuteTrace(nums, &flags, vals, &res)
                flags[i] = 0
                vals.removeLast()
            }
        }
    }
    
    
    // 47. 全排列 II
    func permuteUnique(_ nums: [Int]) -> [[Int]] {
        var res: [[Int]] = []
        var flags: [Int] = [Int](repeating: 0, count: nums.count)
        
        permuteUniqueTrace(nums.sorted(), &flags, [], &res)
        
        return res
    }
    
    func permuteUniqueTrace(_ nums: [Int], _ flags: inout [Int], _ vals: [Int], _ res: inout [[Int]]) {
        if vals.count == nums.count {
            res.append(vals)
            return
        }
        
        var i = 0
        var vals = vals
        while i < nums.count {
            if flags[i] == 0 {
                vals.append(nums[i])
                flags[i] = 1
                permuteUniqueTrace(nums, &flags, vals, &res)
                flags[i] = 0
                vals.removeLast()
                
                while i+1 < nums.count && nums[i+1] == nums[i] {
                    i += 1
                }
            }
            i += 1
        }
    }
    
    
    // 48. 旋转图像
    func rotate(_ matrix: inout [[Int]]) {
        let n = matrix.count
        
        for times in 0..<n/2 {
            
            let end = n-1-times
            
            for i in times..<end {
                
                let begin = (times, i)
                var next = (begin.1, n-1-begin.0)
                
                while begin != next {
                    let temp = matrix[next.0][next.1]
                    matrix[next.0][next.1] = matrix[begin.0][begin.1]
                    matrix[begin.0][begin.1] = temp
                    next = (next.1, n-1-next.0)
                }
            }
        }
    }
    
    
    // 49. 字母异位词分组
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        var map: [String: [String]] = [:]
        
        for str in strs {
            let s = String(str.sorted())
            if let vals = map[s] {
                map[s] = vals + [str]
            }
            else {
                map[s] = [str]
            }
        }
        
        var res: [[String]] = []
        
        for (_, value) in map {
            res.append(value)
        }
        
        return res
    }
    
    
    // 50. Pow(x, n)
    func myPow(_ x: Double, _ n: Int) -> Double {
        guard n != 0 else {
            return 1.0
        }
        
        var m = n > 0 ? n : -n-1   // n为负数，防止溢出
        var res = 1.0
        var q = x
        
        while m > 0 {
            if (m & 1) != 0 {
                res *= q
            }
            q *= q
            m >>= 1
        }
        
        return n > 0 ? res : 1.0/res/x
    }
}




