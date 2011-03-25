class TicTacToe
    
  def self.play
    new.play
  end

  class Board        
    LINES = [
              [0,3,6], [1,4,7], [2,5,8], # Vertical
              [0,1,2], [3,4,5], [6,7,8], # Horizontal
              [0,4,8], [2,4,6]           # Diagonals
            ]

    def initialize
      @board = [nil] * 9
    end

    def draw!
      [0,1,2].each do |row|
        base_position = row * 3
        puts @board[base_position..(base_position + 2)].map { |cell| cell || ' ' }.join("|")
      end
    end

    def method_missing(*args, &block)
      @board.send(*args, &block)
    end

    def get(row, col)
      check_bounds!(row, col)
      position = row_and_col_to_position(row, col)
      @board[row][col]
    end

    def set!(row, col, player)
      check_bounds!(row, col)
      position = row_and_col_to_position(row, col)
      raise "Cell occupied, try another position" if @board[position]
      @board[position] = player
    end

    def draw?
      @board.compact.length == 9
    end

    def victory_for_player?(player)
      LINES.each do |line|
        return true if line.all? { |position| @board[position] == player }
      end
      false
    end

    protected

    def check_bounds!(row, col)
      raise "Out of bounds, try another position" unless (0..2).include?(row) && (0..2).include?(col)
    end

    def row_and_col_to_position(row, col)
      row * 3 + col
    end
  end

  def initialize
    @board = Board.new
    @players = [:X, :O].cycle

  end

  def play

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

      if @board.victory_for_player?(current_player)
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
