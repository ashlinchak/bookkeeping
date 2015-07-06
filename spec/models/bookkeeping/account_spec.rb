# == Schema Information
#
# Table name: bookkeeping_accounts
#
#  id                :integer          not null, primary key
#  name              :string
#  type              :string
#  overdraft_enabled :boolean          default(TRUE), not null
#  accountable_id    :integer
#  accountable_type  :string
#  created_at        :datetime
#  updated_at        :datetime
#

require 'rails_helper'

module Bookkeeping
  describe Account do

    describe "Methods" do
      before(:each){ @credits = FactoryGirl.create :credits }

      describe '.by_kind' do
        it 'should find account class by kind' do
          klass = Account.by_kind(:asset)
          expect(klass).to eq AssetAccount
        end
      end

      describe '[]' do
        it 'should find account by name' do
          expect(Account[:credits]).to eq(@credits)
        end

        it 'should not found and raise error if none exist and not kind provided' do
          expect{ Account[:foo] }.to raise_error(Account::NotFound)
        end

        it 'should raise error if kind not exist' do
          expect{ Account[:foo, :foo] }.to raise_error(Account::BadKind)
        end

        it 'should raise error on not correct kind' do
          expect{ Account[:credits, :expense] }.to raise_error(Account::BadKind)
        end

        it 'should create account if name not exist and provided kind' do
          expect{ 
            foo = Account[:foo, :asset]
            expect(foo.class).to eq AssetAccount
            expect(foo.name).to eq "foo"
          }.to change(Account, :count).by(1)
        end

        it "should enable overdraft by default" do
          expect(@credits.overdraft_enabled).to be true
        end

        it "should disable overdraft if it set" do
          foo = Account[:foo, :asset, false]
          expect(foo.overdraft_enabled).to be false
        end

        it "should create account with accountable" do
          user = FactoryGirl.create :user

          foo = user.accounts[:foo, :asset]
          expect(foo.accountable).to eq user
          expect(foo.class).to eq AssetAccount
          expect(foo.name).to eq 'foo'
        end
      end

      describe '.total_balance' do
        it 'should get total balance for all accounts' do
          expect(Account.total_balance).to eq 0
        end
      end

      describe '.balanced?' do
        it 'should return true' do
          expect(Account.balanced?).to be true
        end
      end

      describe '#debits_balance' do
        it 'should return 0' do
          expect(@credits.debits_balance).to eq 0
        end
      end

      describe '#credits_balance' do
        it 'should return 0' do
          expect(@credits.credits_balance).to eq 0
        end
      end

      describe '#overdraft?' do
        it 'should return false' do
          expect(@credits.overdraft?).to be false
        end
      end
    end

  end
end
