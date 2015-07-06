class User < ActiveRecord::Base
  include Bookkeeping::Extension

  has_accounts do
    asset :credits
    expense :rent, false
  end
end
