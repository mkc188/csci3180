# CSCI3180 Principles of Programming Languages

# --- Declaration ---

# I declare that the assignment here submitted is original except for source
# material explicitly acknowledged. I also acknowledge that I am aware of
# University policy and regulations on honesty in academic work, and of the
# disciplinary guidelines and procedures applicable to breaches of such policy
# and regulations, as contained in the website
# http://www.cuhk.edu.hk/policy/academichonesty/

# Assignment 2

$BOARD_W = 7
$BOARD_H = 6

class Connect_Four
  require 'io/console'

  # use bit mask to set the board
  MASK = [1<<0,  1<<1,  1<<2,  1<<3,  1<<4,  1<<5,  1<<6,  1<<7,
          1<<8,  1<<9,  1<<10, 1<<11, 1<<12, 1<<13, 1<<14, 1<<15,
          1<<16, 1<<17, 1<<18, 1<<19, 1<<20, 1<<21, 1<<22, 1<<23,
          1<<24, 1<<25, 1<<26, 1<<27, 1<<28, 1<<29, 1<<30, 1<<31,
          1<<32, 1<<33, 1<<34, 1<<35, 1<<36, 1<<37, 1<<38, 1<<39,
          1<<40, 1<<41, 1<<42, 1<<43, 1<<44, 1<<45, 1<<46, 1<<47]

  def initialize
    @gameBoard = Array.new($BOARD_H) {Array.new($BOARD_W,' ')}
    @playerList = [@player1, @player2]
    @bitboard = [0x0, 0x0]
  end

  # main function
  def startGame
    @playerList = [@player1, @player2]
    player = {'1' => 'Computer', '2' => 'Human'}
    sym = ['O', 'X']
    ordinal_no = ['first', 'second']

    # print menu for choosing player
    2.times do |i|
      choice = nil
      while choice != '1' and choice != '2' do
        puts "\nPlease choose the #{ordinal_no[i]} player:"
        puts '1.Computer'
        puts '2.Human'
        print 'Your choice is: '
        choice = gets.chomp
        puts if choice == ""
      end

      @playerList[i] = choice == '1' ? Computer.new(sym[i]) : Human.new(sym[i])
      print "\nPlayer #{@playerList[i].playerSymbol} is #{player[choice]}.\n"
    end

    print "\nPress any key to start..."
    # get any key to continue and flsh stdin
    $stdin.getch
    $stdin.iflush
    puts

    # randomly choose which player first
    @turn = rand(2)

    # main loop
    loop do
      printGameBoard([])
      while move(@playerList[@turn].nextColumn) == -1 do
        puts "\nInvalid move, please try again"
      end
      break if gameOver
      @turn ^= 1
    end

  end

  # print game board every time player moved,
  # indices indicate which position need highlight when someone won
  def printGameBoard(indices)
    h_rule = ''
    ($BOARD_W*4+1).times { h_rule << '-' }
    1.upto($BOARD_W) { |i| print "| #{i} " }
    puts '|', "#{h_rule}"

    for i in (0...$BOARD_H) do
      n = $BOARD_H - i
      for j in (0...$BOARD_W) do
        if indices.include?(n)
          # make the position inverse video
          print '|', "\033[7m #{@gameBoard[i][j]} \033[0m"
        else
          print '|', " #{@gameBoard[i][j]} "
        end
        n += $BOARD_W
      end
      print "|\n#{h_rule}\n"
    end
  end

  # make move by indicating which column(1-7), return -1 if illegal move
  def move(col)
    legal = false
    $BOARD_H.times.reverse_each do |row|
      if @gameBoard[row][col] == ' '
        @gameBoard[row][col] = @playerList[@turn].playerSymbol
        @bitboard[@turn] |= (MASK[$BOARD_W*col+($BOARD_H-1-row)])
        legal = true
        break
      end
    end
    return legal == true ? 0 : -1
  end

  # check winning state by using bitboard algorithm
  def haswon
    test = @bitboard[@turn]
    diag1 = test & (test >> $BOARD_H)
    hori = test & (test >> $BOARD_H+1)
    diag2 = test & (test >> $BOARD_H+2)
    vert = test & (test >> 1)

    truetable = []
    truetable << (diag1 & (diag1 >> 2*$BOARD_H))
    truetable << (hori & (hori >> 2*($BOARD_H+1)))
    truetable << (diag2 & (diag2 >> 2*($BOARD_H+2)))
    truetable << (vert & (vert >> 2))

    truetable.each_with_index do |e, i|
      if e > 0
        highlight(e, i)
        return true
      end
    end
    return false
  end

  # check whether it is a draw game
  def isdraw
    if !(@gameBoard.flatten.include?(" "))
      printGameBoard([])
      return true
    else
      return false
    end
  end

  # check whether it is game over
  def gameOver
    if haswon
      puts "\nGAME OVER. '#{@playerList[@turn].playerSymbol}' is the winner", ""
      return true
    elsif isdraw
      puts "\nDRAW.", ""
      return true
    end
    return false
  end

  # calculate where to highlight the winner from the winning bitboard config
  def highlight(bitboard, dir)
    increment = [$BOARD_H, $BOARD_H+1, $BOARD_H+2, 1]
    bits = bitboard.to_s(2)
    bits.reverse!
    indices = []
    bits.scan(/1/) { indices << $~.offset(0)[0] + 1}

    last_idx = indices[-1]
    3.times { indices << last_idx += increment[dir]}

    printGameBoard(indices)
  end
end

class Player
  attr_reader :playerSymbol

  def initialize(symbol)
    @playerSymbol = symbol
  end

  def nextColumn
    raise NotImplementedError
  end
end

class Human < Player
  def nextColumn
    loop do
      print "\nThis is #{@playerSymbol}'s turn. Enter your move (1-7): "
      next_col = gets.chomp.to_i
      if (1..$BOARD_W).cover? next_col
        return next_col - 1
      end
    end
  end
end

class Computer < Player
  def nextColumn
    print "\nThis is #{@playerSymbol}'s turn. Computing... "
    next_col = rand($BOARD_W)
    puts "Finished",""
    return next_col
  end
end

# program entry
Connect_Four.new.startGame
