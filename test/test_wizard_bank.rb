gem 'minitest', '~> 5.2'
require 'mocha'
require 'minitest/unit'
require 'mocha/minitest'
require 'minitest/autorun'
require 'minitest/pride'
require '../lib/person'
require '../lib/bank'
require '../lib/credit'

class BankTest < Minitest::Test

  def setup
    @person1 = Person.new("Minerva", 1000)
    @wells_fargo = Bank.new("Wells Fargo")
    @visa = Credit.new("Visa")
  end

  # Person file tests

  def test_person_exists
    assert_equal @person1.name, "Minerva"
    assert_equal @person1.cash, 1000
  end

  # Bank file tests

  def test_bank_exists
    assert_equal @wells_fargo.name, "Wells Fargo"
    assert_instance_of Bank, @wells_fargo
  end

  def test_accounts_bank_starts_with_no_accounts
    assert_equal @wells_fargo.accounts, {}
  end

  # Bank and Person file tests

  def test_open_account_bank_can_have_costumers
    @wells_fargo.open_account(@person1)
    assert_equal @wells_fargo.accounts["Minerva"], 0
  end

  def test_deposit_cash_goes_down_account_goes_up
    @wells_fargo.open_account(@person1)
    @wells_fargo.deposit(@person1, 750)
    assert_equal @wells_fargo.accounts["Minerva"], 750
    assert_equal @person1.cash, 250
  end

  def test_deposit_person_without_account_cannot_deposit
    exception = assert_raises Bank::NoAccountError do
      @wells_fargo.deposit(@person1, 750)
    end
    assert_equal "No account found", exception.message
  end

  def test_deposit_cant_deposit_more_than_you_have
    @wells_fargo.open_account(@person1)
    
    exception = assert_raises do
      @wells_fargo.deposit(@person1, 1050)
    end
    assert_equal "Not enough money", exception.message
  end

  def test_withdrawl_cash_goes_up_balence_down
    @wells_fargo.open_account(@person1)
    @wells_fargo.deposit(@person1, 750)
    @wells_fargo.withdrawl(@person1, 150)
    assert_equal @wells_fargo.accounts["Minerva"], 600
    assert_equal @person1.cash, 400
  end

  def test_withdrawl_cant_withdrawl_more_than_you_have
    @wells_fargo.open_account(@person1)
    exception = assert_raises Bank::InsufficientFundsError do
      @wells_fargo.withdrawl(@person1, 1050)
    end
    assert_equal Bank::InsufficientFundsError, exception.class
    assert_equal "Not enough money", exception.message
  end

  def test_transfer_to_another_bank
    chase = Bank.new("Chase")
    @wells_fargo.open_account(@person1)
    chase.open_account(@person1)
    chase.deposit(@person1, 100)
    chase.transfer(@person1, @wells_fargo, 50)
    assert_equal chase.accounts["Minerva"], 50
    assert_equal @wells_fargo.accounts["Minerva"], 50
  end

  def test_transfer_to_bank_where_no_account
    chase = Bank.new("Chase")
    assert_raises Bank::NoAccountError do
      @wells_fargo.transfer(@person1, chase, 50)
    end
  end


  def test_transfer_cannot_transfer_more_than_you_have
    chase = Bank.new("Chase")
    @wells_fargo.open_account(@person1)
    chase.open_account(@person1)
    assert_raises Bank::InsufficientFundsError do
      chase.transfer(@person1, @wells_fargo, 2000)
    end
  end

  def test_total_cash_in_all_accounts_in_a_bank
    
    @wells_fargo.open_account(@person1)
    @wells_fargo.deposit(@person1, 750)
    person2 = Person.new("Tim", 650)
    @wells_fargo.open_account(person2)
    @wells_fargo.deposit(person2, 650)
    assert_equal 1400, @wells_fargo.total_cash
  end

  # Credit file tests

  def test_credit_exists
    assert_instance_of Credit, @visa
  end

  # Credit and Person file tests

  def test_open_credit
    @visa.open_credit(@person1, 100, 0.05)
    assert_equal @visa.accounts[@person1.name][0], 100
  end

  def test_spend_on_credit
    @visa.open_credit(@person1, 100, 0.05)
    @visa.spend(@person1, 50)
    assert_equal @visa.accounts[@person1.name][0], 50
  end

  def test_spend_cant_spend_above_limit
    @visa.open_credit(@person1, 100, 0.05)
    assert_equal "Insufficient funds", @visa.spend(@person1, 150)
  end

  def test_pay_limit_increases
    @visa.open_credit(@person1, 100, 0.05)
    @visa.pay(@person1, 30)
    assert_equal @visa.accounts[@person1.name][0], 130
  end

  def test_pay_cant_pay_more_than_your_cash
    @visa.open_credit(@person1, 100, 0.05)
    assert_equal "Insufficient funds", @visa.pay(@person1, 150000)
  end
end
