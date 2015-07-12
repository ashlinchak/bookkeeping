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
  describe Entry do
    before(:all){ @user = FactoryGirl.create :user }

    describe "Validation" do
      before(:each){ @entry = FactoryGirl.build :entry }

      it { should validate_presence_of(:transactionable) }
      it { should validate_presence_of(:description) }

      it "should have credit amount" do
        expect(@entry.valid?).to be false
        expect(@entry.errors[:credit_amounts].blank?).to be false
      end

      it "should have debit amount" do
        expect(@entry.valid?).to be false
        expect(@entry.errors[:debit_amounts].blank?).to be false
      end

      it "should have equal amounts" do
        @entry.debit_amounts.build(amount: 100)
        @entry.credit_amounts.build(amount: 10)

        expect(@entry.valid?).to be false
        expect(@entry.errors[:amounts_equality].blank?).to be false
      end
    end

    describe "Methods" do

      describe '.prepare' do

        before(:all) do
          @credits = FactoryGirl.create :credits, accountable: @user
          @income = FactoryGirl.create :income, accountable: @user
        end

        it 'should set description' do
          description = "description"
          entry = Entry.prepare do
            description description
          end

          expect(entry.description).to eq description
        end

        it 'should set transactionable' do
          entry = Entry.prepare do
            debit @credits, 100
            transactionable @user
          end
          expect(entry.transactionable).to eq @user
        end

        it 'should has debit amounts' do
          entry = Entry.prepare do
            debit @credits, 100
          end
          expect(entry.debit_amounts.any?).to be true
        end

        it 'should be valid' do
          entry = Entry.prepare do
            transactionable @user
            description "description"
            debit @credits, 100
            credit @income, 100
          end
          entry.save!

          expect(entry.valid?).to be true
          expect(Account.balanced?).to be true
        end
      end

      describe '.rollback' do

        before(:all) do
          @credits = FactoryGirl.create :credits, accountable: @user
          @income = FactoryGirl.create :income, accountable: @user
        end

        it "should rollback transactionable" do
          entry = Entry.prepare do
            transactionable @user
            description "description"
            debit @credits, 100
            credit @income, 100
          end
          entry.save!

          expect(@credits.balance).to eq 100
          expect(@income.balance).to eq 100

          rollback_entry = entry.rollback
          rollback_entry.save

          expect(entry.rollback_entry).to eq rollback_entry
          expect(@credits.balance).to eq 0
          expect(@income.balance).to eq 0
        end
      end
    end
  end
end
