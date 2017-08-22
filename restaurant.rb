require 'terminal-table'
class Restaurant 
    attr_accessor :budget, :total, :items
    def initialize(budget)
        @budget = budget
        @total = 0
        @items = {}
        @receipt = ""
        @tips = 0
        @menu = {
    :appetizer => {
        :kimchi => 1.00,
        :dumpling => 0.50,
        :miso_soup => 1.00,
        :rice_ball => 0.25,
        :bowl_of_edamame => 2.00,
        :spring_roll => 0.25,
        :dimsum => 3.00,
        :takoyaki => 5.00
    },
    
    :main => {
        :spicy_chicken_ramen => 8.00,
        :pad_thai => 5.00,
        :pho => 10.00,
        :fried_rice => 7.00,
        :sashimi => 2.00,
        :sushi_roll => 9.00,
        :bibimbap => 10.00
    },
    
    :dessert => {
        :ice_cream_scoop => {
            :vanilla => 2.00,
            :chocolate => 2.00,
            :strawberry => 2.00
        },
        :mochi_ice_cream => 1.00,
        :egg_tart => 0.75,
        :sweet_green_bean_soup => 2.00,
        :eggette => 4.00,
        :cookie => 0.50
    },
    
    :drinks => {
        :bubble_tea => 4.00,
        :tea => 0.50,
        :water => 0.00,
        :juice => {
            :orange => 1.00,
            :apple => 1.00,
        },
        :soda => 1.50,
        :coffee => 2.00
    }
}
    end
    def menu()
        @menu.each do |course, itemHash|
        puts "
        #{course.upcase}"
        itemHash.each do |item, price|
            if price.class == Hash
                puts "#{item.to_s.gsub("_", " ").capitalize}:"
                price.each do |item1, price1|
                    if budget >= price1
                        item1 = item1.to_s.gsub("_", " ")
                        printf("    %s: $%.2f\n", item1.capitalize, price1)
                    end
                end
            else
                if budget >= price
                    item = item.to_s.gsub("_", " ")
                    printf("%s: $%.2f\n", item.capitalize, price)
                end
            end
        end
    end
        
    end
    def buy()
        puts "\nWhat course do you want?"
        course = gets.chomp.downcase.to_sym
        while @menu.key?(course) == false
            puts "Please enter a valid course name."
            puts "\nWhat course do you want?"
            course = gets.chomp.downcase.to_sym
        end
        @menu[course].each do |item, price|
            if price.class == Hash
                puts "#{item.to_s.gsub("_", " ").capitalize}:"
                price.each do |item1, price1|
                    if budget >= price1
                        item1 = item1.to_s.gsub("_", " ")
                        printf("    %s: %.2f\n", item1.capitalize, price1)
                    end
                end
            else
                if budget >= price
                    item = item.to_s.gsub("_", " ")
                    printf("%s: %.2f\n", item.capitalize, price)
                end
            end
        end
        puts "\nWhat item do you want?"
        item = gets.chomp.downcase
        updateItem = item.gsub(" ", "_").to_sym
        while @menu[course].key?(updateItem) == false
            puts "Please enter a valid item name."
            puts "\nWhat item do you want?"
            item = gets.chomp.downcase
            updateItem = item.gsub(" ", "_").to_sym
        end
        if @menu[course][updateItem].class == Hash
            puts "\nWhat type of #{item} do you want?"
            type = gets.chomp.downcase
            updateType = type.gsub(" ", "_").to_sym
            while @menu[course][updateItem].key?(updateType) == false
                puts "Please enter a valid item name."
                puts "\nWhat type of #{item} do you want?"
                type = gets.chomp.downcase
                updateType = type.gsub(" ", "_").to_sym
            end
            price = @menu[course][updateItem][updateType]
            puts "\nHow many #{type} #{item}(s) would you like?"
            quantity = gets.chomp.to_i
            while quantity * price > @budget
                max = @budget/price
                puts "The maximum number of #{type} #{item}(s) you can buy is #{max}."
                puts "\nHow many #{type} #{item} would you like?"
                quantity = gets.chomp.to_i
            end
            while quantity.zero? == true or quantity < 0
                puts "Please enter a positive number."
                puts "\nHow many of #{type} #{item} would you like?"
                quantity = gets.chomp.to_i
            end
            @items[(quantity.to_s + "*" + type + "_" + item).to_sym] = price * quantity
        else
            price = @menu[course][updateItem]
            puts "\nHow many #{item}(s) would you like?"
            quantity = gets.chomp.to_i
            while quantity.zero? == true or quantity < 0
                puts "Please enter a positive number."
                puts "\nHow many of #{item} would you like?"
                quantity = gets.chomp.to_i
            end
            while quantity * price > @budget
                max = @budget/price
                puts "The maximum number of #{type} #{item}(s) you can buy is #{max}."
                puts "\nHow many #{item} would you like?"
                quantity = gets.chomp.to_i
            end
            @items[(quantity.to_s + "*" + item).to_sym] = price * quantity
        end
        @total += price * quantity
        @budget -= price * quantity
        printf("\nYour total is $%.2f, and your budget is now $%.2f\n", @total, @budget)
        puts "You have bought: #{@items.keys.join("(s), ").gsub("*", " ").gsub("_", " ")}(s)"
    end
    def receipt()
        rows = []
        table = Terminal::Table.new
        table.title = "Your Receipt             "
        rows << ["Item", "Total"]
        @items.each do |item, price|
	        rows << [item.to_s.gsub("*", " * "), '%.2f' % price]
    	end
    	rows << [" ", " "]
    	rows << ["Total:", "$" + '%.2f' % @total]
    	rows << ["Tips: ", "$" + '%.2f' % @tips]
    	rows << ["Change: ", "$" + '%.2f' % @budget]
    	table.rows = rows
    	table.style.border_x = " "
    	table.style.border_y = " "
    	table.style.border_i = " "
    	table.style = {:all_separators => false}
    	table.style = {:width => 60}
    	puts table
    end
    def tips()
        puts "\nHow much would you like to tip? (percent)"
        percent = (gets.chomp.to_f)/100

        while percent.zero? == true
            puts "Please enter a positive number."
            puts "\nHow much would you like to tip?"
            percent = (gets.chomp.to_f)/100
        end
        while percent < 0
            puts "Please enter a positive number."
            puts "\nHow much would you like to tip?"
            percent = (gets.chomp.to_f)/100
        end
        while percent * @total > @budget
            bigTip = @budget / (@total)
            puts "The biggest tip you can give is #{bigTip}."
            puts "\nHow much would you like to tip?"
            percent = (gets.chomp.to_f)/100
        end
        @tips = percent * @total
        @budget -= @tips
    end
