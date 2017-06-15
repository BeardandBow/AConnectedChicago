# 47 plus its reverse (47 => 74) add together to a number (121) which is a palindrome
# starting at 0, find the first 25 numbers that have this same characteristic where the
# palindrome is greater than 1000

# your code goes here
def palindrome(number)
  palindromes = []
  i = 1
  until palindromes.count == number
    potential_palindrome = i + i.to_s.reverse.to_i
    if potential_palindrome > 1000 && potential_palindrome == potential_palindrome.to_s.reverse.to_i
      palindromes << i
    end
    i += 1
  end
  puts(palindromes)
end

palindrome(25)
