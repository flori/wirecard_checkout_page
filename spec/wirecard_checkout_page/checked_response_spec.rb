require 'spec_helper'

describe WirecardCheckoutPage::CheckedResponse do
  it 'is not succcessful if invalid' do
    checked_response = WirecardCheckoutPage::CheckedResponse.new(
      paymentState: 'SUCCESS'
    )
    allow(checked_response).to receive(:valid?).and_return(false)
    expect(checked_response).to_not be_success
  end

  it 'is not succcessful if paymentState is not "SUCCESS"' do
    checked_response = WirecardCheckoutPage::CheckedResponse.new(
      paymentState: 'SOMETHING'
    )
    allow(checked_response).to receive(:valid?).and_return(true)
    expect(checked_response).to_not be_success
  end

  it 'is succcessful if valid and paymentState "SUCCESS"' do
    checked_response = WirecardCheckoutPage::CheckedResponse.new(
      paymentState: 'SUCCESS'
    )
    allow(checked_response).to receive(:valid?).and_return(true)
    expect(checked_response).to be_success
  end
end
