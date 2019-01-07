require 'gosu'

class Vector2D
	attr_accessor :x
	attr_accessor :y
	
	def initialize(x, y)
		@x = x
		@y = y
	end
	
	def print
		puts "(#{@x},#{@y})"
	end
	
	def addVector(vector)
		@x += vector.x
		@y += vector.y
	end
	
	def copy(vector)
		@x = vector.x
		@y = vector.y
	end
	
	def equals(vector)
		if (vector)
			(@x == vector.x) && (@y == vector.y)
		else 
			false
		end
	end
	
end

class Snake
	attr_accessor :bodyparts
	attr_accessor :sizeOfParts
	attr_accessor :direction
	
	def initialize
		setStartingPosition
		@sizeOfParts = 10	
	end
	
	def setStartingPosition
		@bodyparts = []
		(10..15).reverse_each do |x|
			myVector = Vector2D.new(x, 10)
			bodyparts << myVector
		end
		@direction = Vector2D.new(1,0)
	end
	
	def draw
		@bodyparts.each do |pos|
			x = pos.x * @sizeOfParts;
			y = pos.y * @sizeOfParts;
			Gosu::draw_rect x, y, @sizeOfParts, @sizeOfParts, Gosu::Color::WHITE
		end
	end
	
	def update
		length = bodyparts.size
		(1..(length-1)).reverse_each do |i|
			@bodyparts[i].copy(@bodyparts[i-1])
		end
		@bodyparts.first.addVector(direction)
	end
	
	def collidesWithFood(foodpos)
		(bodyparts.first.x == foodpos.x) && (bodyparts.first.y == foodpos.y)
	end
	
	def handleCollisions(foodpos, window)
		
		#Collision with wall?
		setStartingPosition if @bodyparts.first.x < 0 || 
		   @bodyparts.first.y  < 0 ||
		   @bodyparts.first.x * 10 > 630 ||
		   @bodyparts.first.y * 10 > 480    
		   
		#Collision with food?
		if collidesWithFood(foodpos)
			5.times do  
				@bodyparts.push(Vector2D.new(-1,-1)) 
			end
			window.setFoodPos()
		end
		
		#Collision with self?
		length = @bodyparts.size
		(1..length-1).each do |i|
			if (@bodyparts.first.equals(@bodyparts[i]))
				setStartingPosition
			end
		end
		
	end
	
	def right
		@direction = Vector2D.new(1, 0)
	end
	
	def left
		@direction = Vector2D.new(-1, 0)
	end
	
	def up
		@direction = Vector2D.new(0, -1)
	end
	
	def down
		@direction = Vector2D.new(0, 1)
	end
	
end


class MyWindow < Gosu::Window

	attr_accessor :snake
	attr_accessor :foodpos

	def initialize(snake)
		super 640, 480
		self.caption = 'Snake'
		@snake = snake
		setFoodPos
	end
	
	def setFoodPos
		x = rand(63)
		y = rand(47)
		@foodpos = Vector2D.new(x , y ); 
	end
	
	def draw
		draw_background
		@snake.draw
		sleep(0.02)
	end
	
	def update
		@snake.update
		@snake.handleCollisions(foodpos, self)
	end
	
	def draw_background
		draw_rect 0, 0, self.width, self.height, Gosu::Color::BLACK 
		x= foodpos.x * 10
		y = foodpos.y * 10
		draw_rect x, y, 10, 10, Gosu::Color::GREEN				  
	end
	
	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
		if id == Gosu::KbDown  
			@snake.down  
		end
		if id == Gosu::KbUp 
			@snake.up  
		end
		if id == Gosu::KbLeft 
			@snake.left  
		end
		if id == Gosu::KbRight 
			@snake.right  
		end		
	end
  
end

snake = Snake.new()

window = MyWindow.new(snake)

window.show



