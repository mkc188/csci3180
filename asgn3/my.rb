# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 3

$borrowLimit = 5

def returnBook(name, holdNum, returnNum)
    puts "\n... Returning Books ..."
    print "Thank you, #{name}!  "

    holdNum -= returnNum

    if 1 == returnNum
        puts "You've just returned [#{returnNum}] book!"
    else
        puts "You've just returned [#{returnNum}] books!"
    end

    currentLimit = $borrowLimit - holdNum

    if 1 == currentLimit
        puts "Now you can borrow [#{currentLimit}] more book."
    else
        puts "Now you can borrow [#{currentLimit}] more books."
    end

    holdNum
end

def borrowBook(name, holdNum, borrowNum)
    puts "\n... Borrowing Books ..."

    currentLimit = $borrowLimit - holdNum

    if 0 > currentLimit - borrowNum
        puts 'You have exceeded your borrowing limit!'
        return -1
    end

    currentLimit -= borrowNum
    holdNum += borrowNum

    if 1 == borrowNum
        puts "You've just borrowed [#{borrowNum}] book!"
    else
        puts "You've just borrowed [#{borrowNum}] books!"
    end

    if 1 == currentLimit
        puts "Now you can borrow [#{currentLimit}] more book."
    else
        puts "Now you can borrow [#{currentLimit}] more books."
    end

    holdNum
end

def staff(name, holdNum, returnNum, borrowNum)
    holdNum = returnBook(name, holdNum, returnNum)

    if 0 <= holdNum
        puts "[Number of books borrowed: #{holdNum}]"
    else
        puts "ERROR!  You are trying to return more books than you've borrowed!"
    end

    holdNum = borrowBook(name, holdNum, borrowNum)

    if 0 <= holdNum
        puts "[Number of books borrowed: #{holdNum}]"
    else
        puts "ERROR!  You are trying to borrow more books than your borrowing limit!"
    end
end

def professor(name, holdNum, returnNum, borrowNum)
    borrowLimit = 10

    puts "Dear Professor #{name}, you can borrow [#{borrowLimit}] books in total!  Enjoy the books!"

    staff(name, holdNum, returnNum, borrowNum)
end

def library(name, id, holdNum, returnNum, borrowNum)
    puts "\n** Dear #{name}, welcome to the CUHK Library **"
    puts "[Number of books borrowed: #{holdNum}]"

    if /p/.match(id)
        professor(name, holdNum, returnNum, borrowNum)
    else
        staff(name, holdNum, returnNum, borrowNum)
    end
end

puts "\t\t### Welcome to the CUHK Library Administration System ###"

library("Olivia Su", "s123", 2, 1, 3)
library("Jimmy Lee", "p123", 5, 2, 7)
library("Weixin Si","s234", 5, 2, 7)
