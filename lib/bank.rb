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
    return "No account" if accounts[person.name] == nil
    return "Insufficient funds" if person.cash < amount
    @accounts[person.name] += amount
    person.cash -= amount
  end

  def withdrawl(person, amount)
    return "No account" if accounts[person.name] == nil
    return "Insufficient funds" if accounts[person.name] < amount
    @accounts[person.name] -= amount
    person.cash += amount
  end

  def transfer(person, bank, amount)
    return "No account" if accounts[person.name] == nil || bank.accounts[person.name] == nil
    return "Insufficient funds" if accounts[person.name] < amount
    @accounts[person.name] -= amount
    bank.accounts[person.name] += amount
  end

  def total_cash
    @accounts.values.reduce(:+)
  end
end
