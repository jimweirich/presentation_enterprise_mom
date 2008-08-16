require 'thread'

class Account
  attr_reader :amount, :priority
  
  def initialize(initial_amount)
    @amount = initial_amount
    @priority = self.class.allocate_priority
    @mutex = Mutex.new
  end

  def debit(amount)
    @amount -= amount
  end

  def credit(amount)
    @amount += amount
  end

  def synchronize(&block)
    @mutex.synchronize(&block)
  end

  class << self
    def allocate_priority
      @last_priority ||= 0
      @last_priority += 1
      @last_priority
    end
  end
end

Threads = 5

puts "Laundering funds through each account"

def transfer(from_acct, to_account)
  first, second = [from_acct, to_account].sort_by { |a| a.priority }
  first.synchronize do
    sleep(1)
    second.synchronize do
      if from_acct.amount > 0
        from_acct.debit(1)
        to_account.credit(1)
      end
    end
  end
end

Accounts = (0...Threads).map { Account.new(1_000_000) }

threads = (0...Threads).map { |i|
  Thread.new do
    from_account = Accounts[i]
    to_account = Accounts[(i+1) % Threads]
    transfer(from_account, to_account)
  end
}

threads.each do |t| t.join end

Accounts.each_with_index do |acct, i|
  puts "Account #{i}: #{acct.amount}"
end
