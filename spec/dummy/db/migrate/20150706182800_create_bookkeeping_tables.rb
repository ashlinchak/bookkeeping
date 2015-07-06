class CreateBookkeepingTables < ActiveRecord::Migration
  def self.up
    create_table :bookkeeping_accounts do |t|
      t.string :name
      t.string :type
      t.boolean :overdraft_enabled, null: false, default: :true
      t.references :accountable, polymorphic: true
      t.timestamps
    end

    add_index :bookkeeping_accounts, :accountable_id
    add_index :bookkeeping_accounts, :accountable_type

    create_table :bookkeeping_entries do |t|
      t.string :description
      t.references :transactionable, polymorphic: true
      t.integer :rollback_entry_id
      t.timestamps
    end

    add_index :bookkeeping_entries, :transactionable_id
    add_index :bookkeeping_entries, :transactionable_type


    create_table :bookkeeping_amounts do |t|
      t.string :type
      t.boolean :is_debit, default: true, null: false
      t.integer :account_id
      t.integer :entry_id
      t.decimal :amount, precision: 20, scale: 2, default: 0
    end

    add_index :bookkeeping_amounts, :account_id
    add_index :bookkeeping_amounts, :entry_id

  end

  def self.down
    drop_table :bookkeeping_accounts
    drop_table :bookkeeping_entries
    drop_table :bookkeeping_amounts
  end
end

