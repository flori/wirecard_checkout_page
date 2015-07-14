require 'spec_helper'

describe WirecardCheckoutPage::Fingerprint do

  describe '#to_s' do

    it 'returns the calculated fingerprint' do
      fp = described_class.new '123', %w[a secret b c], %w[b c], {'a' => 'A'}
      expect(fp.to_s).to eq Digest::MD5.hexdigest 'A123'

      fp = described_class.new '123', %w[a b secret c], %w[b c], {'a' => 'A', 'c' => 'C'}
      expect(fp.to_s).to eq Digest::MD5.hexdigest 'A123C'
    end
  end

  describe '#fingerprinted_params' do
    it 'returns the params with fingerprint and order' do
      fp = described_class.new '123', %w[a secret b c], %w[b c], {'a' => 'A'}
      fp_str = Digest::MD5.hexdigest 'A123'
      expect(fp.fingerprinted_params).to eq({
            'a'                       => 'A',
            'requestFingerprint'      => fp_str,
            'requestFingerprintOrder' => 'a,secret'
          })

      fp = described_class.new '123', %w[a b secret c], %w[b c], {'a' => 'A', 'c' => 'C'}
      fp_str = Digest::MD5.hexdigest 'A123C'
      expect(fp.fingerprinted_params).to eq({
            'a'                       => 'A',
            'c'                       => 'C',
            'requestFingerprint'      => fp_str,
            'requestFingerprintOrder' => 'a,secret,c'
          })
    end
  end
end
