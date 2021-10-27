class B
  def caps
    print("p")
  end

  private def method_missing(symbol, *args)
    names_of_right_defs = []
    given_name = symbol.to_s
    subname_size = (given_name.size / 2).floor
    all_names = self.methods
    all_names.map!(&:to_s)
    all_names.each do |name|
      index = 0
      given_name.each_char do
        break if index + subname_size == given_name.size - 1
        index += 1
        slice = given_name.slice(index, subname_size)
        names_of_right_defs << name.to_sym if name.include?(slice) && !names_of_right_defs.include?(name)
      end
    end
    unless names_of_right_defs.empty?
      print("We found #{names_of_right_defs.count} similar methods to #{given_name.inspect}.\n")
      names_of_right_defs.each_with_index do |name, index|
        puts "#{index + 1}: #{name}"
      end
      print "Do you want to use one of the following methods?(y/n): "
      input = gets
      input.strip!.downcase! unless input.nil?
      if input == "y"
        print "Which one of the following methods?(num): "
        begin
          input = gets.strip.to_i - 1
          self.send((names_of_right_defs[input]).to_sym, args)
        rescue ArgumentError
          self.send((names_of_right_defs[input]).to_sym)
        end

      end
    end
    print("We did not find any methods that match #{given_name.inspect}.") if names_of_right_defs.empty?
    if input == "n"
      print "Do you want to create a new #{given_name.inspect} method? (y/n): "
      input = gets.strip.downcase
      if input == "y"
        print "Input block: "
        input = gets.chomp
        self.class.class_eval do
          define_method given_name do |*args|
            eval input
          end

        end
        self.send(given_name.to_sym)
      else
        raise NoMethodError
      end

    end
  end

end

class A < B
  def ent
    print("a")
  end
end

A.new.aps(1,2)
