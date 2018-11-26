require '../lib/person'
class Credit

  attr_accessor :accounts
  def initialize(name)
    @name = name
    @accounts = {}
  end

  def open_credit(person, limit, rate)
    @accounts[person.name] = [limit, rate]
  end

  def spend(person, amount)
    return "Insufficient funds" if accounts[person.name][0] < amount
    @accounts[person.name][0] -= amount
  end

  def pay(person, amount)
    return "Insufficient funds" if person.cash < amount
    @accounts[person.name][0] += amount
    person.cash -= amount
  end
end
