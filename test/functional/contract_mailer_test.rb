require 'test_helper'

class ContractMailerTest < ActionMailer::TestCase
  test "new_contract" do
    mail = ContractMailer.new_contract
    assert_equal "New contract", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "contract_executed" do
    mail = ContractMailer.contract_executed
    assert_equal "Contract executed", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "contract_rejected" do
    mail = ContractMailer.contract_rejected
    assert_equal "Contract rejected", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "contract_accepted" do
    mail = ContractMailer.contract_accepted
    assert_equal "Contract accepted", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
