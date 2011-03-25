class TicTacToe
    
  def self.play
    new.play
  end

  class Board
    def initialize
      @board = [[nil,nil,nil],
                [nil,nil,nil],
                [nil,nil,nil]]
    end

    def draw!
      puts @board.map { |row| row.map { |e| e || " " }.join("|") }.join("\n")
    end

    def method_missing(*args, &block)
      @board.send(*args, &block)
    end

    def get(row, col)
      check_bounds!(row, col)
      @board[row][col]
    end

    def set!(row, col, player)
      check_bounds!(row, col)
      raise "Cell occupied, try another position" if @board[row][col]
      @board[row][col] = player
    end

    def draw?
      @board.flatten.compact.length == 9
    end

    protected

    def check_bounds!(row, col)
      raise "Out of bounds, try another position" unless (0..2).include?(row) && (0..2).include?(col)
    end
  end

  def initialize
    @board = Board.new
    @players = [:X, :O].cycle

  end

  def play
    
    left_diagonal = [[0,0],[1,1],[2,2]]
    right_diagonal = [[2,0],[1,1],[0,2]]

    current_player = @players.next 

    loop do
      @board.draw!
      print "\n>> "
      row, col = gets.split.map { |e| e.to_i }
      puts

      begin
        @board.set!(row, col, current_player)
      rescue Exception => ex
        puts ex.to_s 
        next
      end

      lines = []

      [left_diagonal, right_diagonal].each do |line|
        lines << line if line.include?([row,col])
      end

      lines << (0..2).map { |c1| [row, c1] }
      lines << (0..2).map { |r1| [r1, col] }

      win = lines.any? do |line|
        line.all? { |row,col| @board.get(row, col) == current_player }
      end

      if win
        puts "#{current_player} wins!"
        exit
      end

      if @board.draw?
        puts "It's a draw!"
        exit
      end

      current_player = @players.next 
    end
  end
end

TicTacToe.play
