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

def returnBook
    varList = pushVar()

    puts "\n... Returning Books ..."
    print "Thank you, #{$name}!  "

    $holdNum -= $returnNum

    if 1 == $returnNum
        puts "You've just returned [#{$returnNum}] book!"
    else
        puts "You've just returned [#{$returnNum}] books!"
    end

    $currentLimit = $borrowLimit - $holdNum

    if 1 == $currentLimit
        puts "Now you can borrow [#{$currentLimit}] more book."
    else
        puts "Now you can borrow [#{$currentLimit}] more books."
    end

    # set the value for return
    varList[:holdNum] = $holdNum
    popVar(varList)
    $holdNum
end

def borrowBook
    varList = pushVar()

    puts "\n... Borrowing Books ..."

    $currentLimit = $borrowLimit - $holdNum

    if 0 > $currentLimit - $borrowNum
        puts 'You have exceeded your borrowing limit!'
        popVar(varList)
        return -1
    end

    $currentLimit -= $borrowNum
    $holdNum += $borrowNum

    if 1 == $borrowNum
        puts "You've just borrowed [#{$borrowNum}] book!"
    else
        puts "You've just borrowed [#{$borrowNum}] books!"
    end

    if 1 == $currentLimit
        puts "Now you can borrow [#{$currentLimit}] more book."
    else
        puts "Now you can borrow [#{$currentLimit}] more books."
    end

    # set the value for return
    varList[:holdNum] = $holdNum
    popVar(varList)
    $holdNum
end

def staff
    varList = pushVar()

    $holdNum = returnBook()

    if 0 <= $holdNum
        puts "[Number of books borrowed: #{$holdNum}]"
    else
        puts "ERROR!  You are trying to return more books than you've borrowed!"
    end

    $holdNum = borrowBook()

    if 0 <= $holdNum
        puts "[Number of books borrowed: #{$holdNum}]"
    else
        puts "ERROR!  You are trying to borrow more books than your borrowing limit!"
    end

    popVar(varList)
end

def professor
    varList = pushVar()

    $borrowLimit = 10

    puts "Dear Professor #{$name}, you can borrow [#{$borrowLimit}] books in total!  Enjoy the books!"

    staff()

    popVar(varList)
end

def library(name, id, holdNum, returnNum, borrowNum)
    $name = name
    $id = id
    $holdNum = holdNum
    $returnNum = returnNum
    $borrowNum = borrowNum

    varList = pushVar()

    puts "\n** Dear #{$name}, welcome to the CUHK Library **"
    puts "[Number of books borrowed: #{$holdNum}]"

    if /p/.match($id)
        professor()
    else
        staff()
    end

    popVar(varList)
end

# save all the variables to a Hash when entering new scope
def pushVar
    varList = Hash.new
    varList[:borrowLimit] = $borrowLimit
    varList[:name] = $name
    varList[:id] = $id
    varList[:holdNum] = $holdNum
    varList[:returnNum] = $returnNum
    varList[:borrowNum] = $borrowNum
    varList[:currentLimit] = $currentLimit
    varList
end

# restore all the variables from the Hash when leaving current scope
def popVar(varList)
    $borrowLimit = varList[:borrowLimit]
    $name = varList[:name]
    $id = varList[:id]
    $holdNum = varList[:holdNum]
    $returnNum = varList[:returnNum]
    $borrowNum = varList[:borrowNum]
    $currentLimit = varList[:currentLimit]
end

puts "\t\t### Welcome to the CUHK Library Administration System ###"

library("Olivia Su", "s123", 2, 1, 3)
library("Jimmy Lee", "p123", 5, 2, 7)
library("Weixin Si","s234", 5, 2, 7)