end

puts "Welcome to LLC Restaurant!
What is your budget?"
budget = gets.chomp.to_i
while budget.zero? == true or budget < 0
    puts "Please enter a positive number."
    puts "\nWhat is your budget?"
    budget = gets.chomp.to_i
end
puts "These are the options that fit your budget:"

test = Restaurant.new(budget)
test.menu()

test.buy()
puts "\nWould you like to purchase another item?"
purchaseAgain = gets.chomp.downcase

while purchaseAgain != "no" and purchaseAgain != "yes"
   puts "Please enter yes or no."
   puts "\nWould you like to purchase another item?"
   purchaseAgain = gets.chomp.downcase
end

while purchaseAgain == "yes"
    puts "These are the options that fit your new budget:"
    test.menu()
    test.buy()
    puts "Would you like to purchase another item?"
    purchaseAgain = gets.chomp.downcase
end

puts "\nWould you like to tip?"
tipAnswer = gets.chomp.downcase
while tipAnswer != "no" and tipAnswer != "yes"
   puts "Please enter yes or no."
   puts "\nWould you like to tip?"
   tipAnswer = gets.chomp.downcase
end
if tipAnswer == "yes"
    test.tips()
end

puts "\nWould you like a receipt?"
receipt = gets.chomp().downcase

while receipt != "no" and receipt != "yes"
    puts "Please enter yes or no."
    puts "\nWould you like a receipt?"
    receipt = gets.chomp().downcase
end

if receipt == "yes"
    puts "\n"
    test.receipt()
end

puts "\nThank you for coming to LLC Restaurant!"
puts "\nEnjoy your meal!"