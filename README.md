= Bookkeeping

Double Entry Bookkeeping System for Rails


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bookkeeping'
```

And then execute:

    $ bundle


## Usage

    rails g bookkeeping
    rake db:migrate


## Basic theory

<http://en.wikipedia.org/wiki/Debits_and_credits>

In Double Entry Accounting there are 5 account types: Asset, Liability, Income,
Expense and Equity defined as follows:

**Asset** is a resource controlled by the entity as a result of past events and
from which future economic benefits are expected to flow to the entity

**Liability** is defined as an obligation of an entity arising from past
entries or events, the settlement of which may result in the transfer or
use of assets, provision of services or other yielding of economic benefits in
the future.

**Income** is increases in economic benefits during the accounting period in
the form of inflows or enhancements of assets or decreases of liabilities that
result in increases in equity, other than those relating to contributions from
equity participants.

**Expense** is a decrease in economic benefits during the accounting period in
the form of outflows or depletions of assets or incurrences of liabilities that
result in decreases in equity, other than those relating to distributions to
equity participants.

**Equity** consists of the net assets of an entity. Net assets is the
difference between the total assets of the entity and all its liabilities.


## Accounting Equation

At any given point accounts should satisfy the following equation:

    Assets + Expenses = Liabilities + Equity + Income

You can verify it with `Account.balanced?`.


## Accounts

There are only 5 types of accounts `Bookkeeping::AssetAccount`,
`Bookkeeping::LiabilityAccount`, `Bookkeeping::IncomeAccount`, `Bookkeeping::ExpenseAccount` and `Bookkeeping::EquityAccount`

You can create own accounts with target type like this:
```ruby
    Bookkeeping::AssetAccount.create name: 'cash'
```
or
```ruby
    @user.accounts.asset.create name: 'cash'
```
or
```ruby
    Bookkeeping::AssetAccount.create name: 'cash', accountable: @user
```
    
By default account can have a negative balance. If you don't want to use a negative balance for this account you can set overdraft_enabled: false


## Accountable

Every account belongs to accountable. It can be user, company etc. If you want add bookkeping accounts for the User model you can do like this:

```ruby
    class User
      include Bookkeeping::Extension

      has_accounts do
        income :income
        asset :cash
        expense :rent, false # if you don't want negative balance
      end
    end
```

## Entries

For perform accounting operations you have to create entries. You can do it using gem DSL:

```ruby
    entry = Bookkeeping::Entry.prepare(description: "Got invoice", transactionable: @invoice) do
        debit @user.accounts.expense, 100
        credit @user.accounts.cash, 50
        credit @user.accounts.debt, 50
    end

    entry.save!
```
or, if you prefere to use only DSL methods:

```ruby
    entry = Bookkeeping::Entry.prepare do
        desription "Got inovoice"
        transactionable @invoice
        debit @user.accounts.expense, 100
        credit @user.accounts.cash, 50
        credit @user.accounts.debt, 50
    end

    entry.save!
```

Entry must have an equality of sum amounts for it's debits and credits.

You can rollback entries:

```ruby
    @entry.rollback!
```

## Contributing

1. Fork it ( https://github.com/ashlinchak/bookkeeping/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
