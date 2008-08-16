require 'thread'

class Account
  attr_reader :amount
  
  def initialize(initial_amount)
    @amount = initial_amount
    @mutex = Mutex.new
  end

  def debit(amount)
    @mutex.synchronize do
      @amount -= amount
    end
  end

  def credit(amount)
    @mutex.synchronize do
      @amount += amount
    end
  end
end

Threads = (ARGV[0] || 10).to_i
Iterate = 100000
Total = Threads * Iterate

puts "Crediting Account using #{Threads} threads"

A = Account.new(0)

threads = (0...Threads).map {
  Thread.new do
    Iterate.times do
      A.credit(1)
    end
  end
}

threads.each do |t| t.join end

puts "Account A: #{A.amount}"
puts "Should be: #{Total}"

if A.amount < Total
  puts "There is #{Total-A.amount} missing"
elsif A.amount > Total
  puts "There is #{A.amount-Total} extra"
end
   

