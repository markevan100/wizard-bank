require '../lib/person'
class Bank

  attr_accessor :name, :accounts
  def initialize(name)
    @name = name
    @accounts = {}
  end

  def open_account(person)
    @accounts[person.name] = 0
  end

  def deposit(person, amount)
    validate_transaction(person, amount)
    @accounts[person.name] += amount
    person.cash -= amount
  end

  def withdrawl(person, amount)
    validate_transaction(person, amount)
    @accounts[person.name] -= amount
    person.cash += amount
  end

  def transfer(person, bank, amount)
    validate_transaction(person, amount)
    @accounts[person.name] -= amount
    bank.accounts[person.name] += amount
  end

  def total_cash
    @accounts.values.reduce(:+)
  end
  
  private
    def validate_transaction(person, amount)
      raise NoAccountError.new("No account found") if accounts[person.name] == nil
      raise InsufficientFundsError.new("Not enough money") if person.cash < amount
    end
    
  class NoAccountError < StandardError; end
  class InsufficientFundsError < StandardError; end
end

