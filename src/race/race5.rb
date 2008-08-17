require 'thread'

class Account
  attr_reader :amount
  
  def initialize(initial_amount)
    @amount = initial_amount
  end

  def debit(amount)
    @amount -= amount
  end

  def credit(amount)
    @amount += amount
  end
end

Threads = (ARGV[0] || 25).to_i

puts "Transfering Funds from A to B using #{Threads} threads"

A = Account.new(100_000)
B = Account.new(0)

mutex = Mutex.new
threads = (0...Threads).map {
  Thread.new do
    while A.amount > 0
      mutex.synchronize do
        if A.amount > 0
          A.debit(1)
          B.credit(1)
        end
      end
    end
  end
}

threads.each do |t| t.join end

puts "Account A: #{A.amount}"
puts "Account B: #{B.amount}"
