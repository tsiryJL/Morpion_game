require 'colorize'

class Player
  attr_accessor :name, :mark

#initialise la classe Player avec les valeurs de bases
  def initialize(name, mark, board)
      @name = name
      @mark = mark
      @board = board
  end

#permet mettre à jour les takens en fonction de la valeur déterminée par le joueur
  def move(cell)
      @board.update_cell(cell, self.mark)
  end

# Définition des combinaisons gagnantes
# permet de faire une boucle sur toutes les combinaisons gagnantes et de s'assurer que les jetons sont bien identiques dans l'array
  def winner?
      wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
          
          wins.each do |win| 
            values = [cells[win[0]], cells[win[1]], cells[win[2]]]
              return true if values.include?(self.mark.to_s) && ((values[0] == values[1]) && (values[1] == values[2]))
              end
            false
          end 

#<<--
  private
#permet de lier les cellules à la classe joueur
      def cells
         @board.cells
      end
  end

# Classe définissant le plateau de jeu
class Board
  attr_accessor :cells

#------>   colone tableau
  def initialize
    @cells = [
    "1", "2", "3",
    "4", "5", "6",
    "7", "8", "9"
    ]
  end

#----> Image graphique du tableau
  def update_cell(number, mark)
      if cell_free?(number)
          self.cells[number - 1] = mark.to_s
          show_board
      else
          puts "--> La case est déjà pris! essaye un autre <--"
        return false
      end
  end

  def show_board
      hline = "\u2502".light_blue
      vline = "\u2500".light_blue
      cross = "\u253C".light_blue
      row1 = " " + self.cells[0..2].join(" #{hline} ")
      row2 = " " + self.cells[3..5].join(" #{hline} ")
      row3 = " " + self.cells[6..8].join(" #{hline} ")
      separator = vline * 3 + cross + vline * 3 + cross + vline * 3
    system("clear")
    puts row1
    puts separator
    puts row2
    puts separator
    puts row3
  end

  private
#-->>
#Permet de remplacer les cellules par le signe du joueur en checkant si elles sont vides, sinon la cellule n'est pas complétée
  def cell_free?(number)
    cell = self.cells[number - 1]
    if cell == "X" ||  cell == "O"
        false
    else
        true
    end
  end
end

#Cette classe permet de mettre en place le jeu et de le lancer avec des valeurs de base
class Game

  def initialize
    @board = Board.new
    @current_player = ""
    @winner = false
    @turn = 0
  end

#--------------DEBUT DU JEUX----------------------
#Méthode permettant d'obtenir le nom des joueurs, on utilise le gest.chomp
  def get_names
    puts "Player X name: ".green
    name1 = gets.chomp.green
    puts "Player O name: ".red
    name2 = gets.chomp.red
    [name1, name2]
  end

  def start_game
    names = get_names
    @player1 = Player.new(names[0], :X, @board)
    @player2 = Player.new(names[1], :O, @board)
    @current_player = @player1
    @board.show_board
    turn until @winner || @turn == 9

          puts "               -------------------------------- "
          puts "              +-  Get Ready to the Next Battle  -+"
          puts "               -------------------------------- "
    puts "              <><><><> #{@player1.name}__VS__#{@player2.name} <><><><><>"
          puts"\n"
      if @winner
          puts "****************  #{@winner.name} est le vainqueur!!  **************"
          puts"\n"
      else
          puts "----->|   Egaliter   |<-----"
      end
  end  

 private
#---> case de à remplir
  def turn
    puts "#{@current_player.name}\'s tour. choisir un nombre entre (1-9): "
    choice = gets.chomp.to_i
   
    if choice > 9 || choice < 1
      puts "Attention!!: le nombre doit être compris entre 1 et 9"

    elsif @current_player.move(choice) != false
      @winner = @current_player if @current_player.winner?
      @turn += 1
      switch_player
    end
  end

# Méthode permettant de mettre en place les changement de joueur
  def switch_player
    @current_player = @current_player == @player1 ? @player2 : @player1
  end
end
puts "\n"
puts "\n"
puts "            -+----------  WELCOME IN MORPION GAME  ---------+-"
puts "\n"
puts "          -------------------------------------------------   "
puts "   |Le joueur doit remplir la grille avec son symbole pour gagner !|"
puts "          -------------------------------------------------   "
puts "\n"

game = Game.new
game.start_game
